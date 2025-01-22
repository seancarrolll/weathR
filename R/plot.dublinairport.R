plot_summarise <- function(data) {
  required_cols <- c("Month", "Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall")
  if (!all(required_cols %in% colnames(data))) {
    stop("The dataset must include columns: 'Month', 'Mean Temperature', 'Mean Daily Sunshine (hours)', and 'Mean Rainfall'.")
  }

  data$Month <- base::factor(data$Month, levels = c("jan", "feb", "mar", "apr", "may", "jun",
                                                    "jul", "aug", "sep", "oct", "nov", "dec"))

  data_long <- tidyr::pivot_longer(
    data,
    cols = c("Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall"),
    names_to = "Metric",
    values_to = "Value"
  )

  data_long$Metric <- base::factor(data_long$Metric,
                                   levels = c("Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall"),
                                   labels = c("Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall")
  )

  data_long <- dplyr::group_by(data_long, Metric) |>
    dplyr::mutate(
      Value = dplyr::case_when(
        Metric == "Mean Rainfall" ~ Value / 10,
        TRUE ~ Value
      )
    )

  p <- ggplot2::ggplot(data_long, ggplot2::aes(x = Month, y = Value, color = Metric)) +
    ggplot2::geom_line(ggplot2::aes(group = Metric), size = 1.2) +
    ggplot2::geom_point(size = 3) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = "Dublin Airport Climate Trends",
      x = "Month",
      color = "Metric"
    ) +
    ggplot2::scale_color_brewer(palette = "Set2") +
    ggplot2::theme(
      legend.position = "bottom",
      plot.title = ggplot2::element_text(hjust = 0.5, size = 14),
      plot.subtitle = ggplot2::element_text(hjust = 0.5, size = 12),
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1)
    )

  p_animated <- p +
    gganimate::transition_reveal(as.numeric(Month)) +
    gganimate::ease_aes('linear')

  animation <- gganimate::animate(
    p_animated,
    duration = 10,
    fps = 30,
    width = 800,
    height = 600,
    renderer = gganimate::gifski_renderer(),
    nframes = 200
  )

  gganimate::anim_save("dublin_climate.gif", animation = animation)

  return(animation)
}

anim <- plot_summarise(dublin_airport)
print(anim)

