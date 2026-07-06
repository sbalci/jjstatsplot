# Advanced Bar Charts - 7 Professional Approaches

## Overview

The `advancedbarplot` module provides **7 distinct professional
approaches** to bar chart visualization, each optimized for different
use cases in clinical research, data presentation, and publication. This
comprehensive guide demonstrates all approaches with the histopathology
dataset.

### Key Features

- **7 Chart Approaches**: From basic exploration to publication-ready
  designs
- **Professional Styling**: BBC News and GraphPad Prism authentic themes
- **Statistical Integration**: Built-in statistical tests and
  annotations
- **26+ Color Palettes**: Including BBC colors and Prism palettes
- **Interactive Options**: Plotly integration for web-based exploration
- **Export Optimization**: Publication and presentation-ready outputs

## Dataset Overview

We’ll use the comprehensive `histopathology` dataset throughout this
guide:

``` r

# Load the histopathology dataset
data("histopathology")

# Dataset structure
str(histopathology)
#> spc_tbl_ [250 × 38] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>  $ ID                  : num [1:250] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ Name                : chr [1:250] "Tonisia" "Daniyah" "Naviana" "Daerion" ...
#>  $ Sex                 : chr [1:250] "Male" "Female" "Male" "Male" ...
#>  $ Age                 : num [1:250] 27 36 65 51 58 53 33 26 25 68 ...
#>  $ Race                : chr [1:250] "White" "White" "White" "White" ...
#>  $ PreinvasiveComponent: chr [1:250] "Present" "Absent" "Absent" "Absent" ...
#>  $ LVI                 : chr [1:250] "Present" "Absent" "Absent" "Present" ...
#>  $ PNI                 : chr [1:250] "Absent" "Absent" "Absent" "Absent" ...
#>  $ LastFollowUpDate    : chr [1:250] "2019.10.22 00:00:00" "2019.06.22 00:00:00" "2019.08.22 00:00:00" "2019.03.22 00:00:00" ...
#>  $ Death               : chr [1:250] "YANLIŞ" "DOĞRU" "DOĞRU" "YANLIŞ" ...
#>  $ Group               : chr [1:250] "Control" "Treatment" "Control" "Treatment" ...
#>  $ Grade               : num [1:250] 2 2 1 3 2 2 1 2 3 3 ...
#>  $ TStage              : num [1:250] 4 4 4 4 1 4 2 3 4 4 ...
#>  $ Anti-X-intensity    : num [1:250] 3 2 2 3 3 3 2 2 1 2 ...
#>  $ Anti-Y-intensity    : num [1:250] 1 1 2 3 3 2 2 2 1 3 ...
#>  $ LymphNodeMetastasis : chr [1:250] "Present" "Absent" "Absent" "Absent" ...
#>  $ Valid               : chr [1:250] "YANLIŞ" "DOĞRU" "YANLIŞ" "DOĞRU" ...
#>  $ Smoker              : chr [1:250] "YANLIŞ" "YANLIŞ" "DOĞRU" "YANLIŞ" ...
#>  $ Grade_Level         : chr [1:250] "high" "low" "low" "high" ...
#>  $ SurgeryDate         : chr [1:250] "2019.07.08 00:00:00" "2019.03.18 00:00:00" "2019.05.18 00:00:00" "2018.10.24 00:00:00" ...
#>  $ DeathTime           : chr [1:250] "Within1Year" "Within1Year" "Within1Year" "Within1Year" ...
#>  $ int                 : chr [1:250] "2019-07-08 UTC--2019-10-22 UTC" "2019-03-18 UTC--2019-06-22 UTC" "2019-05-18 UTC--2019-08-22 UTC" "2018-10-24 UTC--2019-03-22 UTC" ...
#>  $ OverallTime         : num [1:250] 3.5 3.1 3.1 4.9 3.3 9.3 6.3 9 5.8 9.9 ...
#>  $ Outcome             : num [1:250] 0 1 1 0 0 0 1 1 1 0 ...
#>  $ Mortality5yr        : chr [1:250] "Alive" "Dead" "Dead" "Alive" ...
#>  $ Rater 1             : num [1:250] 0 1 1 0 0 0 1 1 1 0 ...
#>  $ Rater 2             : num [1:250] 0 0 0 0 0 0 0 0 0 0 ...
#>  $ Rater 3             : num [1:250] 1 1 1 0 1 1 1 1 1 1 ...
#>  $ Rater A             : num [1:250] 3 2 3 3 2 3 1 1 2 1 ...
#>  $ Rater B             : num [1:250] 3 2 3 3 2 3 1 1 2 1 ...
#>  $ New Test            : num [1:250] 0 0 0 0 0 0 1 0 0 0 ...
#>  $ Golden Standart     : num [1:250] 0 0 0 0 0 0 0 0 0 0 ...
#>  $ MeasurementA        : num [1:250] -1.63432 0.37071 0.01585 -1.23584 -0.00141 ...
#>  $ MeasurementB        : num [1:250] 0.611 0.554 0.742 0.622 0.527 ...
#>  $ Disease Status      : chr [1:250] "Ill" "Ill" "Healthy" "Ill" ...
#>  $ Measurement1        : num [1:250] 0.387 0.829 0.159 2.447 0.847 ...
#>  $ Measurement2        : num [1:250] 1.8654 0.5425 0.0701 2.4071 0.5564 ...
#>  $ Outcome2            : chr [1:250] "DOD" "DOOC" "AWD" "AWOD" ...
#>  - attr(*, "spec")=List of 3
#>   ..$ cols   :List of 38
#>   .. ..$ ID                  : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Name                : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ Sex                 : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ Age                 : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Race                : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ PreinvasiveComponent: list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ LVI                 : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ PNI                 : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ LastFollowUpDate    : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ Death               : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ Group               : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ Grade               : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ TStage              : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Anti-X-intensity    : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Anti-Y-intensity    : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ LymphNodeMetastasis : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ Valid               : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ Smoker              : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ Grade_Level         : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ SurgeryDate         : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ DeathTime           : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ int                 : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ OverallTime         : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Outcome             : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Mortality5yr        : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ Rater 1             : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Rater 2             : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Rater 3             : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Rater A             : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Rater B             : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ New Test            : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Golden Standart     : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ MeasurementA        : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ MeasurementB        : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Disease Status      : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   .. ..$ Measurement1        : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Measurement2        : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_double" "collector"
#>   .. ..$ Outcome2            : list()
#>   .. .. ..- attr(*, "class")= chr [1:2] "collector_character" "collector"
#>   ..$ default: list()
#>   .. ..- attr(*, "class")= chr [1:2] "collector_guess" "collector"
#>   ..$ skip   : num 1
#>   ..- attr(*, "class")= chr "col_spec"

# Key variables for bar charts
cat("Categorical variables suitable for X-axis:\n")
#> Categorical variables suitable for X-axis:
cat("- Sex:", unique(histopathology$Sex), "\n")
#> - Sex: Male Female NA
cat("- Race:", unique(histopathology$Race), "\n") 
#> - Race: White Black Hispanic Bi-Racial Hawaiian NA Asian Native
cat("- Group:", unique(histopathology$Group), "\n")
#> - Group: Control Treatment NA
cat("- Grade_Level:", unique(histopathology$Grade_Level), "\n")
#> - Grade_Level: high low moderate NA

cat("\nNumeric variables suitable for Y-axis:\n")
#> 
#> Numeric variables suitable for Y-axis:
cat("- Age: range", range(histopathology$Age, na.rm = TRUE), "\n")
#> - Age: range 25 73
cat("- Grade: range", range(histopathology$Grade, na.rm = TRUE), "\n")
#> - Grade: range 1 3
cat("- OverallTime: range", range(histopathology$OverallTime, na.rm = TRUE), "\n")
#> - OverallTime: range 2.9 58.2
```

