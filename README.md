
<!-- README.md is generated from README.Rmd. Please edit that file -->

# weathR R package

## Written by Roisin Murphy, Alanna Collier, Sean Carroll and Jack Castles.

<!-- badges: start -->
<!-- badges: end -->

## Description

The goal of weathR is to provide tools for loading, cleaning, analysing,
and visualising climate data taken from Dublin airport throughout
1981-2010. The package includes functions to preprocess climate data,
compute seasonal statistics (e.g., mean, median), and visualise trends
interactively.

## Installation

You can install the development version of weathR from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("seancarrolll/weathR")
```

## Example

This function loads the Dublin Airport dataset and ensures that it is
properly formatted and classified as a “dublinairport” object. It then
displays the first 6 rows:

``` r
library(weathR)
dublinairport <- load_dublinairport()
print(head(dublinairport))
#> # A tibble: 6 × 4
#>   Month `Mean Temperature` `Mean Daily Sunshine (hours)` `Mean Rainfall`
#>   <chr>              <dbl>                         <dbl>           <dbl>
#> 1 jan                  5.3                           1.9            62.6
#> 2 feb                  5.3                           2.7            48.8
#> 3 mar                  6.8                           3.5            52.7
#> 4 apr                  8.3                           5.3            54.1
#> 5 may                 10.9                           6.2            59.5
#> 6 jun                 13.6                           5.8            66.7
```

``` r
summarise.dublinairport(dublinairport)
#> $summary
#> # A tibble: 3 × 2
#>   Variable                    value
#>   <chr>                       <dbl>
#> 1 Mean Temperature             9.83
#> 2 Mean Daily Sunshine (hours)  3.96
#> 3 Mean Rainfall               63.2
```

Subsequently, an animated line plot visualising trends in temperature,
daily sunshine, and rainfall over the months can be created using the
following function:

``` r
 #anim <- plot_summarise(dublinairport)
 # print(anim)
```

A more through introduction can be found in the `weathR` vignette.
