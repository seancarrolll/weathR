library(testthat)

test_that("summarise.dublinairport returns the correct summary statistics", {
  result <- summarise.dublinairport(dublin_airport)
  expect_equal(ncol(result$summary), 2)
  expect_true(all(!is.na(result$summary)))
})

test_that("the function returns an error for invalid filter column", {
  expect_error(summarise.dublinairport(dublin_airport, filter_var = "Invalid Column", filter_value = 10))
})

test_that("summarise.dublinairport works with a custom summary function", {
  result <- summarise.dublinairport(dublin_airport, summary_func = sd)
  expect_true(is.numeric(result$summary$value))
})

test_that("summarise.dublinairport returns a correlation matrix", {
  result <- summarise.dublinairport(dublin_airport, correlation = TRUE)
  expect_true(is.matrix(result$correlation_matrix))
})

