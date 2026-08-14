# jjridges: Ridgeline Plots

> **Rewritten for 1.0.52.** The previous version of this vignette
> documented the option names of `jjridgestats`, an earlier analysis
> that no longer exists (`dep`, `group`, `plotStyle`, `scaling`,
> `colorscheme`, `mytitle`). None of those arguments works with
> [`jjridges()`](https://www.serdarbalci.com/jjstatsplot/reference/jjridges.md),
> so every example on the page failed. The API below is taken from
> `jamovi/jjridges.a.yaml` in this release.

## What it does

[`jjridges()`](https://www.serdarbalci.com/jjstatsplot/reference/jjridges.md)
draws ridgeline plots — overlapping density curves, one per group — so
distributions can be compared by shape rather than by summary statistic
alone. It is well suited to biomarker values across disease stages, lab
results across time points, or any case where you want to see bimodality
and skew that a box plot would hide.

## The two required variables

The naming is the part people get wrong most often, because it is the
reverse of what a box plot uses:

- **`x_var`** — the **continuous** variable whose distribution is drawn.
- **`y_var`** — the **grouping** variable; one ridge per level.

``` r

jjridges(
  data  = mydata,
  x_var = "biomarker_expression",   # continuous - the distribution
  y_var = "disease_stage"           # groups     - one ridge each
)
```

## Choosing a plot type

`plot_type` accepts:

| Value                       | Draws                               |
|-----------------------------|-------------------------------------|
| `"ridgeline"`               | Basic ridgeline                     |
| `"density_ridges"`          | Density ridges (the usual choice)   |
| `"density_ridges_gradient"` | Density ridges with a fill gradient |

``` r

jjridges(
  data      = mydata,
  x_var     = "biomarker_expression",
  y_var     = "disease_stage",
  plot_type = "density_ridges_gradient",
  gradient_low  = "#2166AC",
  gradient_high = "#B2182B"
)
```

## Controlling the shape

`scale` sets ridge height (and therefore how much neighbouring ridges
overlap). Density estimation is governed by `bandwidth` with
`bandwidth_value` for a manual setting; `binwidth` applies when a
histogram-style ridge is drawn.

``` r

jjridges(
  data            = mydata,
  x_var           = "biomarker_expression",
  y_var           = "disease_stage",
  scale           = 1.2,
  bandwidth       = "custom",
  bandwidth_value = 0.5,
  alpha           = 0.7
)
```

A bandwidth chosen too small invents structure; too large flattens real
bimodality. If a second mode matters clinically, vary `bandwidth_value`
and check the feature survives.

## Adding summaries on top of the ridges

``` r

jjridges(
  data          = mydata,
  x_var         = "biomarker_expression",
  y_var         = "disease_stage",
  add_boxplot   = TRUE,
  add_points    = TRUE,
  point_alpha   = 0.3,
  add_quantiles = TRUE,
  quantiles     = "0.25, 0.5, 0.75",
  add_median    = TRUE
)
```

## Statistics

`show_stats = TRUE` adds a group-comparison test. Pick the test with
`test_type`, the multiplicity correction with `p_adjust_method`, and the
effect size with `effsize_type`.

``` r

jjridges(
  data            = mydata,
  x_var           = "biomarker_expression",
  y_var           = "disease_stage",
  show_stats      = TRUE,
  test_type       = "kruskal",
  p_adjust_method = "holm",
  effsize_type    = "eta"
)
```

A ridgeline plot compares *distributions*; a single omnibus p-value does
not describe which pair differs, so read it alongside the pairwise
output rather than as a conclusion on its own.

## Splitting and colouring

`fill_var` colours the ridges by a second variable, `facet_var` splits
into panels, and `reverse_order` flips the y ordering.

``` r

jjridges(
  data          = mydata,
  x_var         = "biomarker_expression",
  y_var         = "disease_stage",
  fill_var      = "treatment_arm",
  facet_var     = "hospital_site",
  color_palette = "clinical_colorblind",
  reverse_order = TRUE
)
```

`color_palette` includes `clinical_colorblind`, `viridis` and `plasma`;
prefer a colourblind-safe palette for anything destined for publication.

## Labels and output size

``` r

jjridges(
  data          = mydata,
  x_var         = "biomarker_expression",
  y_var         = "disease_stage",
  plot_title    = "Biomarker distribution by stage",
  plot_subtitle = "Higher stages show a longer right tail",
  x_label       = "Expression (AU)",
  y_label       = "Disease stage",
  add_sample_size = TRUE,
  width  = 800,
  height = 600
)
```

`add_sample_size` annotates each ridge with its n, which is worth
switching on whenever the groups are unbalanced — a wide, smooth-looking
ridge built from eight observations should not be read the same way as
one built from four hundred.

## Full option list

`data`, `x_var`, `y_var`, `fill_var`, `facet_var`, `plot_type`, `scale`,
`bandwidth`, `bandwidth_value`, `binwidth`, `add_boxplot`, `add_points`,
`point_alpha`, `add_quantiles`, `quantiles`, `add_mean`, `add_median`,
`show_stats`, `test_type`, `p_adjust_method`, `effsize_type`, `alpha`,
`color_palette`, `custom_colors`, `gradient_low`, `gradient_high`,
`fill_ridges`, `reverse_order`, `show_fill_legend`, `show_facet_legend`,
`theme_style`, `grid_lines`, `expand_panels`, `legend_position`,
`plot_title`, `plot_subtitle`, `plot_caption`, `x_label`, `y_label`,
`add_sample_size`, `add_density_values`, `custom_annotations`, `width`,
`height`, `dpi`, `clinicalPreset`, `showAboutPanel`, `showAssumptions`.
