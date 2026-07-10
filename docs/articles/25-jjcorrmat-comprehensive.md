# jjcorrmat: Comprehensive Correlation Matrix Analysis

## Overview

The `jjcorrmat` function provides a comprehensive interface for creating
correlation matrices with advanced statistical analysis capabilities.
This function is a wrapper around
[`ggstatsplot::ggcorrmat`](https://www.indrapatil.com/ggstatsplot/reference/ggcorrmat.html)
and
[`ggstatsplot::grouped_ggcorrmat`](https://www.indrapatil.com/ggstatsplot/reference/grouped_ggcorrmat.html),
offering both single and grouped correlation matrix visualizations.

## Key Features

- **Multiple correlation methods**: Parametric (Pearson), nonparametric
  (Spearman), robust, and Bayesian
- **Grouped analysis**: Create separate correlation matrices for
  different groups
- **Performance optimized**: Uses internal caching to eliminate
  redundant computations
- **Comprehensive visualization**: High-quality correlation plots with
  statistical annotations

## Installation and Setup

``` r

# Install ClinicoPath if not already installed
library(jjstatsplot)

library(jjstatsplot)
library(ggplot2)
```

## Quick Start

### Basic Correlation Matrix

``` r

# Load test data
data(jjcorrmat_test_data)

# Basic correlation matrix
result <- jjcorrmat(
  data = jjcorrmat_test_data,
  dep = c("ki67_percent", "p53_score", "her2_intensity", "tumor_size_mm"),
  typestatistics = "parametric"
)

# View the plot
result$plot
```

### Grouped Correlation Matrix

``` r

# Grouped correlation matrix by tumor grade
result_grouped <- jjcorrmat(
  data = jjcorrmat_test_data,
  dep = c("ki67_percent", "p53_score", "her2_intensity"),
  grvar = "tumor_grade",
  typestatistics = "nonparametric"
)

# View the grouped plot
result_grouped$plot2
```

## Function Parameters

### Core Parameters

- **`data`**: Input data frame containing the variables to analyze
- **`dep`**: List of continuous variables for correlation analysis (must
  be numeric)
- **`grvar`**: Optional grouping variable for creating separate
  correlation matrices
- **`typestatistics`**: Type of correlation analysis to perform

### Statistical Methods

The `typestatistics` parameter supports four different approaches:

1.  **“parametric”** (default): Pearson product-moment correlation
    - Assumes normal distribution
    - Best for linear relationships
    - Most commonly used
2.  **“nonparametric”**: Spearman’s rank correlation
    - Distribution-free method
    - Robust to outliers
    - Captures monotonic relationships
3.  **“robust”**: Percentage bend correlation
    - Robust to outliers and non-normality
    - Good compromise between parametric and nonparametric
    - Uses WRS2::pbcor()
4.  **“bayes”**: Bayesian correlation analysis
    - Provides Bayes factors for evidence assessment
    - Incorporates prior beliefs
    - Gives probabilistic interpretation

## Performance Optimizations

### Version History

The function has been significantly optimized for performance:

**Previous Issues:** - Redundant data processing in `.plot()` and
`.plot2()` methods - Unused caching infrastructure - Repeated formula
construction and variable processing

**Current Optimizations:** - **Data Caching**: Uses `.prepareData()`
method to cache processed data - **Options Caching**: Uses
`.prepareOptions()` method to cache formula processing - **Eliminated
Redundancy**: Both plot methods now use cached results - **Better
Progress Feedback**: Clear user messaging during processing

### Performance Benefits

``` r

# Performance comparison (conceptual)
# Before optimization: 
# - Data processed twice (once for each plot)
# - Formula construction repeated
# - Variable processing duplicated

# After optimization:
# - Data processed once and cached
# - Formula construction done once
# - Significant speedup for large datasets
```

## Advanced Usage Examples

### Multiple Statistical Methods

``` r

# Compare different correlation methods
methods <- c("parametric", "nonparametric", "robust", "bayes")
variables <- c("ki67_percent", "p53_score", "her2_intensity")

results <- list()
for (method in methods) {
  results[[method]] <- jjcorrmat(
    data = jjcorrmat_test_data,
    dep = variables,
    typestatistics = method
  )
}

# Each result contains the correlation matrix plot
# results$parametric$plot
# results$nonparametric$plot
# etc.
```

### Clinical Research Example

``` r

# Analyze biomarker correlations in breast cancer data
biomarkers <- c("ki67_percent", "p53_score", "her2_intensity", "tumor_size_mm", "age_years")

# Overall correlation matrix
overall_corr <- jjcorrmat(
  data = jjcorrmat_test_data,
  dep = biomarkers,
  typestatistics = "parametric"
)

# Stratified by hormone receptor status
stratified_corr <- jjcorrmat(
  data = jjcorrmat_test_data,
  dep = biomarkers,
  grvar = "hormone_status",
  typestatistics = "parametric"
)

# Compare correlations across tumor grades
grade_corr <- jjcorrmat(
  data = jjcorrmat_test_data,
  dep = biomarkers[1:4],  # Exclude age for clarity
  grvar = "tumor_grade",
  typestatistics = "spearman"
)
```

## Data Requirements

### Input Data Structure

The input data should be a data frame with:

- **Continuous variables**: Numeric columns for correlation analysis
- **Grouping variables**: Factor or character columns for stratified
  analysis
- **Complete cases**: Missing values are automatically excluded

### Example Data Structure

``` r

# Structure of test data
str(jjcorrmat_test_data)

# Key variables:
# - ki67_percent: Numeric (0-100)
# - p53_score: Numeric (0-50)
# - her2_intensity: Numeric (0-30)
# - tumor_size_mm: Numeric (5-50)
# - age_years: Numeric (18-90)
# - tumor_grade: Factor (Grade 1/2/3)
# - hormone_status: Factor (ER+/PR+, etc.)
```

## Best Practices

### Variable Selection

1.  **Choose appropriate variables**: Select variables that
    theoretically should be correlated
2.  **Check distributions**: Consider log transformation for skewed
    variables
3.  **Handle missing data**: Decide on complete case analysis
    vs. imputation
4.  **Sample size**: Ensure adequate sample size for stable correlations

### Statistical Method Selection

- **Use parametric** when variables are approximately normal
- **Use nonparametric** for ordinal data or non-normal distributions
- **Use robust** when there are outliers but you want parametric-like
  interpretation
- **Use Bayesian** when you want to quantify evidence for/against
  correlations

### Interpretation Guidelines

- **Correlation strength**:
  - 0.00-0.30: Weak
  - 0.30-0.70: Moderate  
  - 0.70-1.00: Strong
- **Statistical significance**: Consider both p-values and effect sizes
- **Clinical significance**: Strong statistical correlation may not be
  clinically meaningful

## Troubleshooting

### Common Issues

1.  **“Data contains no (complete) rows”**
    - Check for missing values in your variables
    - Ensure at least some complete cases exist
2.  **No plot generated**
    - Verify that you have at least 2 continuous variables
    - Check that variables are properly formatted as numeric
3.  **Slow performance**
    - The optimized version should be much faster
    - For very large datasets, consider sampling

### Error Messages

``` r

# Example error handling
tryCatch({
  result <- jjcorrmat(
    data = my_data,
    dep = c("var1", "var2"),
    typestatistics = "parametric"
  )
}, error = function(e) {
  message("Error in correlation analysis: ", e$message)
  message("Check your data structure and variable types")
})
```

## Technical Details

### Underlying Functions

The `jjcorrmat` function is built on:

- **ggstatsplot::ggcorrmat**: For single correlation matrices
- **ggstatsplot::grouped_ggcorrmat**: For grouped analyses
- **jmvcore**: For data handling and formula processing

### Caching Implementation

``` r

# Internal caching structure (conceptual)
# private$.processedData: Cached cleaned data
# private$.processedOptions: Cached formula and variable processing
# 
# Benefits:
# - Eliminates redundant jmvcore::naOmit() calls
# - Avoids repeated formula construction
# - Shares processed data between plot methods
```

## Conclusion

The optimized `jjcorrmat` function provides:

- **High performance**: Significant speed improvements through caching
- **Flexibility**: Multiple statistical methods and grouping options
- **Reliability**: Comprehensive error handling and validation
- **Usability**: Clear documentation and examples

The function is well-suited for clinical research, biomarker analysis,
and any scenario requiring robust correlation matrix visualization.

## Session Information

``` r

sessionInfo()
```

    ## R version 4.6.0 (2026-04-24)
    ## Platform: aarch64-apple-darwin23
    ## Running under: macOS Tahoe 26.5.1
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.6/Resources/lib/libRblas.0.dylib 
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.6/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.1
    ## 
    ## locale:
    ## [1] C.UTF-8/C.UTF-8/C.UTF-8/C/C.UTF-8/C.UTF-8
    ## 
    ## time zone: Europe/Istanbul
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] digest_0.6.39     desc_1.4.3        R6_2.6.1          fastmap_1.2.0    
    ##  [5] xfun_0.59         cachem_1.1.0      knitr_1.51        htmltools_0.5.9  
    ##  [9] rmarkdown_2.31    lifecycle_1.0.5   cli_3.6.6         sass_0.4.10      
    ## [13] pkgdown_2.2.0     textshaping_1.0.5 jquerylib_0.1.4   systemfonts_1.3.2
    ## [17] compiler_4.6.0    tools_4.6.0       ragg_1.5.2        bslib_0.11.0     
    ## [21] evaluate_1.0.5    yaml_2.3.12       otel_0.2.0        jsonlite_2.0.0   
    ## [25] rlang_1.3.0       fs_2.1.0          htmlwidgets_1.6.4
