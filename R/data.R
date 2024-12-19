library(dplyr)
library(janitor)
library(tibble)

dublin_airport <- read.csv("https://data.gov.ie/dataset/af51e908-b723-4126-9929-004b48d79b80/resource/5f9771a4-657e-44d6-9f96-8816691dd5fc/download/dublinairport_climate_averages_1981_2010.csv",
                           header = FALSE)

colnames(dublin_airport) <- dublin_airport[2, ]

dublin_airport <- dublin_airport[-c(1, 2), ]

dublin_airport |>
  clean_names()

head(dublin_airport)

dublin_airport <- dublin_airport[
  dublin_airport$`TEMPERATURE (degrees Celsius)` %in%
    c("mean temperature", "mean daily duration", "mean monthly total"),
]


transposed_data <- t(dublin_airport)


transposed_data <- as.data.frame(transposed_data)

colnames(transposed_data)[1] <- "Mean Temperature"
colnames(transposed_data)[2] <- "Mean Daily Sunshine (hours)"
colnames(transposed_data)[3] <- "Mean Rainfall"



head(transposed_data)

transposed_data <- transposed_data[-1, ]

dublin_airport <- transposed_data

dublin_airport$`Mean Temperature` <- as.numeric(dublin_airport$`Mean Temperature`)
dublin_airport$`Mean Daily Sunshine (hours)` <- as.numeric(dublin_airport$`Mean Daily Sunshine (hours)`)
dublin_airport$`Mean Rainfall` <- as.numeric(dublin_airport$`Mean Rainfall`)

dublin_airport <- dublin_airport[1:12, ]

dublin_airport <- rownames_to_column(dublin_airport, var = "Month")

dublinairport <- function(data) {
  if (!is.data.frame(data)) {
    stop("Input must be a data frame.")
  }
  class(data) <- c("dublinairport", class(data))
  return(data)
}

dublin_airport <- dublinairport(dublin_airport)

usethis::use_data(dublin_airport, compress = "xz", overwrite = TRUE)


