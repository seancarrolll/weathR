  #' Plot Climate Data for Dublin Airport
  #'
  #' Creates an animated line plot visualising climate trends including temperature,
  #' daily sunshine, and rainfall for Dublin Airport across months of the year.
  #'
  #' @param data A data frame containing climate data with specific column requirements.
  #'
  #' @details
  #' The function requires the following columns:
  #' - 'Month'
  #' - 'Mean Temperature'
  #' - 'Mean Daily Sunshine (hours)'
  #' - 'Mean Rainfall'
  #'
  #' The function performs the following transformations:
  #' - Converts month to a factor with a specific order
  #' - Pivots data to long format for plotting
  #' - Scales rainfall data by dividing by 10
  #' - Creates an animated line plot with revealing transition
  #'
  #' @return A gganimate animation object visualising climate trends
  #'
  #' @importFrom tidyr pivot_longer
  #' @importFrom dplyr group_by mutate case_when
  #' @importFrom ggplot2 ggplot aes geom_point theme_bw xlab ylab ggtitle geom_line theme element_text element_text scale_color_brewer
  #' @importFrom gganimate transition_reveal animate ease_aes gifski_renderer anim_save
  #'
  #' @author Sean Carroll - <\email{sean.carroll.2021@mu.ie.ie}>
  #'
  #' @examples
  #' \dontrun{
  #' anim <- plot_summarise(dublin_airport)
  #' print(anim)
  #' }
  #'
  #' @export
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
      names_to = "Variables",
      values_to = "Value"
    )

    data_long$Variables <- base::factor(data_long$Variables,
                                     levels = c("Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall"),
                                     labels = c("Mean Temperature", "Mean Daily Sunshine (hours)", "Mean Rainfall")
    )

    data_long <- dplyr::group_by(data_long, Variables) |>
      dplyr::mutate(
        Value = dplyr::case_when(
          Variables == "Mean Rainfall" ~ Value / 10,
          TRUE ~ Value
        )
      )

    p <- ggplot2::ggplot(data_long, ggplot2::aes(x = Month, y = Value, color = Variables, group = Variables)) +
      ggplot2::geom_line(size = 1.2) +
      ggplot2::geom_point(size = 3) +
      ggplot2::theme_minimal() +
      ggplot2::scale_color_brewer(palette = "Set2") +
      ggplot2::labs(
        title = "Dublin Airport Climate Trends",
        x = "Month",
        color = "Variables"
      ) +
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
      fps = 20,
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

