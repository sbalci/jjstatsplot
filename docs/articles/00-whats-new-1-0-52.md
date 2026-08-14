# What's New in jjstatsplot 1.0.52

This release adds one analysis, changes the behaviour of several
options, and tightens what the module tells you about your own data. The
behaviour changes matter more than the new features: a few of them alter
numbers or labels you may already be quoting, so read the “Changed
behaviour” section before upgrading a running project.

## New analysis: Dot Chart

[`jjdotchart()`](https://www.serdarbalci.com/jjstatsplot/reference/jjdotchart.md)
— **Dot Chart (Summary vs Reference Value)** — collapses each group to a
single summary point and tests those points against a reference value.

``` r

jjdotchart(
  data           = mydata,
  dep            = "biomarker_level",   # continuous outcome
  group          = "hospital_site",     # one point per level
  testvalue      = 12,                  # the reference to test against
  typestatistics = "parametric"
)
```

The thing to understand before using it: **n is the number of groups,
not the number of patients.** Ten sites with 500 patients each is n = 10
for this test, with 9 degrees of freedom. The analysis states this in
its own panel, and the summary table reports the per-group n so the
aggregation stays auditable.

Useful options: `grvar` (split into panels), `centralityplotting` /
`centralitytype` (add a labelled centrality line, which is *not* the
reference line), `conflevel`, `k` (decimal places), `showSummaryTable`.

## Changed behaviour

### Line Chart — reference lines have their own switch

`refline = 0` previously meant “no line”, which made the most common
clinical reference impossible to draw: zero is where
change-from-baseline, a difference and a log fold-change all sit. There
is now a `showRefline` switch.

``` r

linechart(
  data        = mydata,
  xvar        = "visit_week",
  yvar        = "change_from_baseline",
  showRefline = TRUE,     # <- now required
  refline     = 0,        # <- and zero finally works
  reflineLabel = "No change"
)
```

Scripts that relied on a non-zero `refline` alone need
`showRefline = TRUE` adding. Nothing else about the line changed.

### Line Chart — the confidence band is a model fit

With `confidence = TRUE` the shaded band is the 95% interval of a
**fitted model**, not the uncertainty of the plotted points: a
straight-line fit by default, or a LOESS fit when `smooth = TRUE`. The
drawn line connects the observed values, so band and line describe
different things unless you enable `smooth`. The analysis now says so in
its panel.

### Bar Charts and Pie Charts — no more phantom Fisher test

On a 2×2 table with low expected counts, these analyses used to suggest
switching `typestatistics` to `"nonparametric"` “to obtain Fisher’s
exact test”. That switch never produced a Fisher test — the plotting
package computes the same uncorrected Pearson chi-square for every
frequentist option — and the copy-ready Methods sentence went as far as
naming a test that had not been run.

Now:

- the chart subtitle **shows Fisher’s exact test itself** (with the odds
  ratio and its confidence interval) whenever the table is 2×2 and an
  expected count falls below 5;
- larger sparse tables keep the chi-square subtitle and the panel hands
  you the exact p-value to quote instead;
- the Methods sentence names the test that actually ran.

If you previously quoted a p-value from a sparse 2×2, re-check it — the
exact test can fall on the other side of 0.05 from the chi-square it
replaced.

### Segmented Total Bar Charts — chi-square is now opt-in

The chi-square here is computed on the **summed Value Variable**, which
is a contingency table only when that variable counts cases. Integrality
cannot establish that: a whole-number measurement passes too, and the
statistic then scales with the unit you measured in. Statistical tests
therefore now require `y_is_count = TRUE`, an explicit statement that
the variable counts cases.

``` r

jjsegmentedtotalbar(
  data                   = mydata,
  x_var                  = "treatment_arm",
  fill_var               = "response_category",
  y_var                  = "n_patients",
  y_is_count             = TRUE,        # <- required for the test
  show_statistical_tests = TRUE
)
```

The summary table also separates **Rows Analysed** from **Summed
Value**; the single “Total Observations” column used to report the sum,
which read as a patient count.

### Automatic Plot Selection — sampling is disclosed and configurable

`sampleLarge` draws a random subset of large datasets for plotting
speed, and **every statistic is then computed on that subset**. The
panel now says so explicitly rather than only reporting a smaller row
count, which read like missing-data exclusion.

The threshold and the retained size are no longer hard-coded:

``` r

statsplot2(
  data            = mydata,
  dep             = "tumor_response",
  group           = "treatment",
  sampleLarge     = TRUE,
  sampleThreshold = 50000,   # only sample above this many rows
  sampleSize      = 20000,   # keep this many
  seed            = 42       # reproducible draw
)
```

Discarding rows costs power, so prefer turning sampling off before
reporting a result. The reported observation count now also counts
usable observations rather than rows, so it no longer over-states N when
values are missing.

## Analyses without a dedicated vignette yet

These ship in this release but do not yet have a walk-through of their
own. The option lists below are complete and current; fuller vignettes
are planned.

- **[`hullplot()`](https://www.serdarbalci.com/jjstatsplot/reference/hullplot.md)**
  — Hull Plot. Draws concave hulls around clusters. Key options:
  `x_var`, `y_var`, `group_var`, `color_var`, `size_var`,
  `hull_concavity`, `hull_alpha`, `hull_expand`, `confidence_ellipses`,
  `outlier_detection`, `show_statistics`.
- **[`jjsegmentedtotalbar()`](https://www.serdarbalci.com/jjstatsplot/reference/jjsegmentedtotalbar.md)**
  — Segmented Total Bar Charts (100% stacked). See the section above for
  the options that changed.
- **[`statsplot2()`](https://www.serdarbalci.com/jjstatsplot/reference/statsplot2.md)**
  — Automatic Plot Selection. Chooses the plot and test from the
  variable types; see the sampling section above.
- **[`raincloud()`](https://www.serdarbalci.com/jjstatsplot/reference/raincloud.md)**
  — covered in
  [08-advancedraincloud](https://www.serdarbalci.com/jjstatsplot/articles/08-advancedraincloud.md)
  alongside
  [`advancedraincloud()`](https://www.serdarbalci.com/jjstatsplot/reference/advancedraincloud.md).

## Not in this release

Some vignettes here describe analyses that are still **in development**
and are not part of jjstatsplot 1.0.52 — `bbcplots`, `advancedbarplot`,
`economistplots`, `jsjplot`, `jjtreemap` and `basegraphics`. Each
carries a notice at the top. Only analyses that are in the shipped
module are documented as available.

Several vignettes were removed or relocated in this release:

| Was | Now |
|----|----|
| `jjridgestats` | Removed — superseded by **[`jjridges()`](https://www.serdarbalci.com/jjstatsplot/reference/jjridges.md)**, which ships. The two are not drop-in replacements (different option names entirely). |
| `jjriverplot` | Moved to **ClinicoPathDescriptives**, where the analysis lives as `riverplot()`. |
| `advancedtree` | Moved to **meddecide**, where the analysis lives as `treeadvanced()`. |
| `jjsankeyfier`, `jjstreamgraph` | Removed — no analysis of either name exists in any module. |
