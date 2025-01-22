#' Dublin Airport Climate Data (1981–2010)
#'
#' This dataset contains climate averages recorded at Dublin Airport for the period 1981–2010.
#' The data includes mean monthly temperature, daily sunshine duration (in hours), and total monthly rainfall.
#'
#' @format A data frame with 12 observations on the following 4 variables:\cr
#' \describe{
#' \item{\code{Month}}{The month of the year, represented as a character string (e.g., \code{"January"}).}
#' \item{\code{Mean Temperature}}{The mean temperature in degrees Celsius (numeric).}
#' \item{\code{Mean Daily Sunshine (hours)}}{The mean daily sunshine duration in hours (numeric).}
#' \item{\code{Mean Rainfall}}{The total monthly rainfall in millimeters (numeric).}
#' }
#' @details The data was sourced from \href{https://data.gov.ie}{data.gov.ie} and represents averages for each month based on climate records from Dublin Airport between 1981 and 2010. The dataset has been cleaned and transformed for use in this package.
#' @source \url{https://data.gov.ie/dataset/af51e908-b723-4126-9929-004b48d79b80}
#' @examples
#' data(dublin_airport)
#' summary(dublin_airport)
#' plot(dublin_airport$`Mean Temperature`, type = "o", main = "Mean Monthly Temperature",
#'      xlab = "Month", ylab = "Temperature ( degrees celcius)", xaxt = "n")
#' axis(1, at = 1:12, labels = dublin_airport$Month)
#' @docType data
#' @keywords datasets
#' @usage data(dublin_airport)
#' @name dublin_airport
#' @aliases dublin_airport


dublin_airport <- read.csv(
  "https://data.gov.ie/dataset/af51e908-b723-4126-9929-004b48d79b80/resource/5f9771a4-657e-44d6-9f96-8816691dd5fc/download/dublinairport_climate_averages_1981_2010.csv",
  header = FALSE
)

colnames(dublin_airport) <- dublin_airport[2, ]
dublin_airport <- dublin_airport[-c(1, 2), ]

dublin_airport <- janitor::clean_names(dublin_airport)

dublin_airport <- dublin_airport[
  dublin_airport$temperature_degrees_celsius %in%
    c("mean temperature", "mean daily duration", "mean monthly total"),
]


transposed_data <- as.data.frame(t(dublin_airport))

colnames(transposed_data) <- c(
  "Mean Temperature",
  "Mean Daily Sunshine (hours)",
  "Mean Rainfall"
)


transposed_data <- transposed_data[-1, ]


transposed_data$`Mean Temperature` <- as.numeric(transposed_data$`Mean Temperature`)
transposed_data$`Mean Daily Sunshine (hours)` <- as.numeric(transposed_data$`Mean Daily Sunshine (hours)`)
transposed_data$`Mean Rainfall` <- as.numeric(transposed_data$`Mean Rainfall`)


transposed_data <- transposed_data[1:12, ]


dublin_airport <- tibble::rownames_to_column(transposed_data, var = "Month")

dublin_airport




#' Dublin Airport Data Constructor
#'
#' A constructor function for assigning the class \code{dublinairport} to a data frame.
#' This function checks that the input is a data frame and adds a custom class for easier identification and use within the package.
#'
#' @param data A data frame to which the \code{dublinairport} class will be assigned.
#' @return A data frame with the class \code{dublinairport}.
#' @examples
#'  #Example 1 : assigning class to a data set
#' data <- data.frame(Month = c("January", "February"),
#'                    `Mean Temperature` = c(5.0, 5.5),
#'                    `Mean Daily Sunshine (hours)` = c(2.5, 2.7),
#'                    `Mean Rainfall` = c(75.0, 62.0))
#' dublin_airport_obj <- dublinairport(data)
#' class(dublin_airport_obj)
#'
#' #Example 2: Checking for invalid input to the function
#' #This will give an error because the input needs to be a data frame
#' invalid_input <- list(a=1,b=2)
#' try(dublinairport(invalid_input))
#' @export



dublinairport <- function(data) {
  if (!is.data.frame(data)) {
    stop("Input must be a data frame.")
  }
  class(data) <- c("dublinairport", class(data))
  return(data)
}

dublin_airport <- dublinairport(dublin_airport)

usethis::use_data(dublin_airport, compress = "xz", overwrite = TRUE)




