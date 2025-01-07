summarise.dublinairport <- function(object, filter_var = NULL, filter_value = NULL,
                                    summary_func = mean, correlation = TRUE, ...) {

  if (!inherits(object, "dublinairport")) {
    stop("The dataset must be of class 'dublinairport'")
  }

  numeric_columns <- object |>
    dplyr::select(where(is.numeric))

  if (ncol(numeric_columns) == 0) {
    stop("The dataset has no numeric columns.")
  }

  object <- if (!is.null(filter_var) && !is.null(filter_value)) {
    if (!filter_var %in% colnames(object)) {
      stop(paste("The column", filter_var, "does not exist in the dataset."))
    }
    object |> dplyr::filter(.data[[filter_var]] >= filter_value)
  } else {
    object
  }

  summary_table <- numeric_columns |>
    sapply(summary_func, ...) |>
    tibble::as_tibble()

  if (any(is.na(summary_table))) {
    warning("Some results may contain missing values.")
  }

  output <- list(summary = summary_table)

  if (correlation) {
    correlation_matrix <- numeric_columns |>
      cor(method = "pearson")

    output$correlation_matrix <- correlation_matrix
  }

  return(output)
}
