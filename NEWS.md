# jjstatsplot 1.0.82.03 (development version)

A development build, not released on its own. This build makes resampled and Bayesian results reproducible and shows the seed behind them on the
plot. Hull Plot no longer depends on two optional libraries, and several option controls that never
switched on or off now work.

## Changed -- results that may differ from an earlier run

- **`jjbarstats`, `jjpiestats`: Bayesian results are now reproducible.** These two analyses had no
  random seed. A Bayesian contingency test, or the Bayes-factor caption of a frequentist test, could
  give slightly different numbers each time the same analysis ran. Both now use a fixed seed
  (default 20250101). An earlier run will not be matched exactly, but results no longer change
  between identical runs.

- **`hullplot`: concave hulls no longer depend on V8 and concaveman.** On most installations these
  libraries loaded and concave hulls were already drawn, so those plots do not change. Where they
  failed to load, the plot quietly fell back to convex hulls, said so only in an INFO notice and the
  caption, and ignored the Hull Concavity and Hull Boundary Expansion settings. Hulls are now
  computed by ggforce itself (version 0.5.0 or later), so that fallback is gone.

## Added -- a Random seed option, and the seed on the plot

- **New "Random seed" option** (default 20250101) in `jjbarstats`, `jjbetweenstats`, `jjhistostats`,
  `jjpiestats`, `jjridges`, `jjscatterstats` and `jjwithinstats`. `jjbetweenstats`, `jjhistostats`,
  `jjridges`, `jjscatterstats` and `jjwithinstats` already used this seed internally, so their
  default results are unchanged. Try a different seed to check that a borderline interval or Bayes
  factor does not depend on one particular resample.

- **The plot caption reads "Random seed: N" whenever the seed affected the numbers shown.** That
  covers robust and Bayesian tests, the nonparametric effect-size interval for three or more
  independent groups, and the Bayes-factor caption of a parametric test. When both appear, the seed
  line sits under the Bayes-factor caption. The same line now appears in `jjdotplotstats`,
  `statsplot2`, and in `jjcorrmat` with Bayesian correlations (on the plot and under the table). In
  `jjdotchart` it appears on every chart and under the summary table, because the error bars are
  always bootstrap intervals.

## Fixed -- option controls that did not respond

- **`jjarcdiagram`:** "Descending order" could not be ticked. It now works whenever a node order is
  chosen.
- **`jjsegmentedtotalbar`:** "Value labels" for the Flerlage chart could not be ticked, and the
  other Flerlage controls (label size, label colour, background transparency and colour) never
  greyed out. They are now active only for the Flerlage chart.
- **`jjridges`:** Bandwidth method, Custom bandwidth, Histogram bin width, Ridge transparency,
  Custom colors and the gradient colours were always active. Each is now active only when it
  applies (for example, bin width only for Histogram Ridges).
- **`jjhistostats`:** the Confidence level box broke every enable/disable rule and automatic
  adjustment that came after it in the panel. It is fixed, so Test direction, Trim proportion, the
  ggpubr sub-options and the bin-width and digits limits behave as intended. "Plot subtitle" is
  greyed out while Statistical results is on. Choosing a bin fill colour suggests a matching
  centrality-line colour again.
- **`jjsegmentedtotalbar`:** the detailed statistics table always lists its seven rows. If a run
  stops early, the old values are cleared rather than left from the previous run.

## Documentation and packaging

- **`hullplot`:** the Hull Boundary Expansion help now warns that values below about 0.01 can trim
  hulls. ggforce rounds hull corners with a fixed 2.5 mm radius, so points on the edge can fall
  outside the outline.
- The citation file now gives the licence as GPL-2.0-or-later. The module has a new icon, and V8
  and concaveman are no longer installed with it. Reference lists and the README were also updated.

# jjstatsplot 1.0.81 (2026-09-09)

This release follows a review of most analyses. Several fixes change numbers, labels or warnings you
may already be quoting, so read **Changed** before re-running a saved project. Some analyses also
have new defaults (theme, palette, aggregation), so saved charts may look different.

## Changed -- results that may differ in saved analyses

- **`jjridges`: parametric tests no longer switch quietly to Wilcoxon.** When a normality or
  variance check failed, a comparison was silently re-run as a Wilcoxon test. Welch's t is now
  always reported, and one notice lists the comparisons that failed a check. p-values and intervals
  change for those comparisons. Two groups that are each constant but differ now get a Wilcoxon
  result instead of an empty row.
- **`jjpiestats`: paired data with fewer than 25 discordant pairs now shows an exact p-value.**
  McNemar's chi-square is unreliable with few discordant pairs, so the subtitle now shows the exact
  binomial test on those pairs. Example: 206 pairs with 6 discordant gave p = 0.10 before and gives
  exact p = 0.22 now. A strong warning explains the switch.
- **`jjpiestats`: option changes now reach the charts.** An internal cache had kept the first run's
  decimal places and test type. The pie colours really use Dark2 now; before, the setting was
  ignored and charts fell back to the gdoc palette.
- **`jjbarstats`: paired requests no longer fall back silently.** A McNemar request on a table that
  is not 2x2, or with fewer than 10 pairs, used to run an unpaired chi-squared without saying so. It
  now stops with an error. Zero discordant pairs is also an error (report the agreement instead).
  Fewer than 25 discordant pairs gives a strong warning. The test is labelled as McNemar *without*
  continuity correction, which is why it does not match base R's default (0.26 vs 0.11 on the
  example data).
