# Changelog

## jjstatsplot 1.0.52 (2026-08-13)

A pre-release. The version carries a two-digit patch, so the release
workflow publishes it as a GitHub **pre-release** rather than a full
release.

Most of this window was a per-analysis review pass, and several of the
fixes change numbers or labels you may already be quoting. Read
**Breaking changes** and **Corrected output** before upgrading a running
project.

### Added

- **New analysis: Dot Chart (`jjdotchart`).** Collapses each group to a
  single summary point and tests those points against a reference value.
  The panel states plainly that *n is the number of groups, not the
  number of patients*, and the summary table reports the per-group n so
  the aggregation stays auditable. Options include `testvalue`,
  `typestatistics`, `grvar`, `centralityplotting`/`centralitytype` (a
  labelled centrality line, distinct from the reference line),
  `conflevel` and `showSummaryTable`.
- **Line Chart: `showRefline`.** The reference line has its own switch
  (see Breaking changes).
- **Automatic Plot Selection: `sampleThreshold` and `sampleSize`.** The
  subsampling threshold and retained row count were hard-coded at 10,000
  and 5,000; both are now configurable, and asking to keep more rows
  than exist is clamped rather than erroring.
- **Segmented Total Bar Charts: `y_is_count`.** Required before a
  chi-square test will run (see Breaking changes), plus a
  `Rows Analysed` column alongside `Summed Value`.

### Breaking changes

- **Line Chart: `refline = 0` no longer draws a line by itself.** Zero
  used to mean “no reference line”, which made the most common clinical
  reference impossible to draw - change-from-baseline, a difference and
  a log fold-change all sit at zero. Set `showRefline = TRUE` and put
  any value, including `0`, in `refline`. Scripts relying on a non-zero
  `refline` alone must add `showRefline = TRUE`.
- **Segmented Total Bar Charts: statistical tests require
  `y_is_count = TRUE`.** The chi-square is computed on the summed Value
  Variable, which is a contingency table only when that variable counts
  cases. Integrality cannot establish this - a whole-number measurement
  passes too, and the statistic then scales with the unit of
  measurement. Existing analyses with tests enabled will show an
  explanation instead of a test until the box is ticked.

### Corrected output

- **Bar Charts and Pie Charts no longer name a Fisher test that was
  never run.** On a sparse 2x2 both analyses used to advise switching
  `typestatistics` to `"nonparametric"` “to obtain Fisher’s exact test”.
  That switch produced the identical uncorrected Pearson chi-square -
  the plotting package offers no exact test - and in Pie Charts the
  copy-ready Methods sentence went as far as printing “using Fisher’s
  exact test”. The chart subtitle now reports **Fisher’s exact test
  itself**, with the odds ratio and its interval, whenever the table is
  2x2 with an expected count below 5; larger sparse tables keep the
  chi-square and the panel supplies the exact p-value to quote instead.
  **If you previously quoted a p-value from a sparse 2x2, re-check
  it** - the exact test can fall on the other side of 0.05.
- **Arc Diagram: weighted centrality used a non-standard transform.**
  Edge strengths were converted to distances by a linear reflection
  rather than the reciprocal, so betweenness and closeness could name a
  different node as the network hub. Now uses `1/w`, the published
  convention. Negative and zero weights previously aborted the analysis
  with a raw C-level igraph error and are now rejected with an
  explanation.
