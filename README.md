# jjstatsplot

## A statistical visualization bridge for jamovi based on ggstatsplot and modern R plotting packages

[![R-CMD-check](https://github.com/sbalci/jjstatsplot/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/sbalci/jjstatsplot/actions/workflows/R-CMD-check.yaml)
[![jamovi](https://img.shields.io/badge/jamovi-module-blue)](https://www.jamovi.org)
[![ggstatsplot-wrapper](https://img.shields.io/badge/ggstatsplot-wrapper-orange)](https://www.indrapatil.com/ggstatsplot/)
[![License: GPL (>= 2)](https://img.shields.io/badge/license-GPL%20(%3E=%202)-blue.svg)](https://www.gnu.org/licenses/gpl-2.0.html)
[![Documentation](https://img.shields.io/badge/docs-pkgdown-blue.svg)](https://www.serdarbalci.com/jjstatsplot/)

## Statistical Visualization Made Simple

**jjstatsplot** brings the power of [ggstatsplot](https://www.indrapatil.com/ggstatsplot/) and modern statistical plotting tools to [jamovi](https://www.jamovi.org), making publication-ready statistical visualizations accessible through an intuitive point-and-click interface. It automatically integrates hypothesis tests, effect sizes, confidence intervals, sample sizes, and distribution diagnostics directly onto your figures—without writing a single line of code.

With **19 distinct analysis types**, jjstatsplot covers everything from baseline univariate distributions to multi-group comparisons, network arcs, ridgeline density plots, and automated intelligent plot selection.

---

## ✨ Key Features & Analysis Suite (19 Analyses)

| Category | Analysis | Function | Statistical Details & Clinical Applications |
| :--- | :--- | :--- | :--- |
| **Continuous Distributions** | **Histogram** | `jjhistostats` | Distribution visualization with Shapiro-Wilk normality testing, parametric/robust/Bayesian central tendency, and density overlays. |
| **Continuous vs Continuous** | **Scatter Plot** | `jjscatterstats` | Pairwise association with Pearson/Spearman/robust correlation coefficients, regression fits, and marginal distribution plots. |
| **Continuous vs Continuous** | **Correlation Matrix** | `jjcorrmat` | Multi-variable correlation matrices displaying pairwise correlation strength, significance markers, and clustering. |
| **Continuous vs Continuous** | **Hull Plot** | `hullplot` | Bivariate scatter with convex polygonal hull boundaries highlighting distinct clinical clusters and group separation. |
| **Group Comparisons** | **Between-Groups Box-Violin** | `jjbetweenstats` | Group comparison with violin plots, boxplots, raw data points, one-way ANOVA / Kruskal-Wallis, post-hoc tests, and effect sizes (eta-squared, Cohen's d). |
| **Group Comparisons** | **Within-Subjects Box-Violin** | `jjwithinstats` | Repeated measures and matched-pair comparison using repeated measures ANOVA or Friedman tests with paired trajectory lines. |
| **Group Comparisons** | **Horizontal Dot Plot** | `jjdotplotstats` | Horizontal box-violin mean comparison across categorical factors with detailed effect sizes and confidence intervals. |
| **Group Comparisons** | **Dot Chart** | `jjdotchart` | Cleveland-style dot charts comparing observed group summaries against reference values or predefined clinical benchmarks. |
| **Categorical Associations** | **Bar Charts** | `jjbarstats` | Frequency comparisons with Pearson Chi-square, Fisher's exact test, Cramer's V effect size, and natural language summary annotations. |
| **Categorical Associations** | **Pie Charts** | `jjpiestats` | Proportion visualization with chi-square goodness-of-fit testing for composition analysis. |
| **Categorical Associations** | **Segmented Total Bar** | `jjsegmentedtotalbar` | Stacked proportion bars reporting both segment-level and aggregate total category statistics. |
| **Categorical Associations** | **Waffle Charts** | `jwaffle` | Square icon/matrix waffle charts for intuitive patient-level proportion and ratio visualization. |
| **Advanced Distributions** | **Raincloud Plot** | `raincloud` | Integrated distribution display combining raw scatter points (jitter), boxplot summary, and smoothed half-density cloud. |
| **Advanced Distributions** | **Advanced Raincloud** | `advancedraincloud` | Enhanced raincloud plot supporting longitudinal tracking, multi-group stratification, and custom orientation. |
| **Advanced Distributions** | **Ridgeline Plot** | `jjridges` | Staggered multi-group density ridges (joyplots) for comparing biomarker distribution shifts across stages or cohorts. |
| **Network & Flows** | **Arc Diagram** | `jjarcdiagram` | Network arc diagrams displaying connections and co-occurrence strength between discrete pathological entities. |
| **Trends & Time Series** | **Line Chart** | `linechart` | Longitudinal trajectory and trend plots with error bars, confidence intervals, and slope change annotations. |
| **Ranked Data** | **Lollipop Chart** | `lollipop` | Clean, high-data-to-ink ratio lollipop plots for comparing ranked numerical values across extensive categories. |
| **Automated Selection** | **Automatic Plot Selection** | `statsplot2` | Intelligent plotting engine that automatically inspects selected variable types and renders the optimal statistical plot. |

---

## 🚀 Advanced Capabilities

- **Statistical Paradigms**: Switch seamlessly between parametric, non-parametric, robust, and Bayesian statistical frameworks.
- **Grouped & Faceted Analysis**: Automatic multi-panel faceting by secondary clinical factors.
- **Theme & Aesthetic Control**: Choose between native jamovi styling or ggstatsplot's color palettes and typography.
- **Reproducibility**: All GUI interactions generate clean, reproducible R code using underlying tidyverse and ggstatsplot idioms.

---

## 📦 Installation

### In jamovi (Recommended)

1. Open **jamovi** (>= 2.6).
2. Click **Modules** (top right) → **jamovi library**.
3. Search for **jjstatsplot**.
4. Click **Install**.

### As an R Package

```r
# Install development version from GitHub
remotes::install_github("sbalci/jjstatsplot")
```

---

## 🏃 Quick Start (R Interface)

```r
library(jjstatsplot)

# 1. Distribution analysis with statistical test
jjstatsplot::jjhistostats(
  data = iris,
  dep = "Sepal.Length",
  xlab = "Sepal Length (cm)",
  results.subtitle = TRUE
)

# 2. Between-group box-violin comparison with ANOVA/Kruskal-Wallis
jjstatsplot::jjbetweenstats(
  data = mtcars,
  dep = "mpg",
  group = "cyl",
  type = "nonparametric"
)

# 3. Correlation matrix with significance levels
jjstatsplot::jjcorrmat(
  data = mtcars,
  vars = vars(mpg, hp, wt, qsec)
)

# 4. Raincloud plot combining density, boxplot, and points
jjstatsplot::raincloud(
  data = iris,
  dep = "Sepal.Width",
  group = "Species"
)
```

---

## 📚 Documentation & Resources

- **Module Documentation**: [https://www.serdarbalci.com/jjstatsplot/](https://www.serdarbalci.com/jjstatsplot/)
- **ClinicoPath Umbrella Ecosystem**: [https://www.serdarbalci.com/ClinicoPathJamoviModule/](https://www.serdarbalci.com/ClinicoPathJamoviModule/)
- **ggstatsplot Upstream Package**: [https://www.indrapatil.com/ggstatsplot/](https://www.indrapatil.com/ggstatsplot/)
- **Issue Tracker & Feature Requests**: [GitHub Issues](https://github.com/sbalci/jjstatsplot/issues)

---

## 📄 Citation

If you use jjstatsplot in your research, please cite:

```bibtex
@manual{balci2026clinicopath,
  title  = {ClinicoPath: jamovi Module for Clinicopathological Research},
  author = {Serdar Balci},
  year   = {2026},
  url    = {https://www.serdarbalci.com/ClinicoPathJamoviModule/},
  doi    = {10.5281/zenodo.3997188}
}
```

Please also cite the underlying package:
- Patil, I. (2021). Visualizations with statistical details: The 'ggstatsplot' approach. *Journal of Open Source Software*, 6(61), 3167.

## 📝 License

GPL (>= 2) — see the [LICENSE.md](LICENSE.md) file for details.