- **`jjbarstats`: Cramér's V cut-offs are scaled to the table size.** For a 3x3 table they are
  0.07, 0.21 and 0.35, so V = 0.19 now reads close to "medium", not "small". New default colour
  palette Dark2 (choose gdoc for the old look).
- **`jjsegmentedtotalbar`: the chi-square test no longer applies Yates' correction**, so p-values
  for 2x2 tables change. Empty rows and columns are dropped. Standardized residuals are now signed
  (they were shown as absolute values). With a facet variable the counts are pooled, and the note
  says so.
- **`statsplot2`: a robust or nonparametric choice now applies to the split-by panels.** They were
  silently parametric. Split violin panels use Holm adjustment instead of Bonferroni, like the
  unsplit figure. A categorical outcome with a continuous "group" now gets a between-group
  comparison, instead of a test of each category's mean against 0. Long-format repeated continuous
  data now need a Subject ID, so saved analyses without one stop with an error.
- **`jjwithinstats`: the publication (ggpubr) plot now shows the same paired test as the main
  plot.** It printed a between-subjects p-value that ignored the pairing: "Anova, p = 0.13" under a
  main panel reporting p = 1.6e-05. "Robust" also fell back to a paired t-test there (p = 0.35
  beside Yuen's p = 0.025).
- **`jjscatterstats`: the extra panels now run the test you chose.** "Robust" used to fall back to
  Spearman and "Bayesian" to Pearson (for example, robust rho 0.627 is now Winsorized r 0.589). A
  shape variable with more than 6 levels used to drop points silently (7 levels drew 103 of 120
  points). The shape mapping is now skipped with a warning. New analyses show the statistical
  results in the subtitle by default. Plots follow jamovi's theme instead of a fixed black-and-white
  one.
- **`raincloud`: the "Modified Z-Score" outlier method now uses the unscaled MAD, as the method
  requires.** The old formula scaled it twice, so a point was flagged only beyond about 7.7 raw MADs
  from the median. The cut-off is now about 5.2, so more outliers are flagged. Skewness and kurtosis
  now use the population SD (about 8% and 11% higher at n = 20), and a constant group shows an
  empty cell instead of 0 or 3.
- **`advancedraincloud`:** the Hedges' g interval is slightly narrower (its standard error now gets
  the same small-sample correction as g), and Glass's delta uses a delta-method standard error.
  Repeated subject IDs now block the independent-group tests and point you to `jjwithinstats`.
  Subjects with a zero baseline leave the responder denominator ("x / n evaluable").
- **`lollipop`: new analyses average repeated rows per group** (Data aggregation now defaults to
  Mean). A horizontal "Descending" sort puts the largest value at the top (it was upside down). The
  highest and lowest group are read from the plotted values, not always from group means. The
  "consider log transformation" advice now uses Tukey's far-out rule; before, it fired for any
  large, clean sample (n above about 130).
- **`jwaffle`: with a Counts variable, sample size and rare-category notices count cases, not
  rows.** A 1,000-patient study used to read "n=3". Ties for the largest category are named.
- **`jjarcdiagram`:** network density can no longer exceed 1. In distance mode, the node with the
  largest summed distance is called the most peripheral, not "the most highly connected hub".
- **`hullplot`:** the group-separation sentence now judges the closest pair of groups, measured on
  each axis's own scale. Before, it averaged all pairs, so two overlapping groups next to a distant
  third were called "well-separated".
- **`jjhistostats`:** the histogram follows jamovi's plot theme by default. Tick the new "Original
  ggstatsplot theme" for the old look. Infinite values are treated as missing.

## Added

- **`jjhistostats`:** "Test direction" (two-sided by default), "Trim proportion" for the robust
  test (default 0.2) and "Bayes prior scale" (default 0.707). The defaults match the values used
  before. New warnings: a parametric test on a variable that fails Shapiro-Wilk, and how many rows
  were dropped for missing values (for example "n = 83 of 120").
- **`jjdotplotstats`:** "Pairwise Comparisons" and "Multiple Comparison Adjustment" are now visible
  options. The defaults, significant pairs and Holm, are what was already drawn. New "Random seed"
  (default 42): the robust and nonparametric effect-size intervals used to change between runs. New
  "Assumptions and interpretation" panel.
- **`statsplot2`:** "Subject ID (Repeated Continuous Outcomes)", "Treat all numeric variables as
  continuous" and an opt-in "Result sentence". The explanation panel is now opt-in (it was always
  shown). The existing "Random seed" now also fixes robust and Bayesian statistics.
- **`jjcorrmat`:** Bayesian correlations show their interval under "Credible interval" columns. A
  "Bayesian seed" option is added, and its default matches the seed used before. A strong warning
  appears when no p-value adjustment is chosen (15 variables mean 105 tests).
- **`jjdotchart`:** a "Random seed" option, whose default matches the seed used before. Warnings
  for groups with fewer than 3 observations or sizes differing 10-fold, and a warning when the
  Wilcoxon p-value is a normal approximation (at 10 groups: 0.0528 reported, 0.0488 exact).
- **`linechart`:** the correlation table gains 95% confidence intervals and p-values. The ANOVA row
  shows its degrees of freedom. A constant-variance check is added to the assumptions.
- **`advancedraincloud`:** "Show Clinical Cutoff" and "Show Reference Range" checkboxes. A cutoff
  at zero can now be drawn.
- **`jjcorrmat`, `statsplot2`:** an "Original ggstatsplot theme" checkbox.

## Removed -- options that did nothing

