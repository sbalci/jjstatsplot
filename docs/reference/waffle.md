# Waffle Charts

'Creates waffle charts to visualize distributions and proportions'

## Usage

``` r
waffle(
  data,
  counts,
  groups,
  facet,
  rows = 5,
  flip = FALSE,
  color_palette = "default",
  show_legend = TRUE,
  mytitle = "",
  legendtitle = ""
)
```

## Arguments

- data:

  The data as a data frame.

- counts:

  Optional numeric values to be represented in the waffle chart. If not
  provided, will use number of cases.

- groups:

  The grouping variable for the waffle squares

- facet:

  Optional variable to create faceted waffle charts

- rows:

  Number of rows in the waffle chart

- flip:

  Whether to flip the orientation of the waffle chart

- color_palette:

  Color scheme for the waffle squares

- show_legend:

  Whether to display the legend

- mytitle:

  Custom title for the plot

- legendtitle:

  Custom title for the legend

## Value

A results object containing:

|                |     |     |     |     |          |
|----------------|-----|-----|-----|-----|----------|
| `results$todo` |     |     |     |     | a html   |
| `results$plot` |     |     |     |     | an image |
