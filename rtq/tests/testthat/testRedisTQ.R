
library(redux)
library(rtq)
library(jsonlite)

context("RedisTQ")

test_that("Redis Backend", {
      
      redisConf <- redis_config(
          host = Sys.getenv("REDIS_HOST", "127.0.0.1"),
          port = Sys.getenv("REDIS_PORT", "6379"))
      
      tryCatch(hiredis(redisConf)$PING(), error = skip)
      
      tq <- RedisTQ(redisConf, "test")
      
      expect_false(existsTask(tq))
      
      expect_warning(createTask(tq, list(a = "b")), "JSON")
      
      expect_true(existsTask(tq))
      
      task <- leaseTask(tq)
      
      expect_equal(fromJSON(task), (list(a = "b")))
      
      expect_false(existsTask(tq))
      
      completeTask(tq, task)
      
    })