- **`jjbarstats`:** the pairwise comparison options never ran a test, yet the text claimed "pairwise
  comparisons with holm correction". The per-bar p-values were never adjusted: Holm, none and
  Bonferroni all printed 0.03, 0.03 and 2.4e-04, where Holm should give 0.052, 0.052 and 7e-04. The
  text now says they are unadjusted. "Exclude missing" is also gone, because both settings already
  dropped incomplete rows. Test type is now Frequentist or Bayesian; the old Nonparametric and
  Robust choices ran the same chi-squared, so results do not change.
- **`jjdotchart`:** "Bayes factor interpretation" had an effect only under the parametric test, where
  it was greyed out, and there it replaced the caption naming the reference line. Saved analyses
  with it ticked now show that caption again. Choose Statistical Test = Bayesian for a Bayes factor.
- **`jjridges`:** "Plot DPI" had no effect. Set the resolution when saving the image.

## Fixed

- **`jjbarstats`, `jjridges`:** clinical presets now tick the checkboxes they change. Before, a
  preset could change the test behind your p-values while the controls stayed unticked.
- **`jjbarstats`, `jjarcdiagram`, `hullplot`:** plots and panels refresh when their inputs change.
  Before, the balloon plot or results from an earlier variable choice could stay on screen.
- **`jjridges`:** the summary and test tables no longer gain a full set of extra rows on every
  re-run. "Legend position: none" is respected.
- **`jjarcdiagram`:** a warning for disconnected networks, and for undirected data that contain
  both A->B and B->A rows.
- **`jjbetweenstats`:** "Bayes factor message" now works for a parametric two-group comparison,
  and says when no Bayes factor exists. Editing a cell in the spreadsheet now refreshes the
  results. New notes: the pairwise brackets always use Games-Howell, even with "Equal variances"
  ticked, and the nonparametric p-value is a normal approximation (0.0045 vs the exact 0.0040 at
  n = 25/40).
- **`jjdotplotstats`:** "Bayes factor caption" now draws for a parametric two-group comparison
  instead of nothing. Choosing no pairwise adjustment shows a warning (4 groups mean 6 comparisons,
  about a 26% chance of at least one false positive).
- **`jjwithinstats`:** "Explanations" is off by default. The explanation text names the test
  actually run, and a failed data preparation no longer reports "Ready for analysis".
- **`jjscatterstats`, `jjdotplotstats`:** plot titles show variable names instead of the literal
  text "{group}". The `jjscatterstats` ggpubr panels use the Title and axis labels you set.
- **`linechart`:** the "Clinical (Colorblind Safe)" palette was renamed "Clinical (tab10)",
  because it puts red next to green. Colorblind safe (Okabe-Ito) is the colour-blind safe choice.
- **`hullplot`:** the concavity range is now 1-20. It was 0-2, so hulls could not approach a convex
  outline, and values below 1 acted like 1.
  "Add confidence ellipses" is renamed "95% data ellipses", because they show spread, not
  uncertainty of the means. Errors and warnings appear above the plot.
- **`jjpiestats`, `jjbarstats`:** summaries and reports name the test actually shown (McNemar,
  Fisher or Pearson). `jjpiestats` no longer says that all assumptions "appear to be met"; it says
  no issue was detected by its limited checks.

## Documentation

- Help pages added for ten datasets that already shipped with the module, including the
  `histopathology` and `hullplot_*` sets. Many option labels were reworded to say what they do.
- R console only: the unused exports `bootstrapIDI`, `clinicopath_startup_message` and
  `raw_to_prob` were removed.

# jjstatsplot 1.0.6.03 (2026-08-22)

This release corrects interpretation text that misstated what a significance test and a normality
test can tell you, and stops third-party package notices appearing in the results pane.

## Fixed -- statements that were not true

- **`jjhistostats`: a non-significant normality test no longer establishes normality.** The
  interpretation panel read *"Normal distribution allows use of parametric statistics"* whenever the
  Shapiro-Wilk test failed to reject. Failing to reject is absence of evidence against normality,
  not evidence of it -- and at small n the test has little power to detect a departure. The panel now
  reports that no departure was detected, says parametric methods are reasonable on that basis, and
  states explicitly that this does not establish the distribution is normal, particularly at small n
  or when the test could not be run. The symmetry line carries the matching caveat that symmetry
  alone does not rule out bimodality or heavy tails.

- **`jjpiestats`: the description of what a significance test does is corrected.** The guidance
  stated that statistical tests determine whether observed differences are "likely due to chance",
  which inverts what the test computes.

- **`linechart`: statistical significance is no longer presented as clinical importance.** A clause
  asserting clinical relevance was appended whenever p < 0.05, and any R-squared at or above 0.5 was
  labelled "clinically meaningful". Both now describe the measured quantity and leave the judgement
  of importance, which depends on the outcome and not on the statistic, to the reader.

- **`jjbarstats`, `jjbetweenstats`, `jjcorrmat`, `jjsegmentedtotalbar`, `statsplot2`:**
  non-significant results are no longer reported as showing no difference or no association, and
  effect-size adjectives no longer carry an implied clinical verdict.

## Changed -- results no longer give clinical advice

- Text ruling on clinical relevance or recommending action has been replaced by description of what
  was computed. Guidance about running the analysis -- sample size, which test applies, assumption
  checks -- is unchanged and remains.

## Fixed -- output hygiene

- **R package chatter no longer appears in Analysis Notes.** jamovi surfaces `message()` and
  `warning()` conditions to the user, so notices from plotting and statistics packages leaked into
  results. Third-party calls are now wrapped so package chatter and deprecation notices are
  suppressed, while substantive warnings still reach you.