## Approach 1: Basic ggplot2

**Use Case**: Data exploration, quick analysis, educational purposes

**Strengths**: Fast rendering, straightforward implementation, highly
customizable

``` r

# Basic ggplot2 approach
advancedbarplot(
  data = histopathology,
  x_var = "Group",
  y_var = "Age", 
  chart_approach = "basic",
  stat_type = "mean",
  show_values = TRUE,
  plot_title = "Mean Age by Treatment Group",
  x_title = "Treatment Group",
  y_title = "Mean Age (years)"
)
```

### R Code Example for Basic Approach

``` r

# Reproducible R code for basic approach
library(ggplot2)
library(dplyr)

# Summarize data
summary_data <- histopathology %>%
  group_by(Group) %>%
  summarise(
    mean_age = mean(Age, na.rm = TRUE),
    se = sd(Age, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  )

# Create basic plot
basic_plot <- ggplot(summary_data, aes(x = Group, y = mean_age)) +
  geom_col(width = 0.8, alpha = 0.9) +
  geom_text(aes(label = round(mean_age, 1)), vjust = -0.5) +
  theme_minimal() +
  labs(
    title = "Mean Age by Treatment Group - Basic Approach",
    x = "Treatment Group",
    y = "Mean Age (years)"
  )

print(basic_plot)
```

