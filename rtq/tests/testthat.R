require("testthat")

options(testthat.output_file = Sys.getenv("TESTTHAT_OUTPUT_FILE", stdout()))

test_check("rtq",
    reporter = Sys.getenv("TESTTHAT_DEFAULT_CHECK_REPORTER", "check"))