- **A malformed reference no longer prevents results from rendering.** A citation with an empty
  publication year caused a serialization failure that produced no output at all, with an error
  mentioning `serialize` rather than anything about the analysis. All references now carry a year.

# jjstatsplot 1.0.52 (2026-08-13)

A pre-release. The version carries a two-digit patch, so the release workflow publishes
it as a GitHub **pre-release** rather than a full release.

Most of this window was a per-analysis review pass, and several of the fixes change
numbers or labels you may already be quoting. Read **Breaking changes** and
**Corrected output** before upgrading a running project.

## Added

- **New analysis: Dot Chart (`jjdotchart`).** Collapses each group to a single summary
  point and tests those points against a reference value. The panel states plainly that
  *n is the number of groups, not the number of patients*, and the summary table reports
  the per-group n so the aggregation stays auditable. Options include `testvalue`,
  `typestatistics`, `grvar`, `centralityplotting`/`centralitytype` (a labelled centrality
  line, distinct from the reference line), `conflevel` and `showSummaryTable`.
- **Line Chart: `showRefline`.** The reference line has its own switch (see Breaking
  changes).
- **Automatic Plot Selection: `sampleThreshold` and `sampleSize`.** The subsampling
  threshold and retained row count were hard-coded at 10,000 and 5,000; both are now
  configurable, and asking to keep more rows than exist is clamped rather than erroring.
- **Segmented Total Bar Charts: `y_is_count`.** Required before a chi-square test will
  run (see Breaking changes), plus a `Rows Analysed` column alongside `Summed Value`.

## Breaking changes

- **Line Chart: `refline = 0` no longer draws a line by itself.** Zero used to mean "no
  reference line", which made the most common clinical reference impossible to draw -
  change-from-baseline, a difference and a log fold-change all sit at zero. Set
  `showRefline = TRUE` and put any value, including `0`, in `refline`. Scripts relying on
  a non-zero `refline` alone must add `showRefline = TRUE`.
- **Segmented Total Bar Charts: statistical tests require `y_is_count = TRUE`.** The
  chi-square is computed on the summed Value Variable, which is a contingency table only
  when that variable counts cases. Integrality cannot establish this - a whole-number
  measurement passes too, and the statistic then scales with the unit of measurement.
  Existing analyses with tests enabled will show an explanation instead of a test until
  the box is ticked.

## Corrected output

- **Bar Charts and Pie Charts no longer name a Fisher test that was never run.** On a
  sparse 2x2 both analyses used to advise switching `typestatistics` to `"nonparametric"`
  "to obtain Fisher's exact test". That switch produced the identical uncorrected Pearson
  chi-square - the plotting package offers no exact test - and in Pie Charts the
  copy-ready Methods sentence went as far as printing "using Fisher's exact test". The
  chart subtitle now reports **Fisher's exact test itself**, with the odds ratio and its
  interval, whenever the table is 2x2 with an expected count below 5; larger sparse tables
  keep the chi-square and the panel supplies the exact p-value to quote instead. **If you
  previously quoted a p-value from a sparse 2x2, re-check it** - the exact test can fall
  on the other side of 0.05.
- **Arc Diagram: weighted centrality used a non-standard transform.** Edge strengths were
  converted to distances by a linear reflection rather than the reciprocal, so betweenness
  and closeness could name a different node as the network hub. Now uses `1/w`, the
  published convention. Negative and zero weights previously aborted the analysis with a
  raw C-level igraph error and are now rejected with an explanation.
- **Numbers were printed at full precision throughout the module.**`@import jmvcore`
  places jmvcore's own `format()` - a string-template helper that ignores `digits`,
  `big.mark` and friends - ahead of `base::format()` for the whole package. Summary tables
  read "Y Mean 19.8349757678086" and trend text read "0.829075514952931 unit increase";
  thousands separators were dropped. Corrected at 97 call sites.
- **Line Chart and Automatic Plot Selection over-reported N.** Both counted rows rather
  than usable observations, so 180 rows with 155 usable outcomes was reported as "180 of
  180". Exclusions are now counted correctly and itemised.
- **Automatic Plot Selection: random subsampling is disclosed.** With `sampleLarge`
  enabled, every statistic is computed on a random subset; the panel previously showed
  only a reduced row count, which reads like missing-data exclusion, and the explanation
  went to the R console. Discarding rows costs power - measured over 300 replicates at
  d = 0.05 with n = 30,000, full-data power 99.7% against 45.3% on the 5,000-row draw.

## Fixed

- **Line Chart crashed on infinite values.**`complete.cases()` keeps `Inf`, which reached
  `var(y) == 0`, where `NaN == 0` is `NA` and `if (NA)` aborted the run with "missing value
  where TRUE/FALSE needed". Non-finite rows are now excluded and the exclusion disclosed.
- **Segmented Total Bar Charts crashed on any continuous Value Variable** - `sprintf("%d")`
  on a fractional total, outside every guard, at default settings.
- Degenerate inputs that used to run silently now explain themselves: a single distinct
  X value (Line Chart), an empty dataset (Line Chart), a variable crossed with itself
  (Pie Charts), a one-group comparison and a constant outcome (Automatic Plot Selection,
  where a constant numeric was silently re-read as categorical and changed the analysis
  type), and a counts variable summing to zero (Bar Charts).
- **Malformed "Expected proportions" were applied silently.** In Bar Charts and Pie Charts
  the validation ran during plot rendering, where jamovi discards notices, so a wrong
  length, a non-numeric entry or a set that did not sum to 1 fell back to equal proportions
  with nothing on screen.