## Approach 2: Polished Presentation

**Use Case**: Business presentations, stakeholder reports, dashboard
displays

**Strengths**: Professional appearance, enhanced readability,
presentation-ready

``` r

# Polished presentation approach
advancedbarplot(
  data = histopathology,
  x_var = "Grade_Level", 
  y_var = "OverallTime",
  fill_var = "Sex",
  chart_approach = "polished",
  stat_type = "mean",
  color_palette = "clinical",
  bar_position = "dodge",
  show_values = TRUE,
  value_format = "decimal1",
  plot_title = "Overall Survival Time by Grade and Sex",
  legend_position = "top"
)
```

### R Code Example for Polished Approach

``` r

# Polished presentation approach
summary_data_grouped <- histopathology %>%
  group_by(Grade_Level, Sex) %>%
  summarise(
    mean_time = mean(OverallTime, na.rm = TRUE),
    se = sd(OverallTime, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  )

# Clinical color palette
clinical_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728")

polished_plot <- ggplot(summary_data_grouped, aes(x = Grade_Level, y = mean_time, fill = Sex)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.8, alpha = 0.9) +
  geom_text(
    aes(label = sprintf("%.1f", mean_time)),
    position = position_dodge(width = 0.8),
    vjust = -0.5,
    size = 3.5
  ) +
  scale_fill_manual(values = clinical_colors) +
  theme_minimal() +
  theme(
    text = element_text(size = 12),
    plot.title = element_text(size = 14, face = "bold"),
    axis.text = element_text(size = 10),
    legend.position = "top"
  ) +
  labs(
    title = "Overall Survival Time by Grade and Sex - Polished Approach",
    x = "Grade Level",
    y = "Mean Overall Time (months)",
    fill = "Sex"
  )

print(polished_plot)
```

## Approach 3: Statistical Annotations

**Use Case**: Research publications, clinical studies, comparative
analysis

**Strengths**: Built-in statistics, automated annotations, hypothesis
testing

``` r

# Statistical annotations approach
advancedbarplot(
  data = histopathology,
  x_var = "Group",
  y_var = "Grade",
  chart_approach = "statistical", 
  stat_type = "mean",
  add_statistics = TRUE,
  stat_method = "ttest",
  error_bars = "se",
  show_values = TRUE,
  plot_title = "Mean Grade by Treatment Group with Statistical Test",
  color_palette = "nature"
)
```

### R Code Example for Statistical Approach

``` r

# Statistical approach with error bars
summary_stats <- histopathology %>%
  group_by(Group) %>%
  summarise(
    mean_grade = mean(Grade, na.rm = TRUE),
    se = sd(Grade, na.rm = TRUE) / sqrt(n()),
    sd = sd(Grade, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

# Perform t-test
control_data <- histopathology$Grade[histopathology$Group == "Control"]
treatment_data <- histopathology$Grade[histopathology$Group == "Treatment"]
t_result <- t.test(control_data, treatment_data)

statistical_plot <- ggplot(summary_stats, aes(x = Group, y = mean_grade)) +
  geom_col(width = 0.8, alpha = 0.9, fill = "steelblue") +
  geom_errorbar(
    aes(ymin = mean_grade - se, ymax = mean_grade + se),
    width = 0.2,
    position = position_dodge(width = 0.8)
  ) +
  geom_text(aes(label = sprintf("%.2f", mean_grade)), vjust = -1.5) +
  theme_minimal() +
  labs(
    title = paste0("Mean Grade by Treatment Group - Statistical Approach\n",
                   "t(", round(t_result$parameter, 1), ") = ", round(t_result$statistic, 3),
                   ", p = ", format.pval(t_result$p.value, digits = 3)),
    x = "Treatment Group", 
    y = "Mean Grade",
    caption = paste0("Error bars represent standard error\n",
                     "Mean difference: ", round(diff(t_result$estimate), 3))
  )

print(statistical_plot)
```

