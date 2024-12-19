summarise.dublinairport <- function(object, filter_var = NULL, filter_value = NULL,
                                    summary_func = mean, ...) {

  if (!inherits(object, "dublinairport")) {
    stop("The dataset must be of class 'dublinairport'")
  }

  numeric_columns <- object[, sapply(object, is.numeric)]

  if (ncol(numeric_columns) == 0) {
    stop("The dataset contains no numeric columns to summarize.")
  }


  object <- if (!is.null(filter_var) && !is.null(filter_value)) {
    if (!filter_var %in% colnames(object)) {
      stop(paste("The column", filter_var, "does not exist in the dataset."))
    }
    object[object[[filter_var]] >= filter_value, ]
  } else {
    object
  }

  summary_table <- numeric_columns |>
    sapply(summary_func, ...) |>
    tibble::as_tibble()

  if (any(is.na(summary_table))) {
    warning("Some summary results may contain missing values (NA).")
  }

  return(summary_table)
}

# Examples
summarise.dublinairport(dublin_airport)
summarise.dublinairport(dublin_airport, summary_func = median)
summarise.dublinairport(dublin_airport, summary_func = quantile, probs = c(0.25, 0.5, 0.75))
summarise.dublinairport(dublin_airport, summary_func = var)