- **Generated syntax was invalid for awkward column names.** Pie Charts emitted
  `dep = Tumor Grade ("high")` unquoted; variable names are now escaped.
- **Two shipped datasets could not be loaded by name.**`statsplot2_repeated.rda` held an
  object called `repeated_measures_data` and `statsplot2_clinical.rda` held
  `clinical_trial_data`, so `data(statsplot2_repeated)` succeeded and the object still did
  not exist. Fixed, along with 29 others across the umbrella package.

## Documentation

Vignettes are **pkgdown articles only** -- `vignettes/` is in `.Rbuildignore`, so they are
not built by `R CMD build`. The `%\Vignette*` directives and `vignette:` front-matter
blocks have been removed from 17 files accordingly; four of them declared a
`quarto::html` engine whose package was not even in `Suggests`.

- New article **"What's New in jjstatsplot 1.0.52"**, covering the new analysis, the
  breaking changes, and the analyses that do not yet have a walk-through of their own.
- **`jjridges` documentation rewritten from scratch.** It had been written against the
  option names of `jjridgestats` (`dep`, `group`, `plotStyle`, `scaling`, `colorscheme`,
  `mytitle`), none of which exist in `jjridges` -- every example on the page failed. The
  replacement documents the real API, including the `x_var` (continuous) / `y_var`
  (grouping) split that is the reverse of what a box plot uses.
- **Upstream ggstatsplot argument names removed from 14 articles.** Examples used
  `type`, `title`, `subtitle`, `xlab`, `ylab`, `pairwise.comparisons`, `conf.level`, `x`,
  `y`, `id` and `paired` -- the names of the *wrapped* functions, not of these wrappers --
  so copying them into R failed. They now use `typestatistics`, `mytitle`, `xtitle`,
  `ytitle`, `pairwisecomparisons`, `conflevel`, `dep`/`group` and `dep1`/`dep2`. The
  mapping was applied per function: `jjhistostats` and `jjcorrmat` genuinely have `title`,
  `subtitle` and `xlab`, and were left alone. Arguments with no equivalent at all
  (`jjbarstats` and `jjpiestats` have no title options) were removed rather than renamed.
- The Line Chart article uses `showRefline = TRUE` in every reference-line example.
- Articles for analyses still in development -- `bbcplots`, `advancedbarplot`,
  `economistplots`, `jsjplot`, `jjtreemap`, `basegraphics` -- each carry a notice saying so.

### Articles removed or relocated

| Article | Action |
|---|---|
| `jjridgestats` | **Removed** -- superseded by `jjridges()`. Not drop-in replacements. |
| `jjriverplot` | **Moved to ClinicoPathDescriptives**, where the analysis lives as `riverplot()` (13 of 14 documented arguments match). |
| `advancedtree` | **Moved to meddecide**, where the analysis lives as `treeadvanced()`. The article documents more options than are implemented; the notice lists which. |
| `jjsankeyfier`, `jjstreamgraph` | **Removed** -- no analysis of either name exists in any module. |

- `31-jjscatterstats-comprehensive.Rmd` was a single line of escaped text (literal `\n`
  and `\"` throughout) and could not render at all. Restored to 407 lines.

## Known issues

- ~~The "Plot with Aesthetics" panel in Scatter Plot is always shown.~~ **Fixed.** The
  `visible:` rule began with `!`, which fails jmvcore's expression routing: the expression
  was handed back as a raw (truthy) string, so an empty aesthetics plot sat under every
  analysis. Now `(colorvar || sizevar || shapevar || alphavar || labelvar)`. A sweep of all
  19 shipped analyses found one more instance -- `enable: (!resultssubtitle)` in
  `jjhistostats.u.yaml`, which left that box permanently enabled -- also fixed.
- Five analyses have no dedicated vignette yet: `hullplot`, `jjdotchart`,
  `jjsegmentedtotalbar`, `raincloud` and `statsplot2`. Their option lists are documented in
  the new What's New vignette.

# jjstatsplot 1.0.4 (2026-08-07)

## Note

- **No shipped analysis changed in this release.** Between 1.0.2 and 1.0.4 every file
  belonging to the eighteen analyses distributed here -- the ggstatsplot wrappers and the
  related plotting analyses (`advancedraincloud`, `hullplot`, `jjarcdiagram`, `jjbarstats`,
  `jjbetweenstats`, `jjcorrmat`, `jjdotplotstats`, `jjhistostats`, `jjpiestats`, `jjridges`,
  `jjscatterstats`, `jjsegmentedtotalbar`, `jjwithinstats`, `jwaffle`, `linechart`,
  `lollipop`, `raincloud`, `statsplot2`) -- was touched only by the version string. No backend
  (`.b.R`) file, no option (`.a.yaml`), results (`.r.yaml`) or interface (`.u.yaml`)
  definition was modified. Nothing a user can observe in the jamovi GUI or from the R
  wrappers differs from 1.0.2; no statistical method, default, plot or output was altered.
- The pre-release review pass carried out over this window covered the diagnostic-decision
  family (`meddecide`) and the oncology-pathology family (`OncoPath`) -- comparison of
  diagnostic tests, interrater agreement, swimmer plots, IHC heterogeneity and diagnostic
  meta-analysis. **None of those analyses is shipped by this module**, so none of the fixes
  or the accompanying breaking option changes reaches users of `jjstatsplot`. They are
  described in the NEWS files of the modules that own them.

## Known issues