## Approach 4: Interactive Plotly

**Use Case**: Web applications, interactive reports, data exploration
tools

**Strengths**: Interactive exploration, hover information, zoom and pan
capabilities

``` r

# Interactive plotly approach
advancedbarplot(
  data = histopathology,
  x_var = "Race",
  y_var = "MeasurementA", 
  chart_approach = "interactive",
  stat_type = "median",
  color_palette = "viridis",
  plot_title = "Median Measurement A by Race - Interactive",
  show_values = TRUE
)
```

### R Code Example for Interactive Approach

``` r

library(plotly)

# Prepare data for interactive plot
race_summary <- histopathology %>%
  group_by(Race) %>%
  summarise(
    median_measurement = median(MeasurementA, na.rm = TRUE),
    mad = mad(MeasurementA, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

# Create ggplot
interactive_base <- ggplot(race_summary, aes(x = Race, y = median_measurement, fill = Race)) +
  geom_col(width = 0.8, alpha = 0.9) +
  geom_text(aes(label = sprintf("%.3f", median_measurement)), vjust = -0.5) +
  scale_fill_viridis_d() +
  theme_minimal() +
  theme(legend.position = "none") +
  labs(
    title = "Median Measurement A by Race - Interactive Approach",
    x = "Race",
    y = "Median Measurement A"
  )

# Convert to interactive plot
interactive_plot <- ggplotly(interactive_base, tooltip = c("x", "y"))

print(interactive_plot)
```

## Approach 5: Publication Ready

**Use Case**: Academic papers, journal submissions, conference
presentations

**Strengths**: Journal formatting standards, high-resolution export,
citation ready

``` r

# Publication ready approach
advancedbarplot(
  data = histopathology,
  x_var = "Sex",
  y_var = "MeasurementB",
  chart_approach = "publication",
  stat_type = "mean",
  error_bars = "ci95", 
  show_values = TRUE,
  value_format = "decimal2",
  plot_title = "Mean Measurement B by Sex",
  theme_style = "publication",
  export_options = TRUE
)
```

### R Code Example for Publication Approach

``` r

# Publication-ready approach
sex_summary <- histopathology %>%
  group_by(Sex) %>%
  summarise(
    mean_measurement = mean(MeasurementB, na.rm = TRUE),
    se = sd(MeasurementB, na.rm = TRUE) / sqrt(n()),
    ci95 = 1.96 * se,
    n = n(),
    .groups = "drop"
  )

publication_plot <- ggplot(sex_summary, aes(x = Sex, y = mean_measurement)) +
  geom_col(
    width = 0.8,
    alpha = 0.7,
    color = "black",
    size = 0.3,
    fill = "steelblue"
  ) +
  geom_errorbar(
    aes(ymin = mean_measurement - ci95, ymax = mean_measurement + ci95),
    width = 0.2
  ) +
  geom_text(
    aes(label = sprintf("%.2f", mean_measurement)),
    vjust = -1.5,
    size = 3
  ) +
  theme_classic() +
  theme(
    text = element_text(size = 11, family = "serif"),
    plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
    axis.text = element_text(size = 10, color = "black"),
    axis.title = element_text(size = 11, face = "bold"),
    panel.grid = element_blank(),
    axis.line = element_line(color = "black", size = 0.5)
  ) +
  labs(
    title = "Mean Measurement B by Sex",
    x = "Sex",
    y = "Mean Measurement B",
    caption = "Error bars represent 95% confidence intervals"
  )

print(publication_plot)
```

## Approach 6: BBC News Style

**Use Case**: News reports, journalism, public communications,
professional presentations

**Strengths**: BBC design standards, professional typography, brand
consistency

``` r

# BBC News style approach
advancedbarplot(
  data = histopathology,
  x_var = "Grade_Level",
  y_var = "Age",
  chart_approach = "bbc_style",
  stat_type = "mean",
  color_palette = "bbc_multi",
  show_values = TRUE,
  plot_title = "Age Distribution by Grade Level",
  subtitle_text = "BBC Visual and Data Journalism Style",
  source_text = "ClinicoPath Histopathology Dataset"
)
```

### R Code Example for BBC Style

