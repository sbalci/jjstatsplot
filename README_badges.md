# README Badges and Widgets for jjstatsplot

## Status Badges

### jamovi Module Badges
```markdown
[![jamovi](https://img.shields.io/badge/jamovi-module-blue)](https://www.jamovi.org)
[![jamovi-version](https://img.shields.io/badge/jamovi-%E2%89%A5%201.2.19-blue)](https://www.jamovi.org)
[![ggstatsplot-wrapper](https://img.shields.io/badge/ggstatsplot-wrapper-orange)](https://indrajeetpatil.github.io/ggstatsplot/)
```

### Package Status
```markdown
[![R-CMD-check](https://github.com/sbalci/jjstatsplot/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/sbalci/jjstatsplot/actions/workflows/R-CMD-check.yaml)
[![CRAN status](https://www.r-pkg.org/badges/version/jjstatsplot)](https://CRAN.R-project.org/package=jjstatsplot)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: GPL (>= 2)](https://img.shields.io/badge/license-GPL%20(%3E=%202)-blue.svg)](https://www.gnu.org/licenses/gpl-2.0.html)
```

### Usage & Downloads
```markdown
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/sbalci/jjstatsplot)](https://github.com/sbalci/jjstatsplot/releases)
[![GitHub all releases](https://img.shields.io/github/downloads/sbalci/jjstatsplot/total)](https://github.com/sbalci/jjstatsplot/releases)
[![GitHub last commit](https://img.shields.io/github/last-commit/sbalci/jjstatsplot)](https://github.com/sbalci/jjstatsplot/commits/master)
```

### Code Quality
```markdown
[![Code size](https://img.shields.io/github/languages/code-size/sbalci/jjstatsplot)](https://github.com/sbalci/jjstatsplot)
[![R](https://img.shields.io/badge/R-%E2%89%A5%204.0.0-blue)](https://www.r-project.org/)
[![Dependencies](https://img.shields.io/badge/dependencies-ggstatsplot%20%7C%20jmvcore-green)](https://github.com/sbalci/jjstatsplot/blob/master/DESCRIPTION)
```

## Feature Highlights

### Analysis Types Widget
```markdown
## 📊 Available Analyses

| Category | Analysis | ggstatsplot Function |
|----------|----------|---------------------|
| 📈 **Continuous** | Histogram | `gghistostats` |
| 🔗 **Continuous vs Continuous** | Scatter Plot | `ggscatterstats` |
| 🔗 **Continuous vs Continuous** | Correlation Matrix | `ggcorrmat` |
| 📊 **Categorical vs Continuous** | Box-Violin Plots (Between) | `ggbetweenstats` |
| 📊 **Categorical vs Continuous** | Dot Charts | `ggdotplotstats` |
| 📊 **Categorical vs Continuous** | Box-Violin Plots (Within) | `ggwithinstats` |
| 🍰 **Categorical vs Categorical** | Bar Charts | `ggbarstats` |
| 🍰 **Categorical vs Categorical** | Pie Charts | `ggpiestats` |
| 🧇 **Distribution** | Waffle Charts | Custom implementation |
```

### Quick Start Widget
```markdown
## 🚀 Quick Start

### For jamovi Users
1. **Install**: Download from [jamovi library](https://library.jamovi.org/) 
2. **Load**: Open jamovi → Modules → jjstatsplot
3. **Analyze**: Select your analysis from the `JJStatsPlot` menu

### For R Users
```r
# Install from GitHub
devtools::install_github("sbalci/jjstatsplot")

# Load package
library(jjstatsplot)

# Use functions directly
jjhistostats(data = mydata, dep = "variable")
```
```

### Installation Widget
```markdown
## 💾 Installation

### jamovi Installation
```markdown
1. Open jamovi
2. Go to Modules (⊞) in the top menu
3. Select "jamovi library" 
4. Search for "jjstatsplot"
5. Click Install
```

### R Installation
```r
# From GitHub (latest development version)
if (!require(devtools)) install.packages("devtools")
devtools::install_github("sbalci/jjstatsplot")

# From CRAN (stable version - when available)
install.packages("jjstatsplot")
```
```

### Key Features Widget
```markdown
## ✨ Key Features

- 🎯 **Point-and-click interface** in jamovi
- 📊 **9 statistical plot types** with automatic statistics
- 🔧 **Dual-mode operation**: Single variables or grouped analyses
- 🎨 **Flexible theming**: jamovi or ggstatsplot themes
- 📈 **Statistical annotations**: Automatic significance testing
- 🔄 **Grouped plotting**: Multiple dependent variables support
- 📋 **Rich customization**: Extensive options through jamovi UI
- 🔗 **R integration**: Use functions directly in R scripts
```

## Support & Documentation

### Links Widget
```markdown
## 📚 Resources

| Resource | Link |
|----------|------|
| 📖 **Documentation** | [Package docs](https://sbalci.github.io/jjstatsplot/) |
| 🎓 **ggstatsplot Guide** | [ggstatsplot docs](https://indrajeetpatil.github.io/ggstatsplot/) |
| 🏠 **jamovi** | [jamovi.org](https://www.jamovi.org) |
| 🐛 **Issues** | [Report bugs](https://github.com/sbalci/ClinicoPathJamoviModule/issues/) |
| 💬 **Discussions** | [GitHub Discussions](https://github.com/sbalci/jjstatsplot/discussions) |
| 📧 **Contact** | drserdarbalci@gmail.com |
```

### Citation Widget
```markdown
## 📝 Citation

If you use jjstatsplot in your research, please cite:

```bibtex
@software{jjstatsplot,
  author = {Serdar Balci},
  title = {jjstatsplot: Wrapper for ggstatsplot in jamovi},
  url = {https://github.com/sbalci/jjstatsplot},
  version = {0.0.3.21},
  year = {2024}
}
```

**Also cite the underlying packages:**
- [ggstatsplot](https://indrajeetpatil.github.io/ggstatsplot/): Patil, I. (2021). Visualizations with statistical details: The 'ggstatsplot' approach. Journal of Open Source Software, 6(61), 3167.
- [jamovi](https://www.jamovi.org): The jamovi project (2022). jamovi (Version 2.3) [Computer Software].
```

## Complete README Template

### Suggested README structure using these widgets:
```markdown
# jjstatsplot

[Status badges section]

[Quick description]

[Feature highlights table]

## Installation
[Installation widget]

## Quick Start  
[Quick start widget]

## Key Features
[Key features widget]

## Documentation
[Links widget]

## Citation
[Citation widget]
```