- **The "Plot with Aesthetics" panel in Scatter Plot (`jjscatterstats`) is always shown.**
  Its visibility rule in `jamovi/jjscatterstats.r.yaml` begins with `!`
  (`(!is.null(colorvar) || ...)`), and a leading `!` fails jmvcore's expression-routing
  pattern: instead of being evaluated, the expression is handed back as a raw string, which
  is truthy, so the item is permanently visible. An empty aesthetics plot therefore sits
  under the analysis even when no colour, size, shape, alpha or label variable has been
  chosen. This is one instance of a defect confirmed across the umbrella package
  (26 `visible:`/`enable:` expressions in 17 `.r.yaml` files); it is tracked and not yet
  fixed here. Interface (`.u.yaml`) conditions are unaffected -- those are evaluated by the
  jamovi frontend, which handles `!` correctly.
- **`jamovi/0000.yaml` advertises five analyses this module does not contain.**
  `basegraphics`, `jjcoefstats`, `jjpubr`, `jjsyndromicplot` and `pcaloadingheatmap` were
  added to the module manifest, but none of their backend, header or definition files is
  distributed here, and all five still carry the `JJStatsPlotT` development menu group used
  to route a function away from the production menu while it is under modification. They
  cannot be instantiated and should be treated as absent.
- `janitor` and `labelled` were added to DESCRIPTION `Imports`. Neither is called by any
  file shipped in this module; they are collateral from the umbrella-wide dependency sync
  and are candidates for removal rather than a new capability.

# jjstatsplot 1.0.3 (2026-08-04)

## Note

- Version and release-date bump only, published without its own entry at the time. No file
  of any shipped analysis changed. It is described together with 1.0.4 above.

# jjstatsplot 1.0.2 (2026-08-03)

## Fixed

- **Optional variables were required arguments of the R function.** Ten analyses declared
  variables with no default in their jamovi option definition, which compiles to a bare
  parameter in the generated wrapper. Calling the analysis from R without one failed with
  `argument "X" is missing, with no default` before the analysis could report its own message --
  including for plainly optional inputs such as `jjhistostats(grvar =)`, the "Split By" grouping
  variable. These now default to `NULL`: `advancedraincloud` (`x_var`, `y_var`), `jjarcdiagram`
  (`source`, `target`), `jjbarstats` (`dep`, `group`), `jjcorrmat` (`grvar`), `jjdotplotstats`
  (`grvar`), `jjhistostats` (`grvar`), `jjpiestats` (`dep`), `jjsegmentedtotalbar` (`fill_var`,
  `x_var`, `y_var`), `jwaffle` (`groups`) and `statsplot2` (`dep`, `group`). Behaviour in the
  jamovi GUI is unchanged; no statistical method was altered.


## Note

- The pre-release review pass carried out this release covered the survival-family and
  diagnostic-decision analyses (`jsurvival`, `meddecide`) and a package-wide `format()` namespace
  fix in the umbrella package. **No analysis shipped here was changed** -- none of the affected
  files is distributed to this module.

## Added

- **Automated GitHub release (`.github/workflows/release.yaml`).** A push to the default branch
  touching `DESCRIPTION` or `jamovi/0000.yaml` cross-checks the two version strings, refuses to
  proceed if they disagree, and -- if the tag does not already exist -- tags `v<version>` and
  publishes a release whose notes are the matching section of this file.

# jjstatsplot 0.0.47 (2026-07-05)

## Bug Fixes

* **Fixed a crash on labelled (SPSS/Stata) data.**`haven::as_factor()` is used by `jjwithinstats` and `jwaffle`, but `haven` was missing from the package `Imports`. Because jamovi installs only a package's `Imports`, those analyses crashed on labelled data on a clean install. `haven` is now declared.
* Declared additional plotting dependencies used via `::` but previously undeclared: `car`, `cowplot`, `e1071`, `ggExtra`, `ggprism`, `ggrepel`, `patchwork`, `viridisLite`.

# jjstatsplot 0.0.46 (2026-07-04)

This release consolidates all work from 0.0.32.66 through 0.0.46 into a single entry. The main themes are: a new **"Important Information" notices system** surfacing typed diagnostic messages across analyses; extensive **input-validation and HTML-escaping hardening** of the backends; **multiple-endpoint-correction guidance** for group comparisons; and **dependency/infrastructure cleanup** that raises the minimum jamovi version to 2.7.27.

## New Features

### "Important Information" Notices
- **NEW**: Added an "Important Information" `Preformatted` output (`notices`) that surfaces prioritized, typed messages (ERROR / STRONG_WARNING / WARNING / INFO) generated during the analysis to seven modules:
  - **Arc Diagram** (`jjarcdiagram`)
  - **Bar Charts** (`jjbarstats`)
  - **Pie Charts** (`jjpiestats`)
  - **Advanced Ridge Plot** (`jjridges`) -- replaces the previous free-form `Notices` (`Html`, always-visible) output
  - **Waffle Charts** (`jwaffle`)
  - **Lollipop Chart** (`lollipop`)
  - **statsplot2** (`statsplot2`)
- Backends for `jjarcdiagram`, `jjbarstats`, `jjpiestats`, `jwaffle`, `lollipop`, and `statsplot2` gained a shared `.addNotice()` / `.renderNotices()` helper pair that accumulates notices and renders them safely, avoiding the `jmvcore::Notice` serialization failure.