``` r

# BBC News style approach
grade_age_summary <- histopathology %>%
  group_by(Grade_Level) %>%
  summarise(
    mean_age = mean(Age, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

# BBC color palette
bbc_colors <- c("#1380A1", "#FAAB18", "#007f7f", "#333333")

bbc_plot <- ggplot(grade_age_summary, aes(x = Grade_Level, y = mean_age, fill = Grade_Level)) +
  geom_col(width = 0.8, alpha = 1.0) +
  scale_fill_manual(values = bbc_colors) +
  theme(
    # Text elements
    text = element_text(family = "Arial", size = 18, color = "#222222"),
    plot.title = element_text(family = "Arial", size = 28, face = "bold", color = "#222222"),
    plot.subtitle = element_text(family = "Arial", size = 22, margin = margin(9, 0, 9, 0)),
    plot.caption = element_text(size = 14, color = "#666666"),
    
    # Legend
    legend.position = "none",
    
    # Axis
    axis.title = element_blank(),
    axis.text = element_text(family = "Arial", size = 18, color = "#222222"),
    axis.text.x = element_text(margin = margin(5, b = 10)),
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    
    # Grid lines (BBC style: horizontal only)
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#cbcbcb"),
    panel.grid.major.x = element_blank(),
    
    # Background
    panel.background = element_blank(),
    plot.background = element_rect(fill = "white", color = NA)
  ) +
  labs(
    title = "Age Distribution by Grade Level",
    subtitle = "BBC Visual and Data Journalism Style",
    caption = "Source: ClinicoPath Histopathology Dataset"
  )

print(bbc_plot)
```

## Approach 7: GraphPad Prism Style

**Use Case**: Scientific software integration, GraphPad users,
statistical software consistency

**Strengths**: Authentic Prism styling, scientific software aesthetics,
statistical focus

``` r

# GraphPad Prism style approach  
advancedbarplot(
  data = histopathology,
  x_var = "Group",
  y_var = "OverallTime",
  fill_var = "Grade_Level",
  chart_approach = "prism_style",
  stat_type = "mean",
  color_palette = "prism_floral",
  bar_position = "dodge",
  theme_style = "prism_default",
  show_values = TRUE,
  plot_title = "Overall Survival Time by Treatment and Grade",
  subtitle_text = "GraphPad Prism Style Visualization"
)
```

### R Code Example for Prism Style

``` r

# GraphPad Prism style approach
prism_summary <- histopathology %>%
  group_by(Group, Grade_Level) %>%
  summarise(
    mean_time = mean(OverallTime, na.rm = TRUE),
    se = sd(OverallTime, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  )

# Prism-style colors (approximation)
prism_colors <- c("#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4")

prism_plot <- ggplot(prism_summary, aes(x = Group, y = mean_time, fill = Grade_Level)) +
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.8,
    alpha = 0.9
  ) +
  scale_fill_manual(values = prism_colors) +
  theme_minimal() +
  theme(
    panel.border = element_rect(colour = "black", fill = NA),
    axis.line = element_line(colour = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    legend.position = "top"
  ) +
  labs(
    title = "Overall Survival Time by Treatment and Grade",
    subtitle = "GraphPad Prism Style Visualization", 
    x = "Treatment Group",
    y = "Mean Overall Time (months)",
    fill = "Grade Level"
  )

print(prism_plot)
```

## Statistical Testing Integration

All approaches support integrated statistical testing:

``` r

# Example statistical comparisons
cat("Available statistical tests in advancedbarplot:\n")
#> Available statistical tests in advancedbarplot:
cat("- ANOVA: For comparing multiple groups\n")
#> - ANOVA: For comparing multiple groups
cat("- t-test: For comparing two groups\n") 
#> - t-test: For comparing two groups
cat("- Wilcoxon: Non-parametric alternative to t-test\n")
#> - Wilcoxon: Non-parametric alternative to t-test
cat("- Chi-square: For categorical data associations\n")
#> - Chi-square: For categorical data associations
cat("- Kruskal-Wallis: Non-parametric alternative to ANOVA\n")
#> - Kruskal-Wallis: Non-parametric alternative to ANOVA

# Example ANOVA test
anova_result <- aov(Age ~ Group, data = histopathology)
cat("\nExample ANOVA result (Age by Group):\n")
#> 
#> Example ANOVA result (Age by Group):
summary(anova_result)
#>              Df Sum Sq Mean Sq F value Pr(>F)
#> Group         1     45   45.41   0.237  0.626
#> Residuals   246  47043  191.23               
#> 2 observations deleted due to missingness
```

## Color Palette Showcase

