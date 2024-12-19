plot.summarise <- function(data, ...) {
  # Check if the input data has the required columns
  if (!is.data.frame(data) ||
      !all(c("Mean Temperature", "Mean Daily Sunshine (hours)", "Month") %in% colnames(data))) {
    stop("Input must be a data frame with columns: 'Mean Temperature', 'Mean Daily Sunshine (hours)', and 'Month'.")
  }

  # Convert the data to a long format for plotting
  data_long <- data |>
    tidyr::pivot_longer(
      cols = c("Mean Temperature", "Mean Daily Sunshine (hours)"),
      names_to = "Metric",
      values_to = "Value"
    )

  # Ensure the 'Month' column is treated correctly, avoiding duplicate factor levels
  data_long$Month <- factor(data$Month, levels = unique(data$Month))  # Explicitly reference 'Month' column

  # Generate the base plot
  p <- ggplot2::ggplot(data_long, ggplot2::aes(x = Month, y = Value, color = Metric, group = Metric)) +
    ggplot2::geom_line(size = 1.2) +
    ggplot2::geom_point(size = 3) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = "Dublin Airport Climate Animation",
      x = "Month",
      y = "Value",
      color = "Metrics"
    ) +
    ggplot2::scale_color_brewer(palette = "Set2") +
    ggplot2::theme(
      legend.position = "bottom",
      plot.title = ggplot2::element_text(hjust = 0.5)
    ) +
    gganimate::transition_states(Month, transition_length = 2, state_length = 1) +
    ggplot2::labs(title = "Month: {closest_state}")

  # Animate and display
  animation <- gganimate::animate(p, duration = 5, fps = 20, width = 500, height = 400, renderer = gganimate::gifski_renderer())
  print(animation)
  invisible(animation)
}

plot.summarise(dublin_airport)

