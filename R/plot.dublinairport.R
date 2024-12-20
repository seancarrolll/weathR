plot_summarise <- function(data, ...) {

  if (!is.data.frame(data) ||
      !all(c("Mean Temperature", "Mean Daily Sunshine (hours)", "Month") %in% colnames(data))) {
    stop("Input must be a data frame with columns: 'Mean Temperature', 'Mean Daily Sunshine (hours)', and 'Month'.")
  }


  if (!is.factor(data$Month)) {
    warning("The 'Month' column is not a factor. Converting it to a factor.")
    data$Month <- factor(data$Month, levels = unique(data$Month))  # Ensure correct month order
  }


  data_long <- data |>
    tidyr::pivot_longer(
      cols = c("Mean Temperature", "Mean Daily Sunshine (hours)"),
      names_to = "Metric",
      values_to = "Value"
    )


  if (anyNA(data_long$Value)) {
    warning("The dataset contains missing values in 'Value' column.")
  }


  if (!all(is.numeric(data_long$Value))) {
    warning("Non-numeric data detected in 'Value'. Ensure the dataset is clean.")
  }


  p <- ggplot2::ggplot(data_long, ggplot2::aes(x = `Mean Daily Sunshine (hours)`, y = `Mean Temperature`, color = Metric, group = Metric)) +
    ggplot2::geom_line(size = 1.2) +
    ggplot2::geom_point(size = 3) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = "Dublin Airport Climate Animation",
      x = "Mean Daily Sunshine (hours)",
      y = "Mean Temperature (°C)",
      color = "Metrics"
    ) +
    ggplot2::scale_color_brewer(palette = "Set2") +
    ggplot2::theme(
      legend.position = "bottom",
      plot.title = ggplot2::element_text(hjust = 0.5)
    ) +
    gganimate::transition_states(Month, transition_length = 2, state_length = 1) +
    ggplot2::labs(title = "Month: {closest_state}")

  animation <- gganimate::animate(p, duration = 5, fps = 20, width = 500, height = 400, renderer = gganimate::gifski_renderer())


  message("Animation created successfully. Displaying...")

  print(animation)
  invisible(animation)
}
plot.summarise(dublin_airport)
