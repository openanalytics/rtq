
#' Lightweight Reliable Task Queue - Start processing a task item
#' @rdname leaseTask
#' @param tq Task Queue
#' @param blocking block until a message is available
#' @param blockTimeout maximum amount of time to wait until a message is available
#' @param leaseTimeout maximum amount of time (in seconds) to lease a messsage
#' @examples \dontrun{
#' tq <- "Task Queue backend"
#' createTask(tq, "some imporant task")
#' item <- leaseTask(tq)
#' completeTask(item)
#' }
#' @seealso \code{\link{leaseTask}} \code{\link{completeTask}} \code{\link{createTask}}
#' @export
leaseTask <- function(
    tq,
    blocking,
    blockTimeout,
    leaseTimeout) {
  
  UseMethod("leaseTask")
  
}
#' Lightweight Reliable Task Queue - Stop processing a task item
#' @rdname completeTask
#' @param tq Task Queue
#' @param item item obtained from \code{\link{leaseTask}}
#' @seealso \code{\link{leaseTask}} \code{\link{completeTask}} \code{\link{createTask}}
#' @export
completeTask <- function(tq, item) {
  
  UseMethod("completeTask")
  
}
#' Lightweight Reliable Task Queue - Add a task item
#' @rdname createTask
#' @param tq Task Queue
#' @param item task item to add
#' @seealso \code{\link{leaseTask}} \code{\link{completeTask}} \code{\link{createTask}}
#' @export
createTask <- function(tq, item) {
  
  UseMethod("createTask")
  
}
#' Lightweight Reliable Task Queue - Check for task item availability
#' @rdname existsTask
#' @param tq Task Queue
#' @seealso \code{\link{leaseTask}} \code{\link{completeTask}} \code{\link{createTask}}
#' @export
existsTask <- function(tq) {
  
  UseMethod("existsTask")
  
}