# jjstatsplot

## A wrapper for ggstatsplot: jjstatsplot help researchers to generate plots in jamovi based on ggstatsplot package. Also includes additional plots

[![R-CMD-check](https://github.com/sbalci/jjstatsplot/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/sbalci/jjstatsplot/actions/workflows/R-CMD-check.yaml)
[![jamovi](https://img.shields.io/badge/jamovi-module-blue)](https://www.jamovi.org)
[![ggstatsplot-wrapper](https://img.shields.io/badge/ggstatsplot-wrapper-orange)](https://indrajeetpatil.github.io/ggstatsplot/)
[![License: GPL (>= 2)](https://img.shields.io/badge/license-GPL%20(%3E=%202)-blue.svg)](https://www.gnu.org/licenses/gpl-2.0.html)

## Statistical Visualization Made Simple

**jjstatsplot** brings the power of [ggstatsplot](https://indrajeetpatil.github.io/ggstatsplot/) to [jamovi](https://www.jamovi.org), making publication-ready statistical visualizations accessible through an intuitive point-and-click interface. This R package bridges the gap between sophisticated statistical plotting and user-friendly data analysis, enabling researchers to create informative plots enriched with statistical details without writing code.

### 🎯 Why jjstatsplot?

Traditional statistical software often separates visualization from analysis, requiring users to manually annotate plots with statistical results. jjstatsplot integrates these steps, automatically adding appropriate statistical tests, effect sizes, and sample sizes to your visualizations. Whether you're exploring data distributions, comparing groups, examining correlations, or analyzing categorical relationships, jjstatsplot provides the right visualization with the right statistics—all through jamovi's familiar interface.

## ✨ Key Features

### 📊 Comprehensive Analysis Types

| Category                             | Analysis                             | Description                 | Statistical Details                        |
| ------------------------------------ | ------------------------------------ | --------------------------- | ------------------------------------------ |
| **Continuous**                 | Histogram (`jjhistostats`)         | Distribution visualization  | Shapiro-Wilk test, robust measures         |
| **Continuous vs Continuous**   | Scatter Plot (`jjscatterstats`)    | Relationship analysis       | Correlation coefficients, regression lines |
| **Continuous vs Continuous**   | Correlation Matrix (`jjcorrmat`)   | Multiple correlations       | Significance levels, correlation strength  |
| **Categorical vs Continuous**  | Box-Violin Plot (`jjbetweenstats`) | Between-groups comparison   | ANOVA, Kruskal-Wallis, post-hoc tests      |
| **Categorical vs Continuous**  | Box-Violin Plot (`jjwithinstats`)  | Within-subjects comparison  | Repeated measures ANOVA, Friedman test     |
| **Categorical vs Continuous**  | Dot Chart (`jjdotplotstats`)       | Mean comparisons            | Confidence intervals, effect sizes         |
| **Categorical vs Categorical** | Bar Chart (`jjbarstats`)           | Frequency analysis          | Chi-square, Fisher's exact test            |
| **Categorical vs Categorical** | Pie Chart (`jjpiestats`)           | Proportion visualization    | Goodness of fit tests                      |
| **Distribution**               | Waffle Chart (`jjwaffle`)          | Part-to-whole visualization | Custom proportions display                 |
| **Advanced Distributions**     | Raincloud (`raincloud`)            | Distribution + individual points | Kernel density, quartiles                |
| **Advanced Distributions**     | Advanced Raincloud (`advancedraincloud`) | Enhanced raincloud plots   | Longitudinal support, multi-group comparison |
| **Distribution Comparison**     | Ridge Plots (`jjridges`)           | Multiple distribution overlay | Density curves by groups                  |
| **Network/Flow**               | Arc Diagrams (`jjarcdiagram`)      | Network visualization       | Connection strength, node properties       |
| **Segmented Analysis**         | Segmented Bar (`jjsegmentedtotalbar`) | Stacked proportions        | Total and segment statistics               |
| **Time Series**                | Line Chart (`linechart`)           | Trends over time            | Change rates, seasonal patterns            |
| **Ranked Data**                | Lollipop Chart (`lollipop`)        | Ranked comparisons          | Ordered categorical analysis               |
| **Extended Analysis**          | Stats Plot 2 (`statsplot2`)        | Extended statistical plots  | Multiple statistical approaches            |

### 🚀 Advanced Capabilities

- **Dual-Mode Operation**: Analyze single variables or multiple variables simultaneously
- **Grouped Analysis**: Automatic faceting by grouping variables
- **Statistical Flexibility**: Choose between parametric, non-parametric, robust, and Bayesian approaches
- **Customization Options**: Control plot aesthetics, statistical details, and output formatting
- **Theme Support**: Use jamovi's consistent styling or ggstatsplot's original themes
- **Dynamic Sizing**: Plots automatically adjust to accommodate your data

## 📦 Installation

### For jamovi Users

1. Open jamovi
2. Go to **Modules** → **jamovi library**
3. Search for "jjstatsplot"
4. Click **Install**

### For R Users

```r
# Install from GitHub (latest development version)
if (!require(devtools)) install.packages("devtools")
devtools::install_github("sbalci/jjstatsplot")

# Load the package
library(jjstatsplot)
```

## 🏃 Quick Start

### In jamovi

1. Open your dataset in jamovi
2. Navigate to the **Analyses** tab
3. Find **jjstatsplot** in the analysis menu
4. Select your desired analysis type
5. Drag and drop variables to the appropriate fields
6. Customize options as needed

### In R

```r
# Example: Create a histogram with statistical annotations
jjhistostats(
  data = iris,
  dep = "Sepal.Length",
  xlab = "Sepal Length (cm)",
  results.subtitle = TRUE
)

# Example: Compare groups with box-violin plots
jjbetweenstats(
  data = mtcars,
  dep = "mpg",
  group = "cyl",
  type = "nonparametric"
)
```

## 🔧 Development

### Requirements

- R (≥ 4.0.0)
- jamovi (≥ 1.2.19)
- Core dependencies: `jmvcore`, `R6`, `ggstatsplot`

### Building from Source

```r
# Clone the repository
git clone https://github.com/sbalci/jjstatsplot.git

# Install development dependencies
devtools::install_deps()

# Check package
devtools::check()

# Build jamovi module
jmvtools::install()
```

## 📚 Documentation

- **Package Documentation**: [sbalci.github.io/jjstatsplot](https://sbalci.github.io/jjstatsplot/)
- **ggstatsplot Guide**: [indrajeetpatil.github.io/ggstatsplot](https://indrajeetpatil.github.io/ggstatsplot/)
- **jamovi Resources**: [jamovi.org](https://www.jamovi.org)
- **Video Tutorials**: [YouTube Channel](https://www.youtube.com/channel/UC7Y8gp8PrBsc48yKVkZGVIg)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Reporting Issues

- **Bug Reports**: [GitHub Issues](https://github.com/sbalci/jjstatsplot/issues)
- **Feature Requests**: [GitHub Discussions](https://github.com/sbalci/jjstatsplot/discussions)
- **General Questions**: <serdarbalci@serdarbalci.com>

## 📄 Citation

If you use jjstatsplot in your research, please cite:

```bibtex
@software{jjstatsplot,
  author = {Serdar Balci},
  title = {jjstatsplot: Statistical Visualizations for jamovi},
  url = {https://github.com/sbalci/jjstatsplot},
  version = {0.0.31.58},
  year = {2025}
}
```

Please also cite the underlying packages:

- **ggstatsplot**: Patil, I. (2021). Visualizations with statistical details: The 'ggstatsplot' approach. *Journal of Open Source Software*, 6(61), 3167.
- **jamovi**: The jamovi project (2024). jamovi (Version 2.5) [Computer Software]. Retrieved from <https://www.jamovi.org>

## 📝 License

This project is licensed under the GPL (≥ 2) License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Indrajeet Patil](https://github.com/IndrajeetPatil) for creating ggstatsplot
- The [jamovi team](https://www.jamovi.org/about.html) for their excellent statistical platform
- All contributors and users who have helped improve this package

---

<p align="center">
Made with ❤️ for the jamovi community
</p>
