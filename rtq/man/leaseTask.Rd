% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/S3.R, R/redis.R
\name{leaseTask}
\alias{leaseTask}
\alias{leaseTask.RedisTQ}
\title{Lightweight Reliable Task Queue - Start processing a task item}
\usage{
leaseTask(tq, blocking, blockTimeout, leaseTimeout)

\method{leaseTask}{RedisTQ}(tq, blocking = TRUE, blockTimeout = 10,
  leaseTimeout = 600)
}
\arguments{
\item{tq}{Task Queue}

\item{blocking}{block until a message is available}

\item{blockTimeout}{maximum amount of time to wait until a message is available}

\item{leaseTimeout}{maximum amount of time (in seconds) to lease a messsage}
}
\description{
Lightweight Reliable Task Queue - Start processing a task item
}
\examples{
\dontrun{
tq <- "Task Queue backend"
createTask(tq, "some imporant task")
item <- leaseTask(tq)
completeTask(item)
}
}
\seealso{
\code{\link{leaseTask}} \code{\link{completeTask}} \code{\link{createTask}}

\code{\link{RedisTQ}}
}