### Multiple-Endpoint Correction Guidance (`jjbetweenstats`)
- **NEW** results panels `mecGuidance`, `diagnostics`, and `clinicalSummary` (all `Html`):
  - `mecGuidance` renders step-by-step guidance for the `multiEndpointCorrection` option (`none` / `bonferroni` / `holm` / `fdr`), including the adjusted significance threshold and a family-wise error-rate inflation warning when multiple dependent variables are tested.
  - `diagnostics` renders data-quality and assumption diagnostics.
  - `clinicalSummary` renders a natural-language clinical interpretation.
  - Guidance and diagnostics are now rendered from `.run()` into always-visible elements (via `setContent()`), so they reliably appear and update when options change -- fixing content that previously vanished on option-only changes because it was emitted only from the memoized `.prepareData()` path.

### Natural-Language Summary (`linechart`)
- **NEW** `naturalSummary` (`Html`) output providing a plain-language summary of the line chart.

## Enhanced Existing Modules

- **Bar Charts** (`jjbarstats`): input validation now rejects continuous variables used as categories, non-numeric or negative `counts` values, and grouping variables with fewer than 2 categories; auto-selects Fisher's exact test when appropriate; validates paired-data structure; validates and normalizes expected-proportion `ratio` values (with warnings on parse errors); UI reorganized into `CollapseBox` / `Label` groups.
- **Between-Group Comparisons** (`jjbetweenstats`): UI reorganized into `CollapseBox` / `Label` groups.
- **Arc Diagram** (`jjarcdiagram`): added network-size notices (trivial / very-small / small / large network), density notices (high / sparse), self-loop detection and removal, and edge-aggregation reporting.
- **Housekeeping across modules**: descriptive text and option titles were rewritten to avoid the literal `%` character (e.g. "100%" -> "100 percent", "Winsorize (5/95%)" -> "Winsorize (5/95 percent)", "Show CV% Bands" -> "Show CV percent Bands") for compatibility with the notices/preformatted output.

## Security & Robustness

- **HTML escaping**: `htmltools::htmlEscape()` is now applied to all user-supplied values interpolated into HTML output -- variable names, group and factor labels, baseline-group names, and network node names -- across `hullplot`, `jjarcdiagram`, `jjbarstats`, `jjbetweenstats`, `jjpiestats`, and others, preventing HTML/script injection via malicious column names or factor levels.
- **Safe formula construction**: `jjbarstats` builds its counts formula (`counts ~ var1 + var2`) with `jmvcore::composeTerm()` instead of raw string pasting.
- **Input validation**: `jmvcore::reject()` guards for empty datasets, missing/not-found variables, and no-complete-cases conditions across `hullplot`, `jjarcdiagram`, `jjbarstats`, and others.
- **Shared helpers** added to `R/utils.R`: `.escapeVariableNames()`, `.asSurvivalFormula()` (extends the jmvcore 2.7.27 `asFormula` allow-list), `.buildSurvivalFormula()`, and the `%notin%` / `%!in%` operators.

## Bug Fixes

