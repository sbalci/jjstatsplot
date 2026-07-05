# jjstatsplot 0.0.46 (2026-07-04)

This release consolidates all work from 0.0.32.66 through 0.0.46 into a single entry. The main themes are: a new **"Important Information" notices system** surfacing typed diagnostic messages across analyses; extensive **input-validation and HTML-escaping hardening** of the backends; **multiple-endpoint-correction guidance** for group comparisons; and **dependency/infrastructure cleanup** that raises the minimum jamovi version to 2.7.27.

## New Features

### "Important Information" Notices
- **NEW**: Added an "Important Information" `Preformatted` output (`notices`) that surfaces prioritized, typed messages (ERROR / STRONG_WARNING / WARNING / INFO) generated during the analysis to seven modules:
  - **Arc Diagram** (`jjarcdiagram`)
  - **Bar Charts** (`jjbarstats`)
  - **Pie Charts** (`jjpiestats`)
  - **Advanced Ridge Plot** (`jjridges`) — replaces the previous free-form `Notices` (`Html`, always-visible) output
  - **Waffle Charts** (`jwaffle`)
  - **Lollipop Chart** (`lollipop`)
  - **statsplot2** (`statsplot2`)
- Backends for `jjarcdiagram`, `jjbarstats`, `jjpiestats`, `jwaffle`, `lollipop`, and `statsplot2` gained a shared `.addNotice()` / `.renderNotices()` helper pair that accumulates notices and renders them safely, avoiding the `jmvcore::Notice` serialization failure.

### Multiple-Endpoint Correction Guidance (`jjbetweenstats`)
- **NEW** results panels `mecGuidance`, `diagnostics`, and `clinicalSummary` (all `Html`):
  - `mecGuidance` renders step-by-step guidance for the `multiEndpointCorrection` option (`none` / `bonferroni` / `holm` / `fdr`), including the adjusted significance threshold and a family-wise error-rate inflation warning when multiple dependent variables are tested.
  - `diagnostics` renders data-quality and assumption diagnostics.
  - `clinicalSummary` renders a natural-language clinical interpretation.
  - Guidance and diagnostics are now rendered from `.run()` into always-visible elements (via `setContent()`), so they reliably appear and update when options change — fixing content that previously vanished on option-only changes because it was emitted only from the memoized `.prepareData()` path.

### Natural-Language Summary (`linechart`)
- **NEW** `naturalSummary` (`Html`) output providing a plain-language summary of the line chart.

## Enhanced Existing Modules

- **Bar Charts** (`jjbarstats`): input validation now rejects continuous variables used as categories, non-numeric or negative `counts` values, and grouping variables with fewer than 2 categories; auto-selects Fisher's exact test when appropriate; validates paired-data structure; validates and normalizes expected-proportion `ratio` values (with warnings on parse errors); UI reorganized into `CollapseBox` / `Label` groups.
- **Between-Group Comparisons** (`jjbetweenstats`): UI reorganized into `CollapseBox` / `Label` groups.
- **Arc Diagram** (`jjarcdiagram`): added network-size notices (trivial / very-small / small / large network), density notices (high / sparse), self-loop detection and removal, and edge-aggregation reporting.
- **Housekeeping across modules**: descriptive text and option titles were rewritten to avoid the literal `%` character (e.g. "100%" → "100 percent", "Winsorize (5/95%)" → "Winsorize (5/95 percent)", "Show CV% Bands" → "Show CV percent Bands") for compatibility with the notices/preformatted output.

## Security & Robustness

- **HTML escaping**: `htmltools::htmlEscape()` is now applied to all user-supplied values interpolated into HTML output — variable names, group and factor labels, baseline-group names, and network node names — across `hullplot`, `jjarcdiagram`, `jjbarstats`, `jjbetweenstats`, `jjpiestats`, and others, preventing HTML/script injection via malicious column names or factor levels.
- **Safe formula construction**: `jjbarstats` builds its counts formula (`counts ~ var1 + var2`) with `jmvcore::composeTerm()` instead of raw string pasting.
- **Input validation**: `jmvcore::reject()` guards for empty datasets, missing/not-found variables, and no-complete-cases conditions across `hullplot`, `jjarcdiagram`, `jjbarstats`, and others.
- **Shared helpers** added to `R/utils.R`: `.escapeVariableNames()`, `.asSurvivalFormula()` (extends the jmvcore 2.7.27 `asFormula` allow-list), `.buildSurvivalFormula()`, and the `%notin%` / `%!in%` operators.

## Bug Fixes

- **Line Chart** (`linechart`): added the missing `naturalSummary` results element that the backend calls via `setContent()`, which previously caused an error (community contribution — PR #12 by G Chia).
- **Between-Group Comparisons** (`jjbetweenstats`): fixed multi-dependent-variable plotting by passing the aesthetic symbol directly (`y = y`) instead of `y = !!y` inside a plain `list()`, which errored with "invalid argument type".
- **Histogram** (`jjhistostats`): fixed the conditional visibility of the grouped ggpubr plot (`ggpubrPlot2`) to use `!is.null(grvar)`; renamed the ggpubr output titles to remove parentheses (e.g. "Density Plot (ggpubr)" → "Density Plot ggpubr").
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

# Earlier Versions

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
