#' Load the Dublin Airport Dataset
#'
#' This function loads the Dublin Airport weather dataset.
#' @return A data frame containing the metric averages for Dublin Airport.
#' @export
#'

load_dublinairport <- function() {

  if (!exists("dublin_airport", envir = .GlobalEnv)) {
    warning("The dataset 'dublin_airport' is not loaded into your environment. Loading it now.")
    data("dublin_airport", package = "WeathR")
  }

  if (!all(c("Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall") %in% names(dublin_airport))) {
    stop("The dataset structure is invalid. Check that it contains the expected columns.")
  }

  class(dublin_airport) <- "dublinairport"

  return(dublin_airport)
}

