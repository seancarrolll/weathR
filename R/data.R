
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


dublin_airport <- rownames_to_column(transposed_data, var = "Month")

dublinairport <- function(data) {
  if (!is.data.frame(data)) {
    stop("Input must be a data frame.")
  }
  class(data) <- c("dublinairport", class(data))
  return(data)
}

dublin_airport <- dublinairport(dublin_airport)

usethis::use_data(dublin_airport, compress = "xz", overwrite = TRUE)




