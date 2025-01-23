#' Load the Dublin Airport Dataset
#'
#' This function loads the Dublin Airport weathR package.
#' The dataset contains climate averages recorded at Dublin airport for the period of 1981 - 2010.
#' @return A data frame containing the metric averages for Dublin Airport, with the following columns.
#' \describe{
#' \item{\code{Mean Temperature}}{The mean temperature in degrees celcius}
#' \item{\code{Mean Daily Sunshine (hours)}}{The mean daily sunshine duration in hours.}
#' \item{\code{Mean Rainfall}}{The total monthly rainfall in millimeters.}
#' }
#' @details IF the dataset is not already loaded in the environment, the function automatically loads it.
#' It also varifies the structure of the dataset before returning it.
#'
#' @examples
#' #Load the dataset
#' data <- load_dublinairport()
#'
#' #View the first few rows
#' head(data)
#'
#' @export

load_dublinairport <- function() {

  if (!exists("dublin_airport", envir = .GlobalEnv)) {
    warning("The dataset 'dublin_airport' is not loaded into your environment. Loading it now.")
    utils::data("dublin_airport", package = "WeathR")
  }

  if (!all(c("Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall") %in% names(dublin_airport))) {
    stop("The dataset structure is invalid. Check that it contains the expected columns.")
  }

 class(dublin_airport) <- "dublinairport"

  return(dublin_airport)
}