The module includes 26+ professional color palettes:

``` r
# BBC Color Palettes
- bbc_blue: "#1380A1" 
- bbc_orange: "#FAAB18"
- bbc_multi: Multiple BBC brand colors

# GraphPad Prism Palettes  
- prism_floral: 12 colors
- prism_candy_bright: 9 colors
- prism_office: 9 colors
- prism_colorblind_safe: 6 colors

# Scientific Journal Palettes
- nature: Nature journal colors
- science: Science journal colors
- clinical: Clinical research optimized

# Standard Palettes
- viridis: Colorblind-friendly
- set1, dark2: RColorBrewer palettes
```

## Export and Reproducibility

### High-Quality Export Options

``` r

# For publication export
advancedbarplot(
  # ... your parameters ...
  plot_width = 10,      # Width in inches
  plot_height = 6,      # Height in inches
  export_options = TRUE # Optimize for export
)
```

### Reproducible R Code

Each approach generates reproducible R code that you can copy and
modify:

``` r

# Example generated code
ggplot(data, aes(x = Group, y = Age)) +
  geom_col(alpha = 0.8) +
  scale_fill_viridis_d() +
  theme_minimal() +
  theme(legend.position = "none")
```

## Best Practices

### 1. Choosing the Right Approach

- **Basic**: Quick exploration, learning ggplot2
- **Polished**: Business presentations, dashboards  
- **Statistical**: Research papers, hypothesis testing
- **Interactive**: Web apps, exploration tools
- **Publication**: Journal submissions, formal reports
- **BBC Style**: News graphics, public communication
- **Prism Style**: Scientific software integration

### 2. Data Preparation

``` r

# Always check your data first
summary(histopathology[c("Group", "Age", "Grade_Level")])
#>        Group          Age           Grade_Level 
#>  Length   :250   Min.   :25.00   Length   :250  
#>  N.unique :  2   1st Qu.:38.00   N.unique :  3  
#>  N.blank  :  0   Median :49.00   N.blank  :  0  
#>  Min.nchar:  7   Mean   :49.44   Min.nchar:  3  
#>  Max.nchar:  9   3rd Qu.:62.00   Max.nchar:  8  
#>  NAs      :  1   Max.   :73.00   NAs      :  1  
#>                  NAs    :1

# Handle missing values
cat("Missing values check:\n")
#> Missing values check:
sapply(histopathology[c("Group", "Age", "Grade_Level")], function(x) sum(is.na(x)))
#>       Group         Age Grade_Level 
#>           1           1           1

# Ensure proper factor levels
histopathology$Group <- factor(histopathology$Group)
histopathology$Grade_Level <- factor(histopathology$Grade_Level, levels = c("low", "high"))
```

### 3. Statistical Considerations

``` r

# Check assumptions before statistical tests
cat("Sample sizes by group:\n")
#> Sample sizes by group:
table(histopathology$Group)
#> 
#>   Control Treatment 
#>       120       129

cat("\nNormality check (Shapiro-Wilk test p-values):\n")
#> 
#> Normality check (Shapiro-Wilk test p-values):
by(histopathology$Age, histopathology$Group, function(x) shapiro.test(x)$p.value)
#> histopathology$Group: Control
#> [1] 7.107135e-05
#> ------------------------------------------------------------ 
#> histopathology$Group: Treatment
#> [1] 0.0007150149

cat("\nEqual variances test (F-test p-value):\n")
#> 
#> Equal variances test (F-test p-value):
var.test(Age ~ Group, data = histopathology)$p.value
#> [1] 0.3525381
```

## Conclusion

The `advancedbarplot` module provides a comprehensive toolkit for
professional bar chart visualization. Whether you need quick exploration
plots or publication-ready graphics, the 7 approaches cover all major
use cases in clinical research and data presentation.

### Key Takeaways

1.  **7 distinct approaches** for different use cases
2.  **Professional styling** with BBC and Prism authenticity
3.  **Statistical integration** with automated testing
4.  **Extensive customization** with 26+ color palettes
5.  **Export optimization** for publication and presentation

### Next Steps

- Explore the interactive features in jamovi
- Try different color palettes for your specific use case
- Experiment with statistical testing options
- Use the generated R code for further customization

For more advanced statistical plotting, see the related modules: -
`jjhistogram` for distribution analysis - `jjscatter` for correlation
visualization  
- `survival` for time-to-event analysis
