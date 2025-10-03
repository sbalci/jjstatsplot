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