- **Line Chart** (`linechart`): added the missing `naturalSummary` results element that the backend calls via `setContent()`, which previously caused an error (community contribution -- PR #12 by G Chia).
- **Between-Group Comparisons** (`jjbetweenstats`): fixed multi-dependent-variable plotting by passing the aesthetic symbol directly (`y = y`) instead of `y = !!y` inside a plain `list()`, which errored with "invalid argument type".
- **Histogram** (`jjhistostats`): fixed the conditional visibility of the grouped ggpubr plot (`ggpubrPlot2`) to use `!is.null(grvar)`; renamed the ggpubr output titles to remove parentheses (e.g. "Density Plot (ggpubr)" -> "Density Plot ggpubr").
- **Scatter Plot** (`jjscatterstats`): adjusted the grouped-plot (`plot2`) visibility condition.

## Package Infrastructure

- Version bumped to **0.0.46** (Date 2026-07-04); minimum jamovi (`minApp`) raised from **1.2.19** to **2.7.27**.
- DESCRIPTION `Imports` reorganized one-per-line; **added** `DT` and `extrafont`; **moved** `ggcorrplot`, `ggside`, `performance`, and `PMCMRplus` from `Imports` to `Suggests`.
- **Added** `ClinicoPath/waffle` to `Remotes` (alongside `gastonstat/arcdiagram`).
- Switched to `Config/roxygen2/version: 8.0.0` (from `RoxygenNote: 7.3.3`).

---

# jjstatsplot 0.0.32.66 (2026-01-01)

## New Features

### ggpubr Integration
- **NEW**: Added publication-ready plot variants using `ggpubr` package across multiple analyses
  - **jjwithinstats**: Added ggpubr plot option for within-subjects/paired data
    - Multiple plot types: boxplot, violin, paired (with connecting lines), line (mean trajectory)
    - Journal-specific color palettes: JCO, NPG, AAAS, Lancet, JAMA, NEJM
    - Options for statistical comparisons, individual trajectories, and overlay points
  - **jjpiestats**: Added modern donut chart variant
    - Publication-ready donut charts with journal color palettes
    - Clean, professional aesthetic for reports and publications

### Enhanced Clinical Workflow Features

#### Ridge Plots (jjridges)
- **NEW**: Clinical analysis presets with automatic configuration
  - Biomarker Distribution (nonparametric + Cliff's delta)
  - Treatment Response (violin plots + Bonferroni correction)
  - Age by Disease Stage (parametric + Cohen's d)
  - Tumor Size Comparison (Hodges-Lehmann shift)
  - Lab Values by Group (robust tests + Hedges' g)
  - Survival Time Distribution (median + quartiles)
- Added comprehensive help panels:
  - `showAboutPanel`: Interpretation guidance and clinical examples
  - `showAssumptions`: Statistical assumptions and methodological notes
- Enhanced statistical warnings for repeated measures/longitudinal data

#### Pie Charts (jjpiestats)
- **NEW**: Interactive guidance panels
  - `showSummary`: Natural-language summary suitable for copy-paste into reports
  - `showAssumptions`: Detected violations and Fisher exact test recommendations
  - `showInterpretation`: Effect size interpretation and clinical context

#### Segmented Total Bar Charts (jjsegmentedtotalbar)
- **NEW**: Dual plot type support
  - Traditional 100% stacked bars
  - **Flerlage-style segmented total bars** (Kevin Flerlage design)
    - Emphasizes both totals and composition
    - Customizable labels, colors, transparency
    - Background box styling options
- Reorganized options for clearer workflow

#### Lollipop Charts
- **NEW**: Data aggregation options for repeated measures
  - No aggregation (plot all points)
  - Mean, Median, Sum aggregation
  - Guidance for clinical measurements vs. counts
- Default empty strings for labels/titles for cleaner initial plots

### User Experience Improvements
- Multiple analyses updated with improved default settings for cleaner initial plots
  - jjwithinstats: Violin and boxplot defaults changed to `false` for simpler initial view
  - jjpiestats: Proportion test and BF message defaults to `false` to reduce clutter
  - jjsegmentedtotalbar: Percentages, outlines, export_ready defaults to `false`
  - jwaffle: Legend default to `false`
- Enhanced explanatory text across multiple analyses
- Improved statistical assumption warnings (especially for repeated measures data)

## Package Dependencies
- **Added** `ggpubr` to Imports for publication-ready plot variants
- **Added** `rstatix` to Imports for enhanced statistical testing support

## Documentation
- Updated R documentation for all modified analyses
- Enhanced roxygen2 documentation with version 7.3.3
- Improved parameter descriptions and usage examples

## Bug Fixes
- Fixed documentation formatting issues in several .Rd files

---

# jjstatsplot 0.0.31.84 (2025-10-03)

## New Features

### Hull Plot Analysis
- **NEW**: Added `hullplot` module for cluster and group visualization
  - Creates polygonal boundaries around data points grouped by categorical variables
  - Based on `ggforce::geom_mark_hull()` function
  - Perfect for visualizing customer segments, patient subgroups, and data clusters
  - Features include:
    - Customizable hull concavity (0-2 range)
    - Optional confidence ellipses
    - Outlier detection
    - Group statistics summary
    - Natural language interpretation
    - Multiple color palettes (default, viridis, Set1, Set2, Dark2, clinical)
    - Multiple plot themes (minimal, classic, light, dark, clinical)
    - Support for color and size variables
    - Automatic fallback to convex hulls when V8/concaveman packages unavailable

## Improvements

### Package Dependencies
- Added `ggforce` to Imports for hull plot functionality
- Added `grid` to Imports for unit handling in hull plots

### Documentation
- Updated DESCRIPTION with new analysis count (18 analyses)
- Updated README to include hull plot in analysis types table
- Enhanced package description to reflect expanded capabilities

## Bug Fixes
- None in this release

---

# jjstatsplot 0.0.31.57 (2025-09-03)

## Release Highlights
- Early release for September 2025
- Comprehensive statistical visualization suite with 17+ analysis types
- Publication-ready plots with statistical annotations

## Core Features

### Distribution Analysis
- `jjhistostats` - Histograms with Shapiro-Wilk test and robust measures
- `jjridges` - Ridge plots for multiple distribution overlay
- `jwaffle` - Waffle charts for part-to-whole visualization

### Continuous vs Continuous
- `jjscatterstats` - Scatter plots with correlation analysis
- `jjcorrmat` - Correlation matrices with significance testing

### Categorical vs Continuous
- `jjbetweenstats` - Between-groups comparisons (ANOVA, Kruskal-Wallis)
- `jjwithinstats` - Within-subjects comparisons (repeated measures)
- `jjdotplotstats` - Dot charts with confidence intervals
- `raincloud` - Basic raincloud plots (distribution + individual points)
- `advancedraincloud` - Enhanced raincloud plots with longitudinal support
- `lollipop` - Lollipop charts for ranked data

### Categorical vs Categorical
- `jjbarstats` - Bar charts with chi-square and Fisher's exact test
- `jjpiestats` - Pie charts with goodness of fit tests
- `jjsegmentedtotalbar` - Segmented bar charts with totals

### Network and Time Series
- `jjarcdiagram` - Arc diagrams for network visualization
- `linechart` - Line charts for trends over time

### Advanced Features
- `statsplot2` - Automatic plot selection based on variable types
- Dual-mode operation (single/grouped variables)
- Statistical flexibility (parametric, non-parametric, robust, Bayesian)
- Theme support (jamovi-style and ggstatsplot themes)
- Dynamic plot sizing based on data dimensions

## Dependencies
- R (>= 4.0.0)
- Core: jmvcore, R6, ggstatsplot
- Plotting: ggplot2, ggalluvial, ggside, ggcorrplot, ggdist, ggridges, ggrain
- Statistical: PMCMRplus, WRS2, BayesFactor, effectsize, performance, moments

---

## Earlier Versions

## jjstatsplot 0.0.3.91
- Enhanced vignettes and reference documentation
- Improved package metadata

## jjstatsplot 0.0.3.90
- Added comprehensive vignette collection (40+ files)
- Improved documentation structure

## jjstatsplot 0.0.3.89
- Release candidate for jamovi 2.7.2
- Removed embedded images from vignettes
- Performance improvements

## jjstatsplot 0.0.3.70
- Initial public release
- Core ggstatsplot wrapper functionality
- Basic jamovi module integration
