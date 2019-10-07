
#' Lightweight Reliable Task Queue (Redis implementation)
#' @description A simple reliable task queue implemented via two lists
#' @param redisConf as returned from \code{\link[redux]{redis_config}}
#' @param name name of the queue. Used as a namespace for all used redis
#' keys to avoid key collisions.
#' @param autoHashTags auto-apply hash tags to queue keys
#' @return an object of class \code{RedisTQ}
#' @details Key hash tags are used to ensure that the main and processing
#' queues run on the same redis shard in a clustered environment.
#' (see \link{https://redis.io/topics/cluster-spec} for more info about this topic)
#' Set \code{autoHashTags} to \code{FALSE} to disable this behavior. 
#' @seealso https://kubernetes.io/examples/application/job/redis/rediswq.py
#' @import redux
#' @importFrom uuid UUIDgenerate
#' @seealso \code{\link{leaseTask}} \code{\link{completeTask}} \code{\link{createTask}}
#' @export
RedisTQ <- function(redisConf, name, autoHashTags = TRUE) {
  
  qPrefix <- if (isTRUE(autoHashTags)) sprintf("{%s}", name) else name
  
  structure(
      list(
          redisConf = redisConf,
          mainQKey = paste0(qPrefix, ":main"),
          procQKey = paste0(qPrefix, ":processing"),
          leasePrefix = paste0(name, ":lease:"),
          sessionId = UUIDgenerate()
      ), class = c("RedisTQ", "TQ", "list")
  )
  
}
#' @rdname leaseTask
#' @import redux
#' @seealso \code{\link{RedisTQ}}
#' @importFrom digest digest
#' @export
leaseTask.RedisTQ <- function(
    tq,
    blocking = TRUE,
    blockTimeout = 10,
    leaseTimeout = 600) {
  
  r <- hiredis(tq$redisConf)
  
  if (blocking) {
    item <- r$BRPOPLPUSH(tq$mainQKey, tq$procQKey, blockTimeout)
    if (is.null(item)) warning("Timeout expired")
  } else {
    item <- r$RPOPLUSH(tq$mainQKey, tq$procQKey)
  }
  
  if (!is.null(item)) {
    r$SETEX(
        key = paste0(tq$leasePrefix, digest(item, algo = "sha256")),
        seconds = leaseTimeout,
        tq$sessionId)
  }
  
  item
  
}
#' @rdname completeTask
#' @import redux
#' @seealso \code{\link{RedisTQ}}
#' @export
completeTask.RedisTQ <- function(
    tq,
    item) {
  
  r <- hiredis(tq$redisConf)
  
  r$LREM(tq$procQKey, 0, item)
  r$DEL(paste0(tq$leasePrefix, digest(item, algo = "sha256")))
  
  invisible()
  
}
#' @rdname createTask
#' @import redux
#' @importFrom jsonlite toJSON
#' @seealso \code{\link{RedisTQ}}
#' @export
createTask.RedisTQ <- function(
    tq,
    item) {
  
  if (!is.character(item)) {
    warning("item is not a string and will be converted to JSON")
    item <- toJSON(item)
  }
  
  r <- hiredis(tq$redisConf)
  
  r$LPUSH(tq$mainQKey, item)
  
}
#' @rdname existsTask
#' @import redux
#' @seealso \code{\link{RedisTQ}}
#' @export 
existsTask.RedisTQ <- function(tq) {
  
  r <- hiredis(tq$redisConf)
  
  r$LLEN(tq$mainQKey) > 0
  
}
#' @rdname listTasks
#' @import redux
#' @seealso \code{\link{RedisTQ}}
#' @export 
listTasks.RedisTQ <- function(tq) {

  r <- hiredis(tq$redisConf)
  
  list(
      "main" = r$LRANGE(tq$mainQKey, 0, -1),
      "proc" = r$LRANGE(tq$procQKey, 0, -1))
  
}

