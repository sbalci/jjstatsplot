# Introduction to jjstatsplot

`jjstatsplot` provides easy wrappers around functions from the
[`ggstatsplot`](https://indrajeetpatil.github.io/ggstatsplot/) package.
These wrappers are primarily used by the *jamovi* interface but can also
be called directly from R. The package includes functions for creating
bar charts, box–violin plots, scatter plots, histograms, and more while
reporting relevant statistical tests automatically.

The main functions exported are:

- [`jjbarstats()`](https://www.serdarbalci.com/jjstatsplot/reference/jjbarstats.md)
  – bar charts for categorical variables
- [`jjbetweenstats()`](https://www.serdarbalci.com/jjstatsplot/reference/jjbetweenstats.md)
  – compare continuous variables between groups
- [`jjcorrmat()`](https://www.serdarbalci.com/jjstatsplot/reference/jjcorrmat.md)
  – correlation matrix visualisations
- [`jjdotplotstats()`](https://www.serdarbalci.com/jjstatsplot/reference/jjdotplotstats.md)
  – dot charts with summary statistics
- [`jjhistostats()`](https://www.serdarbalci.com/jjstatsplot/reference/jjhistostats.md)
  – histograms with statistical annotations
- [`jjpiestats()`](https://www.serdarbalci.com/jjstatsplot/reference/jjpiestats.md)
  – pie charts for categorical data
- [`jjscatterstats()`](https://www.serdarbalci.com/jjstatsplot/reference/jjscatterstats.md)
  – scatter plots with regression details
- [`jjwithinstats()`](https://www.serdarbalci.com/jjstatsplot/reference/jjwithinstats.md)
  – paired comparisons of repeated measures

All functions return a jamovi results object, but the primary component
of interest is usually the generated **ggplot2** object stored in the
`plot` element. In this vignette we give a quick overview of how to call
the wrappers from R.

We will use the built-in `mtcars` data set for the examples below.

``` r

library(jjstatsplot)
data(mtcars)
head(mtcars)
#>                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
#> Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

The following sections demonstrate some of the available plots.