- **Numbers were printed at full precision throughout the module.**
  `@import jmvcore` places jmvcore’s own
  [`format()`](https://rdrr.io/r/base/format.html) - a string-template
  helper that ignores `digits`, `big.mark` and friends - ahead of
  [`base::format()`](https://rdrr.io/r/base/format.html) for the whole
  package. Summary tables read “Y Mean 19.8349757678086” and trend text
  read “0.829075514952931 unit increase”; thousands separators were
  dropped. Corrected at 97 call sites.
- **Line Chart and Automatic Plot Selection over-reported N.** Both
  counted rows rather than usable observations, so 180 rows with 155
  usable outcomes was reported as “180 of 180”. Exclusions are now
  counted correctly and itemised.
- **Automatic Plot Selection: random subsampling is disclosed.** With
  `sampleLarge` enabled, every statistic is computed on a random subset;
  the panel previously showed only a reduced row count, which reads like
  missing-data exclusion, and the explanation went to the R console.
  Discarding rows costs power - measured over 300 replicates at d = 0.05
  with n = 30,000, full-data power 99.7% against 45.3% on the 5,000-row
  draw.

### Fixed

- **Line Chart crashed on infinite values.**
  [`complete.cases()`](https://rdrr.io/r/stats/complete.cases.html)
  keeps `Inf`, which reached `var(y) == 0`, where `NaN == 0` is `NA` and
  `if (NA)` aborted the run with “missing value where TRUE/FALSE
  needed”. Non-finite rows are now excluded and the exclusion disclosed.
- **Segmented Total Bar Charts crashed on any continuous Value
  Variable** - `sprintf("%d")` on a fractional total, outside every
  guard, at default settings.
- Degenerate inputs that used to run silently now explain themselves: a
  single distinct X value (Line Chart), an empty dataset (Line Chart), a
  variable crossed with itself (Pie Charts), a one-group comparison and
  a constant outcome (Automatic Plot Selection, where a constant numeric
  was silently re-read as categorical and changed the analysis type),
  and a counts variable summing to zero (Bar Charts).
- **Malformed “Expected proportions” were applied silently.** In Bar
  Charts and Pie Charts the validation ran during plot rendering, where
  jamovi discards notices, so a wrong length, a non-numeric entry or a
  set that did not sum to 1 fell back to equal proportions with nothing
  on screen.
- **Generated syntax was invalid for awkward column names.** Pie Charts
  emitted `dep = Tumor Grade ("high")` unquoted; variable names are now
  escaped.
- **Two shipped datasets could not be loaded by name.**
  `statsplot2_repeated.rda` held an object called
  `repeated_measures_data` and `statsplot2_clinical.rda` held
  `clinical_trial_data`, so `data(statsplot2_repeated)` succeeded and
  the object still did not exist. Fixed, along with 29 others across the
  umbrella package.

### Documentation

Vignettes are **pkgdown articles only** — `vignettes/` is in
`.Rbuildignore`, so they are not built by `R CMD build`. The
`%\Vignette*` directives and `vignette:` front-matter blocks have been
removed from 17 files accordingly; four of them declared a
`quarto::html` engine whose package was not even in `Suggests`.

- New article **“What’s New in jjstatsplot 1.0.52”**, covering the new
  analysis, the breaking changes, and the analyses that do not yet have
  a walk-through of their own.
- **`jjridges` documentation rewritten from scratch.** It had been
  written against the option names of `jjridgestats` (`dep`, `group`,
  `plotStyle`, `scaling`, `colorscheme`, `mytitle`), none of which exist
  in `jjridges` — every example on the page failed. The replacement
  documents the real API, including the `x_var` (continuous) / `y_var`
  (grouping) split that is the reverse of what a box plot uses.
- **Upstream ggstatsplot argument names removed from 14 articles.**
  Examples used `type`, `title`, `subtitle`, `xlab`, `ylab`,
  `pairwise.comparisons`, `conf.level`, `x`, `y`, `id` and `paired` —
  the names of the *wrapped* functions, not of these wrappers — so
  copying them into R failed. They now use `typestatistics`, `mytitle`,
  `xtitle`, `ytitle`, `pairwisecomparisons`, `conflevel`, `dep`/`group`
  and `dep1`/`dep2`. The mapping was applied per function:
  `jjhistostats` and `jjcorrmat` genuinely have `title`, `subtitle` and
  `xlab`, and were left alone. Arguments with no equivalent at all
  (`jjbarstats` and `jjpiestats` have no title options) were removed
  rather than renamed.
- The Line Chart article uses `showRefline = TRUE` in every
  reference-line example.
- Articles for analyses still in development — `bbcplots`,
  `advancedbarplot`, `economistplots`, `jsjplot`, `jjtreemap`,
  `basegraphics` — each carry a notice saying so.

#### Articles removed or relocated

| Article | Action |
|----|----|
| `jjridgestats` | **Removed** — superseded by [`jjridges()`](https://www.serdarbalci.com/jjstatsplot/reference/jjridges.md). Not drop-in replacements. |
| `jjriverplot` | **Moved to ClinicoPathDescriptives**, where the analysis lives as `riverplot()` (13 of 14 documented arguments match). |
| `advancedtree` | **Moved to meddecide**, where the analysis lives as `treeadvanced()`. The article documents more options than are implemented; the notice lists which. |
| `jjsankeyfier`, `jjstreamgraph` | **Removed** — no analysis of either name exists in any module. |

- `31-jjscatterstats-comprehensive.Rmd` was a single line of escaped
  text (literal `\n` and `\"` throughout) and could not render at all.
  Restored to 407 lines.

### Known issues

- ~~The “Plot with Aesthetics” panel in Scatter Plot is always shown.~~
  **Fixed.** The `visible:` rule began with `!`, which fails jmvcore’s
  expression routing: the expression was handed back as a raw (truthy)
  string, so an empty aesthetics plot sat under every analysis. Now
  `(colorvar || sizevar || shapevar || alphavar || labelvar)`. A sweep
  of all 19 shipped analyses found one more instance —
  `enable: (!resultssubtitle)` in `jjhistostats.u.yaml`, which left that
  box permanently enabled — also fixed.
- Five analyses have no dedicated vignette yet: `hullplot`,
  `jjdotchart`, `jjsegmentedtotalbar`, `raincloud` and `statsplot2`.
  Their option lists are documented in the new What’s New vignette.

## jjstatsplot 1.0.4 (2026-08-07)

### Note

- **No shipped analysis changed in this release.** Between 1.0.2 and
  1.0.4 every file belonging to the eighteen analyses distributed here —
  the ggstatsplot wrappers and the related plotting analyses
  (`advancedraincloud`, `hullplot`, `jjarcdiagram`, `jjbarstats`,
  `jjbetweenstats`, `jjcorrmat`, `jjdotplotstats`, `jjhistostats`,
  `jjpiestats`, `jjridges`, `jjscatterstats`, `jjsegmentedtotalbar`,
  `jjwithinstats`, `jwaffle`, `linechart`, `lollipop`, `raincloud`,
  `statsplot2`) — was touched only by the version string. No backend
  (`.b.R`) file, no option (`.a.yaml`), results (`.r.yaml`) or interface
  (`.u.yaml`) definition was modified. Nothing a user can observe in the
  jamovi GUI or from the R wrappers differs from 1.0.2; no statistical
  method, default, plot or output was altered.
- The pre-release review pass carried out over this window covered the
  diagnostic-decision family (`meddecide`) and the oncology-pathology
  family (`OncoPath`) — comparison of diagnostic tests, interrater
  agreement, swimmer plots, IHC heterogeneity and diagnostic
  meta-analysis. **None of those analyses is shipped by this module**,
  so none of the fixes or the accompanying breaking option changes
  reaches users of `jjstatsplot`. They are described in the NEWS files
  of the modules that own them.

### Known issues

- **The “Plot with Aesthetics” panel in Scatter Plot (`jjscatterstats`)
  is always shown.** Its visibility rule in
  `jamovi/jjscatterstats.r.yaml` begins with `!`
  (`(!is.null(colorvar) || ...)`), and a leading `!` fails jmvcore’s
  expression-routing pattern: instead of being evaluated, the expression
  is handed back as a raw string, which is truthy, so the item is
  permanently visible. An empty aesthetics plot therefore sits under the
  analysis even when no colour, size, shape, alpha or label variable has
  been chosen. This is one instance of a defect confirmed across the
  umbrella package (26 `visible:`/`enable:` expressions in 17 `.r.yaml`
  files); it is tracked and not yet fixed here. Interface (`.u.yaml`)
  conditions are unaffected — those are evaluated by the jamovi
  frontend, which handles `!` correctly.
- **`jamovi/0000.yaml` advertises five analyses this module does not
  contain.** `basegraphics`, `jjcoefstats`, `jjpubr`, `jjsyndromicplot`
  and `pcaloadingheatmap` were added to the module manifest, but none of
  their backend, header or definition files is distributed here, and all
  five still carry the `JJStatsPlotT` development menu group used to
  route a function away from the production menu while it is under
  modification. They cannot be instantiated and should be treated as
  absent.
- `janitor` and `labelled` were added to DESCRIPTION `Imports`. Neither
  is called by any file shipped in this module; they are collateral from
  the umbrella-wide dependency sync and are candidates for removal
  rather than a new capability.

## jjstatsplot 1.0.3 (2026-08-04)

### Note

- Version and release-date bump only, published without its own entry at
  the time. No file of any shipped analysis changed. It is described
  together with 1.0.4 above.

## jjstatsplot 1.0.2 (2026-08-03)

### Fixed

- **Optional variables were required arguments of the R function.** Ten
  analyses declared variables with no default in their jamovi option
  definition, which compiles to a bare parameter in the generated
  wrapper. Calling the analysis from R without one failed with
  `argument "X" is missing, with no default` before the analysis could
  report its own message — including for plainly optional inputs such as
  `jjhistostats(grvar =)`, the “Split By” grouping variable. These now
  default to `NULL`: `advancedraincloud` (`x_var`, `y_var`),
  `jjarcdiagram` (`source`, `target`), `jjbarstats` (`dep`, `group`),
  `jjcorrmat` (`grvar`), `jjdotplotstats` (`grvar`), `jjhistostats`
  (`grvar`), `jjpiestats` (`dep`), `jjsegmentedtotalbar` (`fill_var`,
  `x_var`, `y_var`), `jwaffle` (`groups`) and `statsplot2` (`dep`,
  `group`). Behaviour in the jamovi GUI is unchanged; no statistical
  method was altered.

### Note

- The pre-release review pass carried out this release covered the
  survival-family and diagnostic-decision analyses (`jsurvival`,
  `meddecide`) and a package-wide
  [`format()`](https://rdrr.io/r/base/format.html) namespace fix in the
  umbrella package. **No analysis shipped here was changed** — none of
  the affected files is distributed to this module.

### Added

- **Automated GitHub release (`.github/workflows/release.yaml`).** A
  push to the default branch touching `DESCRIPTION` or
  `jamovi/0000.yaml` cross-checks the two version strings, refuses to
  proceed if they disagree, and — if the tag does not already exist —
  tags `v<version>` and publishes a release whose notes are the matching
  section of this file.

## jjstatsplot 0.0.47 (2026-07-05)

### Bug Fixes

- **Fixed a crash on labelled (SPSS/Stata) data.**
  [`haven::as_factor()`](https://forcats.tidyverse.org/reference/as_factor.html)
  is used by `jjwithinstats` and `jwaffle`, but `haven` was missing from
  the package `Imports`. Because jamovi installs only a package’s
  `Imports`, those analyses crashed on labelled data on a clean install.
  `haven` is now declared.
- Declared additional plotting dependencies used via `::` but previously
  undeclared: `car`, `cowplot`, `e1071`, `ggExtra`, `ggprism`,
  `ggrepel`, `patchwork`, `viridisLite`.

## jjstatsplot 0.0.46 (2026-07-04)

This release consolidates all work from 0.0.32.66 through 0.0.46 into a
single entry. The main themes are: a new **“Important Information”
notices system** surfacing typed diagnostic messages across analyses;
extensive **input-validation and HTML-escaping hardening** of the
backends; **multiple-endpoint-correction guidance** for group
comparisons; and **dependency/infrastructure cleanup** that raises the
minimum jamovi version to 2.7.27.

### New Features

#### “Important Information” Notices

- **NEW**: Added an “Important Information” `Preformatted` output
  (`notices`) that surfaces prioritized, typed messages (ERROR /
  STRONG_WARNING / WARNING / INFO) generated during the analysis to
  seven modules:
  - **Arc Diagram** (`jjarcdiagram`)
  - **Bar Charts** (`jjbarstats`)
  - **Pie Charts** (`jjpiestats`)
  - **Advanced Ridge Plot** (`jjridges`) — replaces the previous
    free-form `Notices` (`Html`, always-visible) output
  - **Waffle Charts** (`jwaffle`)
  - **Lollipop Chart** (`lollipop`)
  - **statsplot2** (`statsplot2`)
- Backends for `jjarcdiagram`, `jjbarstats`, `jjpiestats`, `jwaffle`,
  `lollipop`, and `statsplot2` gained a shared `.addNotice()` /
  `.renderNotices()` helper pair that accumulates notices and renders
  them safely, avoiding the
  [`jmvcore::Notice`](https://rdrr.io/pkg/jmvcore/man/Analysis.html)
  serialization failure.

#### Multiple-Endpoint Correction Guidance (`jjbetweenstats`)

- **NEW** results panels `mecGuidance`, `diagnostics`, and
  `clinicalSummary` (all `Html`):
  - `mecGuidance` renders step-by-step guidance for the
    `multiEndpointCorrection` option (`none` / `bonferroni` / `holm` /
    `fdr`), including the adjusted significance threshold and a
    family-wise error-rate inflation warning when multiple dependent
    variables are tested.
  - `diagnostics` renders data-quality and assumption diagnostics.
  - `clinicalSummary` renders a natural-language clinical
    interpretation.
  - Guidance and diagnostics are now rendered from `.run()` into
    always-visible elements (via `setContent()`), so they reliably
    appear and update when options change — fixing content that
    previously vanished on option-only changes because it was emitted
    only from the memoized `.prepareData()` path.

#### Natural-Language Summary (`linechart`)

- **NEW** `naturalSummary` (`Html`) output providing a plain-language
  summary of the line chart.

### Enhanced Existing Modules

- **Bar Charts** (`jjbarstats`): input validation now rejects continuous
  variables used as categories, non-numeric or negative `counts` values,
  and grouping variables with fewer than 2 categories; auto-selects
  Fisher’s exact test when appropriate; validates paired-data structure;
  validates and normalizes expected-proportion `ratio` values (with
  warnings on parse errors); UI reorganized into `CollapseBox` / `Label`
  groups.
- **Between-Group Comparisons** (`jjbetweenstats`): UI reorganized into
  `CollapseBox` / `Label` groups.
- **Arc Diagram** (`jjarcdiagram`): added network-size notices (trivial
  / very-small / small / large network), density notices (high /
  sparse), self-loop detection and removal, and edge-aggregation
  reporting.
- **Housekeeping across modules**: descriptive text and option titles
  were rewritten to avoid the literal `%` character (e.g. “100%” → “100
  percent”, “Winsorize (5/95%)” → “Winsorize (5/95 percent)”, “Show CV%
  Bands” → “Show CV percent Bands”) for compatibility with the
  notices/preformatted output.

### Security & Robustness

- **HTML escaping**:
  [`htmltools::htmlEscape()`](https://rstudio.github.io/htmltools/reference/htmlEscape.html)
  is now applied to all user-supplied values interpolated into HTML
  output — variable names, group and factor labels, baseline-group
  names, and network node names — across `hullplot`, `jjarcdiagram`,
  `jjbarstats`, `jjbetweenstats`, `jjpiestats`, and others, preventing
  HTML/script injection via malicious column names or factor levels.
- **Safe formula construction**: `jjbarstats` builds its counts formula
  (`counts ~ var1 + var2`) with
  [`jmvcore::composeTerm()`](https://rdrr.io/pkg/jmvcore/man/decomposeTerm.html)
  instead of raw string pasting.
- **Input validation**:
  [`jmvcore::reject()`](https://rdrr.io/pkg/jmvcore/man/reject.html)
  guards for empty datasets, missing/not-found variables, and
  no-complete-cases conditions across `hullplot`, `jjarcdiagram`,
  `jjbarstats`, and others.
- **Shared helpers** added to `R/utils.R`:
  [`.escapeVariableNames()`](https://www.serdarbalci.com/jjstatsplot/reference/dot-escapeVariableNames.md),
  `.asSurvivalFormula()` (extends the jmvcore 2.7.27 `asFormula`
  allow-list), `.buildSurvivalFormula()`, and the `%notin%` / `%!in%`
  operators.

### Bug Fixes

- **Line Chart** (`linechart`): added the missing `naturalSummary`
  results element that the backend calls via `setContent()`, which
  previously caused an error (community contribution — PR
  [\#12](https://github.com/sbalci/ClinicoPathJamoviModule/issues/12) by
  G Chia).
- **Between-Group Comparisons** (`jjbetweenstats`): fixed
  multi-dependent-variable plotting by passing the aesthetic symbol
  directly (`y = y`) instead of `y = !!y` inside a plain
  [`list()`](https://rdrr.io/r/base/list.html), which errored with
  “invalid argument type”.
- **Histogram** (`jjhistostats`): fixed the conditional visibility of
  the grouped ggpubr plot (`ggpubrPlot2`) to use `!is.null(grvar)`;
  renamed the ggpubr output titles to remove parentheses (e.g. “Density
  Plot (ggpubr)” → “Density Plot ggpubr”).
- **Scatter Plot** (`jjscatterstats`): adjusted the grouped-plot
  (`plot2`) visibility condition.

### Package Infrastructure

- Version bumped to **0.0.46** (Date 2026-07-04); minimum jamovi
  (`minApp`) raised from **1.2.19** to **2.7.27**.
- DESCRIPTION `Imports` reorganized one-per-line; **added** `DT` and
  `extrafont`; **moved** `ggcorrplot`, `ggside`, `performance`, and
  `PMCMRplus` from `Imports` to `Suggests`.
- **Added** `ClinicoPath/waffle` to `Remotes` (alongside
  `gastonstat/arcdiagram`).
- Switched to `Config/roxygen2/version: 8.0.0` (from
  `RoxygenNote: 7.3.3`).

------------------------------------------------------------------------

## jjstatsplot 0.0.32.66 (2026-01-01)

### New Features

#### ggpubr Integration

- **NEW**: Added publication-ready plot variants using `ggpubr` package
  across multiple analyses
  - **jjwithinstats**: Added ggpubr plot option for
    within-subjects/paired data
    - Multiple plot types: boxplot, violin, paired (with connecting
      lines), line (mean trajectory)
    - Journal-specific color palettes: JCO, NPG, AAAS, Lancet, JAMA,
      NEJM
    - Options for statistical comparisons, individual trajectories, and
      overlay points
  - **jjpiestats**: Added modern donut chart variant
    - Publication-ready donut charts with journal color palettes
    - Clean, professional aesthetic for reports and publications

#### Enhanced Clinical Workflow Features

##### Ridge Plots (jjridges)

- **NEW**: Clinical analysis presets with automatic configuration
  - Biomarker Distribution (nonparametric + Cliff’s delta)
  - Treatment Response (violin plots + Bonferroni correction)
  - Age by Disease Stage (parametric + Cohen’s d)
  - Tumor Size Comparison (Hodges-Lehmann shift)
  - Lab Values by Group (robust tests + Hedges’ g)
  - Survival Time Distribution (median + quartiles)
- Added comprehensive help panels:
  - `showAboutPanel`: Interpretation guidance and clinical examples
  - `showAssumptions`: Statistical assumptions and methodological notes
- Enhanced statistical warnings for repeated measures/longitudinal data

##### Pie Charts (jjpiestats)

- **NEW**: Interactive guidance panels
  - `showSummary`: Natural-language summary suitable for copy-paste into
    reports
  - `showAssumptions`: Detected violations and Fisher exact test
    recommendations
  - `showInterpretation`: Effect size interpretation and clinical
    context

##### Segmented Total Bar Charts (jjsegmentedtotalbar)

- **NEW**: Dual plot type support
  - Traditional 100% stacked bars
  - **Flerlage-style segmented total bars** (Kevin Flerlage design)
    - Emphasizes both totals and composition
    - Customizable labels, colors, transparency
    - Background box styling options
- Reorganized options for clearer workflow

##### Lollipop Charts

- **NEW**: Data aggregation options for repeated measures
  - No aggregation (plot all points)
  - Mean, Median, Sum aggregation
  - Guidance for clinical measurements vs. counts
- Default empty strings for labels/titles for cleaner initial plots

#### User Experience Improvements

- Multiple analyses updated with improved default settings for cleaner
  initial plots
  - jjwithinstats: Violin and boxplot defaults changed to `false` for
    simpler initial view
  - jjpiestats: Proportion test and BF message defaults to `false` to
    reduce clutter
  - jjsegmentedtotalbar: Percentages, outlines, export_ready defaults to
    `false`
  - jwaffle: Legend default to `false`
- Enhanced explanatory text across multiple analyses
- Improved statistical assumption warnings (especially for repeated
  measures data)

### Package Dependencies

- **Added** `ggpubr` to Imports for publication-ready plot variants
- **Added** `rstatix` to Imports for enhanced statistical testing
  support

### Documentation

- Updated R documentation for all modified analyses
- Enhanced roxygen2 documentation with version 7.3.3
- Improved parameter descriptions and usage examples

### Bug Fixes

- Fixed documentation formatting issues in several .Rd files

------------------------------------------------------------------------

## jjstatsplot 0.0.31.84 (2025-10-03)

### New Features

#### Hull Plot Analysis

- **NEW**: Added `hullplot` module for cluster and group visualization
  - Creates polygonal boundaries around data points grouped by
    categorical variables
  - Based on
    [`ggforce::geom_mark_hull()`](https://ggforce.data-imaginist.com/reference/geom_mark_hull.html)
    function
  - Perfect for visualizing customer segments, patient subgroups, and
    data clusters
  - Features include:
    - Customizable hull concavity (0-2 range)
    - Optional confidence ellipses
    - Outlier detection
    - Group statistics summary
    - Natural language interpretation
    - Multiple color palettes (default, viridis, Set1, Set2, Dark2,
      clinical)
    - Multiple plot themes (minimal, classic, light, dark, clinical)
    - Support for color and size variables
    - Automatic fallback to convex hulls when V8/concaveman packages
      unavailable

### Improvements

#### Package Dependencies

- Added `ggforce` to Imports for hull plot functionality
- Added `grid` to Imports for unit handling in hull plots

#### Documentation

- Updated DESCRIPTION with new analysis count (18 analyses)
- Updated README to include hull plot in analysis types table
- Enhanced package description to reflect expanded capabilities

### Bug Fixes

- None in this release

------------------------------------------------------------------------

## jjstatsplot 0.0.31.57 (2025-09-03)

### Release Highlights

- Early release for September 2025
- Comprehensive statistical visualization suite with 17+ analysis types
- Publication-ready plots with statistical annotations

### Core Features

#### Distribution Analysis

- `jjhistostats` - Histograms with Shapiro-Wilk test and robust measures
- `jjridges` - Ridge plots for multiple distribution overlay
- `jwaffle` - Waffle charts for part-to-whole visualization

#### Continuous vs Continuous

- `jjscatterstats` - Scatter plots with correlation analysis
- `jjcorrmat` - Correlation matrices with significance testing

#### Categorical vs Continuous

- `jjbetweenstats` - Between-groups comparisons (ANOVA, Kruskal-Wallis)
- `jjwithinstats` - Within-subjects comparisons (repeated measures)
- `jjdotplotstats` - Dot charts with confidence intervals
- `raincloud` - Basic raincloud plots (distribution + individual points)
- `advancedraincloud` - Enhanced raincloud plots with longitudinal
  support
- `lollipop` - Lollipop charts for ranked data

#### Categorical vs Categorical

- `jjbarstats` - Bar charts with chi-square and Fisher’s exact test
- `jjpiestats` - Pie charts with goodness of fit tests
- `jjsegmentedtotalbar` - Segmented bar charts with totals

#### Network and Time Series

- `jjarcdiagram` - Arc diagrams for network visualization
- `linechart` - Line charts for trends over time

#### Advanced Features

- `statsplot2` - Automatic plot selection based on variable types
- Dual-mode operation (single/grouped variables)
- Statistical flexibility (parametric, non-parametric, robust, Bayesian)
- Theme support (jamovi-style and ggstatsplot themes)
- Dynamic plot sizing based on data dimensions

### Dependencies

- R (\>= 4.0.0)
- Core: jmvcore, R6, ggstatsplot
- Plotting: ggplot2, ggalluvial, ggside, ggcorrplot, ggdist, ggridges,
  ggrain
- Statistical: PMCMRplus, WRS2, BayesFactor, effectsize, performance,
  moments

------------------------------------------------------------------------

### Earlier Versions

### jjstatsplot 0.0.3.91

- Enhanced vignettes and reference documentation
- Improved package metadata

### jjstatsplot 0.0.3.90

- Added comprehensive vignette collection (40+ files)
- Improved documentation structure

### jjstatsplot 0.0.3.89

- Release candidate for jamovi 2.7.2
- Removed embedded images from vignettes
- Performance improvements

### jjstatsplot 0.0.3.70

- Initial public release
- Core ggstatsplot wrapper functionality
- Basic jamovi module integration
