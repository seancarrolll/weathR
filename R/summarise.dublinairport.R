#' Summarise Dublin Airport Weather Data
#'
#'Summarises numeric columns in the `dublinairport` dataset. Allows optional filtering
#' of rows based on a column and value. Calculates a correlation matrix if specified.
#'
#' @param object A dataset of the class "dublin airport".
#' @param filter_var A character string specifying the name of the column to filter by.
#'  If 'NULL', no filtering occurs. The default is \code{NULL}.
#' @param filter_value A numeric value that filters rows where \code{filter_var} is greater
#'  than or equal to this value. The default is \code{NULL}.
#' @param summary_func A function to calculate summary statistics for the numeric columns.
#'  The default is \code{mean}.
#' @param correlation A logical indicating whether to include the correlation matrix in the output. Defaults to \code{TRUE}.
#' @param ... Additional arguments used by \code{summary_func}.
#'
#' @returns A list containing:
#'  \item {summary}{A tibble of the summary statistic for the numeric columns.}
#'  \item {correlation_matrix}{A correlation matrix of the numeric columns (if 'correlation = TRUE').}
#' @export
#'
#' @examples
#' data(dublin_airport)
#'
#' result <- summarise.dublinairport(dublin_airport)
#'
#' result_with_correlation <- summarise.dublinairport(dublin_airport, correlation = TRUE)
#'
#' result_sd <- summarise.dublinairport(dublin_airport, summary_func = sd)
#'
#' result_quantiles <- summarise.dublinairport(dublin_airport,
#'                                             summary_func = quantile,
#'                                             probs = c(0.25, 0.5, 0.75))


summarise.dublinairport <- function(object, filter_var = NULL, filter_value = NULL,
                                    summary_func = mean, correlation = FALSE, ...) {

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
