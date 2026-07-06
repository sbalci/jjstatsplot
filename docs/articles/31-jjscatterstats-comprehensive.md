# 

—: "jjscatterstats: Comprehensive Scatter Plot Analysis": "ClinicoPath":
"2026-07-06": html: \>%\VignetteIndexEntry{jjscatterstats: Comprehensive
Scatter Plot
Analysis}%\VignetteEngine{quarto::html}%\VignetteEncoding{UTF-8}—`{r, include = FALSE}\nknitr::opts_chunk$set(\n collapse = TRUE,\n comment = \"#>\",\n fig.width = 8,\n fig.height = 6,\n warning = FALSE,\n message = FALSE\n)\n`\#
Introduction to jjscatterstats`jjscatterstats` function is a powerful
wrapper around
[`ggstatsplot::ggscatterstats()`](https://www.indrapatil.com/ggstatsplot/reference/ggscatterstats.html)
and
[`ggstatsplot::grouped_ggscatterstats()`](https://www.indrapatil.com/ggstatsplot/reference/grouped_ggscatterstats.html)
that provides comprehensive scatter plot analysis with statistical
testing capabilities. This function is particularly useful for exploring
relationships between continuous variables in clinical and research
settings.## Key Features- **Statistical Analysis**: Automatic
correlation analysis with multiple statistical approaches- **Flexible
Grouping**: Support for grouped analysis across categorical variables-
**Multiple Statistical Types**: Parametric, non-parametric, robust, and
Bayesian statistics- **Customizable Visualization**: Extensive theming
and labeling options- **Performance Optimized**: Enhanced caching and
data preparation for faster rendering## Loading Required
Libraries`{r setup}\nlibrary(jjstatsplot)\nlibrary(ggplot2)\nlibrary(dplyr)\n\n# Load example datasets\ndata(iris)\ndata(mtcars)\n`\#
Basic Scatter Plot Analysis## Simple Correlation Analysis’s start with a
basic scatter plot analyzing the relationship between sepal length and
petal length in the iris
dataset:`{r basic-example}\n# Basic scatter plot with parametric correlation\nresult_basic <- jjscatterstats(\n data = iris,\n dep = \"Sepal.Length\",\n group = \"Petal.Length\",\n typestatistics = \"parametric\",\n mytitle = \"Sepal Length vs Petal Length\",\n xtitle = \"Sepal Length (cm)\",\n ytitle = \"Petal Length (cm)\"\n)\n\nprint(result_basic)\n`\##
Different Statistical Approaches### Non-parametric
Analysis`{r nonparametric}\n# Non-parametric correlation (Spearman's rho)\nresult_nonparam <- jjscatterstats(\n data = iris,\n dep = \"Sepal.Length\",\n group = \"Petal.Width\",\n typestatistics = \"nonparametric\",\n mytitle = \"Non-parametric Correlation Analysis\"\n)\n\nprint(result_nonparam)\n`\###
Robust
Statistics`{r robust}\n# Robust correlation analysis\nresult_robust <- jjscatterstats(\n data = iris,\n dep = \"Sepal.Width\",\n group = \"Petal.Length\",\n typestatistics = \"robust\",\n mytitle = \"Robust Correlation Analysis\"\n)\n\nprint(result_robust)\n`\###
Bayesian
Analysis`{r bayesian}\n# Bayesian correlation analysis\nresult_bayes <- jjscatterstats(\n data = iris,\n dep = \"Sepal.Length\",\n group = \"Sepal.Width\",\n typestatistics = \"bayes\",\n mytitle = \"Bayesian Correlation Analysis\"\n)\n\nprint(result_bayes)\n`\#
Grouped Analysis## Scatter Plot by Speciesof the most powerful features
is the ability to create grouped scatter
plots:`{r grouped-analysis}\n# Grouped scatter plot by species\nresult_grouped <- jjscatterstats(\n data = iris,\n dep = \"Sepal.Length\",\n group = \"Petal.Length\",\n grvar = \"Species\",\n typestatistics = \"parametric\",\n mytitle = \"Correlation Analysis by Species\"\n)\n\nprint(result_grouped)\n`\##
Multiple Group Analysis with
mtcars`{r mtcars-grouped}\n# Prepare mtcars data\nmtcars_modified <- mtcars %>%\n mutate(\n transmission = factor(am, levels = c(0, 1), labels = c(\"Automatic\", \"Manual\")),\n cylinders = factor(cyl)\n )\n\n# Grouped analysis of mpg vs horsepower by transmission type\nresult_mtcars <- jjscatterstats(\n data = mtcars_modified,\n dep = \"hp\",\n group = \"mpg\",\n grvar = \"transmission\",\n typestatistics = \"parametric\",\n mytitle = \"MPG vs Horsepower by Transmission Type\",\n xtitle = \"Horsepower\",\n ytitle = \"Miles per Gallon\"\n)\n\nprint(result_mtcars)\n`\#
Clinical Research Applications## Using Clinical Test
Data`{r clinical-example, eval=FALSE}\n# Example with clinical data (if available)\n# This demonstrates typical clinical research scenarios\n\n# Load clinical test data\ndata(jjscatterstats_clinical)\n\n# Analyze tumor size vs Ki67 percentage\nclinical_result <- jjscatterstats(\n data = jjscatterstats_clinical,\n dep = \"tumor_size_mm\",\n group = \"ki67_percentage\",\n grvar = \"stage\",\n typestatistics = \"parametric\",\n mytitle = \"Tumor Size vs Ki67 by Cancer Stage\",\n xtitle = \"Tumor Size (mm)\",\n ytitle = \"Ki67 Percentage (%)\"\n)\n\nprint(clinical_result)\n`\##
Biomarker Correlation
Analysis`{r biomarker-example, eval=FALSE}\n# Biomarker correlation analysis\nbiomarker_result <- jjscatterstats(\n data = jjscatterstats_clinical,\n dep = \"mutation_count\",\n group = \"survival_months\",\n grvar = \"histology\",\n typestatistics = \"nonparametric\",\n mytitle = \"Mutation Count vs Survival by Histology\",\n xtitle = \"Mutation Count\",\n ytitle = \"Survival (months)\"\n)\n\nprint(biomarker_result)\n`\#
Advanced Customization## Theme
Customization`{r theme-custom}\n# Using original ggstatsplot theme\nresult_original_theme <- jjscatterstats(\n data = iris,\n dep = \"Sepal.Length\",\n group = \"Petal.Length\",\n originaltheme = TRUE,\n mytitle = \"Original ggstatsplot Theme\"\n)\n\nprint(result_original_theme)\n`\##
Custom Labels and
Titles`{r custom-labels}\n# Comprehensive labeling\nresult_labeled <- jjscatterstats(\n data = mtcars,\n dep = \"wt\",\n group = \"mpg\",\n typestatistics = \"parametric\",\n mytitle = \"Vehicle Weight vs Fuel Efficiency\",\n xtitle = \"Weight (1000 lbs)\",\n ytitle = \"Miles per Gallon\",\n resultssubtitle = TRUE\n)\n\nprint(result_labeled)\n`\##
Controlling Statistical Results
Display`{r results-control}\n# Hide statistical results subtitle\nresult_no_stats <- jjscatterstats(\n data = iris,\n dep = \"Sepal.Width\",\n group = \"Petal.Width\",\n typestatistics = \"parametric\",\n mytitle = \"Clean Plot Without Statistics\",\n resultssubtitle = FALSE\n)\n\nprint(result_no_stats)\n`\#
Performance Considerations## Large Dataset Handlingfunction includes
several performance
optimizations:`{r performance-demo, eval=FALSE}\n# Performance test with larger dataset\ndata(jjscatterstats_performance)\n\n# This should render efficiently due to optimizations\nstart_time <- Sys.time()\nperformance_result <- jjscatterstats(\n data = jjscatterstats_performance,\n dep = \"measurement_1\",\n group = \"measurement_2\",\n grvar = \"lab_id\",\n typestatistics = \"parametric\",\n mytitle = \"Performance Test - Large Dataset\"\n)\nend_time <- Sys.time()\n\ncat(\"Rendering time:\", difftime(end_time, start_time, units = \"secs\"), \"seconds\\n\")\nprint(performance_result)\n`\##
Data Caching and Optimizationfunction implements several performance
enhancements:. **Data Preparation Caching**: Processed data is cached to
avoid recomputation. **Option Preprocessing**: Common option processing
is done once and cached. **Hash-based Change Detection**: Only
reprocesses data when inputs change. **Efficient Memory Usage**:
Minimizes data copying and transformation overhead# Edge Cases and Data
Validation## Handling Missing
Values`{r missing-values}\n# Create data with missing values\niris_with_na <- iris\niris_with_na[1:10, \"Sepal.Length\"] <- NA\niris_with_na[15:20, \"Petal.Length\"] <- NA\n\n# Function automatically handles missing values\nresult_na <- jjscatterstats(\n data = iris_with_na,\n dep = \"Sepal.Length\",\n group = \"Petal.Length\",\n typestatistics = \"parametric\",\n mytitle = \"Handling Missing Values\"\n)\n\nprint(result_na)\n`\##
Input
Validation`{r validation-demo, error=TRUE}\n# Example of error handling\ntry({\n result_error <- jjscatterstats(\n data = data.frame(), # Empty dataset\n dep = \"nonexistent\",\n group = \"variable\",\n typestatistics = \"parametric\"\n )\n})\n`\#
Best Practices and Recommendations## Statistical Type Selection-
**Parametric**: Use when data is normally distributed (Pearson
correlation)- **Non-parametric**: Use for non-normal data or ordinal
variables (Spearman correlation)- **Robust**: Use when data has outliers
(percentage bend correlation)- **Bayesian**: Use for incorporating prior
knowledge or uncertainty quantification## Visualization Guidelines.
**Choose appropriate variables**: Both x and y should be continuous.
**Consider grouping**: Use grouping variables to reveal subgroup
patterns. **Label clearly**: Always provide meaningful titles and axis
labels. **Statistical reporting**: Include statistical results unless
specifically hiding them## Performance Tips. **Large datasets**: The
function is optimized for datasets up to several thousand rows.
**Multiple analyses**: Reuse data objects when possible to benefit from
caching. **Grouping variables**: Limit grouping variables to reasonable
numbers of levels (\< 10)# Troubleshooting Common Issues## Variable Type
Issues`{r variable-types}\n# Ensure variables are numeric\nstr(iris[c(\"Sepal.Length\", \"Petal.Length\")])\n\n# The function automatically converts to numeric, but it's good practice to check\n`\##
Memory and
Performance`{r memory-tips, eval=FALSE}\n# For very large datasets, consider:\n# 1. Sampling your data first\nset.seed(123)\nsampled_data <- iris[sample(nrow(iris), 100), ]\n\nresult_sampled <- jjscatterstats(\n data = sampled_data,\n dep = \"Sepal.Length\",\n group = \"Petal.Length\",\n typestatistics = \"parametric\"\n)\n\n# 2. Using simpler statistical methods for initial exploration\nresult_simple <- jjscatterstats(\n data = iris,\n dep = \"Sepal.Length\",\n group = \"Petal.Length\",\n typestatistics = \"parametric\",\n resultssubtitle = FALSE # Faster rendering\n)\n`\#
Summary`jjscatterstats` function provides a comprehensive solution for
scatter plot analysis with:- Multiple statistical testing approaches-
Flexible grouping capabilities- Performance optimizations for larger
datasets- Extensive customization options- Robust error handling and
validationmakes it an excellent choice for exploratory data analysis,
clinical research, and statistical reporting in the jamovi
environment.## Function Referencecomplete parameter documentation, see:-
[ggstatsplot::ggscatterstats](https://indrajeetpatil.github.io/ggstatsplot/reference/ggscatterstats.html)-
[ggstatsplot::grouped_ggscatterstats](https://indrajeetpatil.github.io/ggstatsplot/reference/grouped_ggscatterstats.html)`{r session-info}\n# Session information\nsessionInfo()\n`
