#' Plot and Animate Dublin Airport Climate Trends
#'
#' Creates an animated plot visualising climate data from Dublin Airport, including trends in mean temperature,
#' mean daily sunshine, and mean rainfall over the months of the year.

plot_summarise <- function(data) {
  required_cols <- c("Month", "Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall")
  if (!all(required_cols %in% colnames(data))) {
    stop("The dataset must include columns: 'Month', 'Mean Temperature', 'Mean Daily Sunshine (hours)', and 'Mean Rainfall'.")
  }

  data$Month <- factor(data$Month, levels = c("jan", "feb", "mar", "apr", "may", "jun",
                                              "jul", "aug", "sep", "oct", "nov", "dec"))

  data_long <- tidyr::pivot_longer(
    data,
    cols = c("Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall"),
    names_to = "Metric",
    values_to = "Value"
  )

  data_long$Metric <- factor(data_long$Metric,
                             levels = c("Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall"),
                             labels = c("Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall")
  )

  data_long <- data_long %>%
    group_by(Metric) %>%
    mutate(
      Value = case_when(
        Metric == "Mean Rainfall" ~ Value / 10,
        TRUE ~ Value
      )
    )

  p <- ggplot(data_long, aes(x = Month, y = Value, color = Metric)) +
    geom_line(aes(group = Metric), size = 1.2) +
    geom_point(size = 3) +
    theme_minimal() +
    labs(
      title = "Dublin Airport Climate Trends",
      x = "Month",
      color = "Metric"
    ) +
    scale_color_brewer(palette = "Set2") +
    theme(
      legend.position = "bottom",
      plot.title = element_text(hjust = 0.5, size = 14),
      plot.subtitle = element_text(hjust = 0.5, size = 12),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )

  p_animated <- p +
    transition_reveal(as.numeric(Month)) +
    ease_aes('linear')

  animation <- animate(
    p_animated,
    duration = 10,
    fps = 30,
    width = 800,
    height = 600,
    renderer = gifski_renderer(),
    nframes = 200
  )

  anim_save("dublin_climate.gif", animation = animation)

  return(animation)
}

anim <- plot_summarise(dublin_airport)
print(anim)
