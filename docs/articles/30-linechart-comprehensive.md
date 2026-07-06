# Line Charts for Clinical Time Series and Trend Analysis

## Introduction to Line Charts in Clinical Research

### What are Line Charts?

Line charts are fundamental visualization tools that display data points
connected by straight line segments, making them ideal for showing
**trends and changes over time** or ordered categories. In clinical and
pathological research, line charts are essential for:

- **Longitudinal studies**: Tracking patient outcomes over time
- **Treatment monitoring**: Visualizing response to interventions
- **Biomarker evolution**: Following laboratory values or disease
  markers
- **Quality metrics**: Monitoring healthcare performance indicators
- **Dose-response relationships**: Understanding therapeutic
  relationships

#### Key Advantages

1.  **Trend Identification**: Easily spot increasing, decreasing, or
    stable patterns
2.  **Comparative Analysis**: Compare multiple groups or treatments
    simultaneously  
3.  **Time Series Visualization**: Perfect for longitudinal and
    follow-up studies
4.  **Statistical Integration**: Combine with trend lines, confidence
    intervals, and correlations
5.  **Clinical Communication**: Intuitive format for presenting to
    clinicians and patients

### When to Use Line Charts

#### Ideal Clinical Scenarios

- **Laboratory Values Over Time**: Hemoglobin, tumor markers,
  inflammatory indices
- **Treatment Response Monitoring**: Blood pressure, pain scores,
  functional assessments
- **Disease Progression**: Tumor size, cognitive decline, symptom
  severity
- **Quality Improvement**: Infection rates, readmission rates, patient
  satisfaction
- **Dose-Response Studies**: Efficacy or toxicity versus drug
  concentration

#### Data Requirements

- **X-axis**: Time points, visit numbers, or ordered categories
- **Y-axis**: Continuous numeric outcomes (laboratory values, scores,
  measurements)
- **Optional Grouping**: Treatment arms, patient populations, hospital
  units
- **Minimum Data**: At least 3 time points for meaningful trend analysis

## Statistical Background

### Trend Analysis Methods

#### Linear Trends

Line charts can incorporate **linear regression** to identify overall
trends:

``` math
Y = \beta_0 + \beta_1 \times Time + \epsilon
```

Where: - $`\beta_1`$ represents the rate of change per time unit -
Positive $`\beta_1`$: improving/increasing trend - Negative $`\beta_1`$:
declining/decreasing trend

#### Correlation Analysis

The relationship between time and outcome can be quantified using:

- **Pearson correlation**: For linear relationships
- **Spearman correlation**: For monotonic (rank-based) relationships
- **R-squared**: Proportion of variance explained by time

#### Confidence Intervals

Line charts can display **uncertainty** around trends: - **Standard
error bands**: Show precision of the line - **Confidence intervals**:
Typically 95% CI around the trend - **Prediction intervals**: Bounds for
future observations

### Clinical Interpretation Guidelines

#### Trend Magnitude

| Change.per.Unit.Time | Clinical.Significance | Clinical.Action | Examples |
|:---|:---|:---|:---|
| \< 5% | Minimal | Monitor | Lab variation |
| 5-15% | Small | Consider intervention | Modest improvement |
| 15-30% | Moderate | Likely clinically meaningful | Notable response |
| \> 30% | Large | Definite clinical impact | Major clinical change |

Clinical Interpretation of Trend Magnitude {.table}

#### Correlation Strength

| Correlation..r. | Strength    | Clinical.Utility   | R…Variance.Explained. |
|:----------------|:------------|:-------------------|:----------------------|
| 0.0 - 0.1       | Negligible  | No trend           | \< 1%                 |
| 0.1 - 0.3       | Weak        | Minimal trend      | 1-9%                  |
| 0.3 - 0.5       | Moderate    | Noticeable pattern | 9-25%                 |
| 0.5 - 0.7       | Strong      | Clear trend        | 25-49%                |
| 0.7 - 1.0       | Very Strong | Highly predictable | 49-100%               |

Correlation Strength Interpretation {.table}

## Clinical Examples

### Example 1: Hemoglobin Monitoring During Cancer Treatment

This example demonstrates monitoring anemia treatment in cancer patients
receiving erythropoietin (EPO) therapy.

``` r

# Create realistic hemoglobin data
set.seed(123)
n_patients <- 90
n_visits <- 6
visit_weeks <- c(0, 2, 4, 8, 12, 16)

# Generate patient data
hemoglobin_data <- expand.grid(
  patient_id = paste0("P", sprintf("%03d", 1:n_patients)),
  visit_week = visit_weeks
) %>%
  left_join(
    data.frame(
      patient_id = paste0("P", sprintf("%03d", 1:n_patients)),
      treatment_group = sample(c("Control", "EPO_Low", "EPO_High"), n_patients,
        replace = TRUE, prob = c(0.3, 0.4, 0.3)
      ),
      baseline_hgb = rnorm(n_patients, mean = 9.5, sd = 1.2)
    ),
    by = "patient_id"
  ) %>%
  arrange(patient_id, visit_week)

# Generate hemoglobin trajectories
hemoglobin_data$hemoglobin_g_dl <- NA

for (i in 1:nrow(hemoglobin_data)) {
  week <- hemoglobin_data$visit_week[i]
  treatment <- hemoglobin_data$treatment_group[i]
  baseline <- hemoglobin_data$baseline_hgb[i]

  # Treatment-specific trends
  if (treatment == "Control") {
    trend <- -0.03 * week + rnorm(1, 0, 0.3)
  } else if (treatment == "EPO_Low") {
    trend <- 0.08 * week + rnorm(1, 0, 0.25)
  } else {
    trend <- 0.12 * week + rnorm(1, 0, 0.2)
  }

  hemoglobin_data$hemoglobin_g_dl[i] <- baseline + trend
}

# Ensure realistic ranges
hemoglobin_data$hemoglobin_g_dl <- pmax(6, pmin(16, hemoglobin_data$hemoglobin_g_dl))
hemoglobin_data$hemoglobin_g_dl <- round(hemoglobin_data$hemoglobin_g_dl, 1)

# Display data structure
str(hemoglobin_data)
#> 'data.frame':    540 obs. of  5 variables:
#>  $ patient_id     : chr  "P001" "P001" "P001" "P001" ...
#>  $ visit_week     : num  0 2 4 8 12 16 0 2 4 8 ...
#>  $ treatment_group: chr  "EPO_Low" "EPO_Low" "EPO_Low" "EPO_Low" ...
#>  $ baseline_hgb   : num  8.15 8.15 8.15 8.15 8.15 ...
#>  $ hemoglobin_g_dl: num  8.4 7.9 8.7 9.3 8.8 9.6 8.9 8.5 8.4 8.3 ...
#>  - attr(*, "out.attrs")=List of 2
#>   ..$ dim     : Named int [1:2] 90 6
#>   .. ..- attr(*, "names")= chr [1:2] "patient_id" "visit_week"
#>   ..$ dimnames:List of 2
#>   .. ..$ patient_id: chr [1:90] "patient_id=P001" "patient_id=P002" "patient_id=P003" "patient_id=P004" ...
#>   .. ..$ visit_week: chr [1:6] "visit_week= 0" "visit_week= 2" "visit_week= 4" "visit_week= 8" ...
head(hemoglobin_data, 12)
#>    patient_id visit_week treatment_group baseline_hgb hemoglobin_g_dl
#> 1        P001          0         EPO_Low     8.152270             8.4
#> 2        P001          2         EPO_Low     8.152270             7.9
#> 3        P001          4         EPO_Low     8.152270             8.7
#> 4        P001          8         EPO_Low     8.152270             9.3
#> 5        P001         12         EPO_Low     8.152270             8.8
#> 6        P001         16         EPO_Low     8.152270             9.6
#> 7        P002          0         Control     9.016538             8.9
#> 8        P002          2         Control     9.016538             8.5
#> 9        P002          4         Control     9.016538             8.4
#> 10       P002          8         Control     9.016538             8.3
#> 11       P002         12         Control     9.016538             8.5
#> 12       P002         16         Control     9.016538             8.1
```

#### Running Line Chart Analysis

``` r

# In jamovi, you would select:
# Analyses → JJStatsPlot → Line Chart

# Programmatically (if running in R):
hemoglobin_result <- linechart(
  data = hemoglobin_data,
  xvar = "visit_week",
  yvar = "hemoglobin_g_dl",
  groupby = "treatment_group",
  confidence = TRUE,
  trendline = TRUE,
  points = TRUE,
  refline = 12,
  reflineLabel = "Normal Lower Limit",
  xlabel = "Weeks Since Treatment Start",
  ylabel = "Hemoglobin (g/dL)",
  title = "Hemoglobin Response to EPO Treatment",
  colorPalette = "clinical"
)
```

#### Expected Clinical Results

1.  **Visual Patterns**:
    - Control group: Slight decline or stable low values
    - EPO Low dose: Gradual improvement over time
    - EPO High dose: Steeper improvement, reaching normal range
2.  **Statistical Analysis**:
    - Strong positive correlation for EPO groups (r \> 0.7)
    - Weak negative correlation for control group
    - Significant trend p-values for treatment groups
3.  **Clinical Interpretation**:
    - EPO therapy effectively treats cancer-related anemia
    - Higher doses provide faster hemoglobin recovery
    - Reference line helps identify patients reaching normal range

### Example 2: Blood Pressure Response to Interventions

This example shows hypertension management comparing lifestyle
interventions, medications, and combined therapy.

``` r

# Create blood pressure monitoring data
set.seed(456)
n_subjects <- 75
n_months <- 8
months <- 0:(n_months - 1)

bp_data <- expand.grid(
  subject_id = paste0("BP", sprintf("%03d", 1:n_subjects)),
  month = months
) %>%
  left_join(
    data.frame(
      subject_id = paste0("BP", sprintf("%03d", 1:n_subjects)),
      intervention = sample(c("Lifestyle", "Medication", "Combined"), n_subjects,
        replace = TRUE, prob = c(0.35, 0.35, 0.3)
      ),
      baseline_sbp = rnorm(n_subjects, mean = 155, sd = 15)
    ),
    by = "subject_id"
  ) %>%
  arrange(subject_id, month)

# Generate systolic BP trajectories
bp_data$systolic_bp <- NA

for (i in 1:nrow(bp_data)) {
  month <- bp_data$month[i]
  intervention <- bp_data$intervention[i]
  baseline <- bp_data$baseline_sbp[i]

  # Intervention-specific effects
  if (intervention == "Lifestyle") {
    reduction <- 2 * sqrt(month) + rnorm(1, 0, 2)
  } else if (intervention == "Medication") {
    reduction <- ifelse(month <= 3, 8 * (month / 3), 8 + 2 * ((month - 3) / 5)) + rnorm(1, 0, 3)
  } else {
    reduction <- ifelse(month <= 2, 6 * (month / 2), 6 + 8 * ((month - 2) / 6)) + rnorm(1, 0, 2)
  }

  bp_data$systolic_bp[i] <- baseline - reduction
}

# Ensure realistic ranges
bp_data$systolic_bp <- pmax(90, pmin(200, bp_data$systolic_bp))
bp_data$systolic_bp <- round(bp_data$systolic_bp)

# Display summary
cat("Blood Pressure Study Summary:\n")
#> Blood Pressure Study Summary:
cat("Subjects:", length(unique(bp_data$subject_id)), "\n")
#> Subjects: 75
cat("Interventions:", paste(unique(bp_data$intervention), collapse = ", "), "\n")
#> Interventions: Medication, Combined, Lifestyle
cat(
  "Baseline SBP range:", min(bp_data[bp_data$month == 0, "systolic_bp"]), "-",
  max(bp_data[bp_data$month == 0, "systolic_bp"]), "mmHg\n"
)
#> Baseline SBP range: 113 - 192 mmHg
cat(
  "Final SBP range:", min(bp_data[bp_data$month == max(bp_data$month), "systolic_bp"]), "-",
  max(bp_data[bp_data$month == max(bp_data$month), "systolic_bp"]), "mmHg\n"
)
#> Final SBP range: 101 - 187 mmHg
```

#### Blood Pressure Analysis Setup

``` r

bp_result <- linechart(
  data = bp_data,
  xvar = "month",
  yvar = "systolic_bp",
  groupby = "intervention",
  confidence = TRUE,
  trendline = TRUE,
  refline = 140,
  reflineLabel = "Hypertension Threshold",
  xlabel = "Months Since Intervention Start",
  ylabel = "Systolic Blood Pressure (mmHg)",
  title = "Blood Pressure Response to Different Interventions",
  colorPalette = "colorblind",
  theme = "publication"
)
```

#### Expected Clinical Findings

1.  **Intervention Comparisons**:
    - **Lifestyle**: Gradual, sustained reduction
    - **Medication**: Rapid initial improvement, then plateau
    - **Combined**: Best overall reduction combining both benefits
2.  **Clinical Milestones**:
    - Time to reach target BP (\<140 mmHg)
    - Magnitude of reduction from baseline
    - Sustainability of improvements

### Example 3: Biomarker Response to Immunotherapy

This example tracks inflammatory biomarkers (IL-6, TNF-α) during cancer
immunotherapy to assess treatment response.

``` r

# Create biomarker immunotherapy data
set.seed(789)
n_patients <- 45
visit_days <- c(0, 21, 42, 84, 126, 168)

biomarker_data <- expand.grid(
  patient_id = paste0("IMM", sprintf("%03d", 1:n_patients)),
  visit_day = visit_days
) %>%
  left_join(
    data.frame(
      patient_id = paste0("IMM", sprintf("%03d", 1:n_patients)),
      response_type = sample(c("Responder", "Non_Responder", "Progressive"), n_patients,
        replace = TRUE, prob = c(0.4, 0.35, 0.25)
      ),
      baseline_il6 = rlnorm(n_patients, meanlog = 2, sdlog = 0.8)
    ),
    by = "patient_id"
  ) %>%
  arrange(patient_id, visit_day)

# Generate IL-6 trajectories
biomarker_data$il6_pg_ml <- NA

for (i in 1:nrow(biomarker_data)) {
  day <- biomarker_data$visit_day[i]
  response <- biomarker_data$response_type[i]
  baseline <- biomarker_data$baseline_il6[i]

  # Response-specific patterns
  if (response == "Responder") {
    factor <- exp(-0.003 * day) * (1 + rnorm(1, 0, 0.2))
  } else if (response == "Non_Responder") {
    factor <- 1 + 0.1 * sin(day / 50) * (1 + rnorm(1, 0, 0.3))
  } else {
    factor <- 1 + 0.002 * day * (1 + rnorm(1, 0, 0.4))
  }

  biomarker_data$il6_pg_ml[i] <- baseline * factor
}

# Ensure positive values
biomarker_data$il6_pg_ml <- pmax(0.1, pmin(100, biomarker_data$il6_pg_ml))
biomarker_data$il6_pg_ml <- round(biomarker_data$il6_pg_ml, 2)

# Calculate summary by response type
response_summary <- biomarker_data %>%
  filter(visit_day %in% c(0, 168)) %>%
  select(patient_id, response_type, visit_day, il6_pg_ml) %>%
  tidyr::pivot_wider(names_from = visit_day, values_from = il6_pg_ml, names_prefix = "day_") %>%
  mutate(percent_change = round(100 * (day_168 - day_0) / day_0, 1)) %>%
  group_by(response_type) %>%
  summarise(
    n = n(),
    mean_baseline = round(mean(day_0, na.rm = TRUE), 1),
    mean_final = round(mean(day_168, na.rm = TRUE), 1),
    mean_change = round(mean(percent_change, na.rm = TRUE), 1),
    .groups = "drop"
  )

print(response_summary)
#> # A tibble: 3 × 5
#>   response_type     n mean_baseline mean_final mean_change
#>   <chr>         <int>         <dbl>      <dbl>       <dbl>
#> 1 Non_Responder    18           9.4        9.2        -2.3
#> 2 Progressive       5           8         10.8        37.2
#> 3 Responder        22           9.6        7.4       -29
```

#### Biomarker Analysis

``` r

biomarker_result <- linechart(
  data = biomarker_data,
  xvar = "visit_day",
  yvar = "il6_pg_ml",
  groupby = "response_type",
  confidence = TRUE,
  smooth = TRUE, # Use smoothed lines for biomarker data
  xlabel = "Days Since Treatment Start",
  ylabel = "IL-6 (pg/mL)",
  title = "IL-6 Response Patterns During Immunotherapy",
  colorPalette = "viridis"
)
```

#### Clinical Biomarker Interpretation

1.  **Response Patterns**:
    - **Responders**: Progressive decline in inflammatory markers
    - **Non-responders**: Stable levels with minimal change  
    - **Progressive disease**: Increasing inflammatory activity
2.  **Predictive Value**:
    - Early biomarker changes may predict long-term response
    - Useful for treatment modification decisions
    - Complement to imaging and clinical assessments

## Advanced Line Chart Features

### Confidence Intervals and Uncertainty

#### Standard Error vs. Confidence Intervals

``` r

# Line chart with confidence intervals
result <- linechart(
  data = clinical_data,
  xvar = "time_point",
  yvar = "biomarker_level",
  groupby = "treatment",
  confidence = TRUE, # Shows 95% CI around lines
  smooth = FALSE, # Linear vs. smoothed confidence bands
  theme = "publication"
)
```

**Clinical Applications**: - **Uncertainty quantification**: Show
precision of measurements - **Group comparisons**: Overlapping CI
suggests similar trends - **Sample size effects**: Wider CI with smaller
groups - **Statistical significance**: Non-overlapping CI indicates
differences

### Reference Lines and Clinical Thresholds

#### Normal Ranges and Target Values

``` r

# Add clinical reference lines
result <- linechart(
  data = lab_data,
  xvar = "visit_week",
  yvar = "hemoglobin_g_dl",
  refline = 12, # Normal hemoglobin threshold
  reflineLabel = "Normal Range", # Clear clinical labeling
  title = "Hemoglobin Monitoring with Clinical Targets"
)
```

**Common Clinical References**: - **Laboratory normal ranges**:
Hemoglobin, liver enzymes, kidney function - **Blood pressure targets**:
\<140/90 mmHg for hypertension - **Pain score thresholds**: \<=3/10 for
adequate pain control - **Quality metrics**: Infection rates,
readmission benchmarks

### Statistical Trend Analysis

#### Linear vs. Non-linear Trends

``` r

# Compare linear and smoothed trends
linear_result <- linechart(
  data = longitudinal_data,
  xvar = "time",
  yvar = "outcome",
  trendline = TRUE, # Linear regression line
  smooth = FALSE # Straight line connections
)

smooth_result <- linechart(
  data = longitudinal_data,
  xvar = "time",
  yvar = "outcome",
  smooth = TRUE, # LOESS smoothing
  confidence = TRUE # Smoothed confidence bands
)
```

**When to Use Each**: - **Linear trends**: Constant rate of change,
dose-response relationships - **Smoothed trends**: Complex patterns,
seasonal effects, non-linear responses

## Clinical Applications by Specialty

### Oncology Applications

#### Treatment Response Monitoring

| Clinical.Scenario | X.axis.Variable | Y.axis.Variable | Grouping.Variable |
|:---|:---|:---|:---|
| Tumor marker trends | Months since diagnosis | PSA, CA-125, CEA levels | Tumor stage/grade |
| Chemotherapy response | Treatment cycles | Tumor size (RECIST) | Treatment regimen |
| Quality of life during treatment | Weeks since treatment start | EORTC QLQ scores | Performance status |
| Biomarker-guided therapy | Days since targeted therapy | PD-L1, circulating tumor DNA | Biomarker status |
| Survivorship monitoring | Years post-treatment | Late effects scores | Treatment modality |

Oncology Line Chart Applications {.table}

#### Key Clinical Insights

- **Early response prediction**: Biomarker changes predict long-term
  outcomes
- **Treatment optimization**: Adjust therapy based on trends
- **Quality of life**: Balance efficacy with patient-reported outcomes

### Cardiology Applications

#### Cardiovascular Risk Management

| Clinical.Scenario | Outcome.Measures | Clinical.Targets | Typical.Timeline |
|:---|:---|:---|:---|
| Blood pressure management | SBP/DBP (mmHg) | \<140/90 mmHg | Months to years |
| Lipid control monitoring | LDL cholesterol (mg/dL) | \<70 mg/dL (high risk) | 3-6 month intervals |
| Heart failure progression | EF%, BNP levels | Stable/improved EF | Quarterly assessments |
| Post-MI recovery | Exercise capacity, LVEF | Return to baseline function | 6-12 months post-MI |
| Device monitoring | ICD/pacemaker parameters | Appropriate device function | Continuous monitoring |

Cardiology Monitoring Applications {.table}

### Critical Care Applications

#### ICU Monitoring and Outcomes

| Monitoring.Domain | Key.Variables | Time.Resolution | Clinical.Goals |
|:---|:---|:---|:---|
| Hemodynamic stability | MAP, cardiac output | Hours to days | Hemodynamic optimization |
| Respiratory function | P/F ratio, PEEP levels | Hourly to daily | Weaning from ventilator |
| Organ function recovery | Creatinine, liver enzymes | Daily assessments | Organ recovery |
| Sedation management | RASS scores, delirium | Shift-based scoring | Optimal sedation |
| Nutritional status | Albumin, weight changes | Daily to weekly | Adequate nutrition |

Critical Care Line Chart Applications {.table}

## Best Practices for Clinical Line Charts

### Data Preparation Guidelines

#### 1. Time Variable Standardization

``` r

# Standardize time points for multi-site studies
clinical_data <- clinical_data %>%
  mutate(
    # Convert visit dates to study days
    study_day = as.numeric(visit_date - enrollment_date),

    # Group irregular visits into windows
    visit_window = case_when(
      study_day <= 7 ~ "Week 1",
      study_day <= 28 ~ "Month 1",
      study_day <= 84 ~ "Month 3",
      study_day <= 168 ~ "Month 6",
      TRUE ~ "Later"
    ),

    # Handle missing values appropriately
    outcome_clean = ifelse(is.na(lab_value), NA, lab_value)
  )
```

#### 2. Missing Data Strategies

``` r

# Handle missing data patterns
missing_analysis <- clinical_data %>%
  group_by(patient_id) %>%
  summarise(
    n_visits = n(),
    n_missing = sum(is.na(primary_outcome)),
    last_visit = max(study_day, na.rm = TRUE),
    dropout_pattern = case_when(
      n_missing == 0 ~ "Complete",
      n_missing < n_visits / 2 ~ "Sporadic missing",
      last_visit < 168 ~ "Early dropout",
      TRUE ~ "Late dropout"
    )
  )

# Visualize missing patterns
missing_plot <- linechart(
  data = clinical_data,
  xvar = "study_day",
  yvar = "primary_outcome",
  groupby = "dropout_pattern",
  title = "Outcome by Missing Data Pattern"
)
```

#### 3. Outlier Management

``` r

# Identify and handle outliers
clinical_data <- clinical_data %>%
  group_by(visit_week) %>%
  mutate(
    # Calculate z-scores within time points
    z_score = abs(scale(lab_value)[, 1]),

    # Flag extreme outliers
    outlier_flag = z_score > 3,

    # Winsorize extreme values
    lab_value_winsorized = case_when(
      z_score > 3 ~ quantile(lab_value, 0.95, na.rm = TRUE),
      z_score < -3 ~ quantile(lab_value, 0.05, na.rm = TRUE),
      TRUE ~ lab_value
    )
  ) %>%
  ungroup()
```

### Visualization Design Principles

#### 1. Color and Theme Selection

``` r

# Clinical publication-ready themes
publication_chart <- linechart(
  data = clinical_data,
  xvar = "time_point",
  yvar = "biomarker",
  groupby = "treatment",
  colorPalette = "colorblind", # Accessible to colorblind readers
  theme = "publication", # Clean, professional appearance
  xlabel = "Time (weeks)",
  ylabel = "Biomarker Level (units)",
  title = "Treatment Response Over Time"
)

# Specialty-specific color schemes
cardiology_chart <- linechart(
  data = bp_data,
  colorPalette = "clinical", # Red/blue for medical contexts
  refline = 140,
  reflineLabel = "Hypertension Threshold"
)
```

#### 2. Axis and Label Optimization

``` r

# Optimize for clinical communication
optimized_chart <- linechart(
  data = clinical_data,
  xvar = "visit_month",
  yvar = "hemoglobin_g_dl",

  # Clear, clinical labels
  xlabel = "Months Since Treatment Initiation",
  ylabel = "Hemoglobin (g/dL)",
  title = "Hemoglobin Response to Iron Supplementation",

  # Reference lines for clinical context
  refline = 12,
  reflineLabel = "Normal Lower Limit (Women)",

  # Appropriate size for presentations
  width = 800,
  height = 600
)
```

### Statistical Reporting Standards

#### 1. Correlation and Trend Reporting

``` r

# Extract statistical results for reporting
trend_analysis <- linechart(
  data = longitudinal_data,
  xvar = "time",
  yvar = "outcome",
  trendline = TRUE
)

# Report format for publications:
# "Hemoglobin levels showed a significant positive correlation with time
# (r = 0.78, 95% CI: 0.65-0.87, p < 0.001), with an average increase
# of 0.45 g/dL per month (95% CI: 0.32-0.58)."
```

#### 2. Group Comparison Reporting

``` r

# Compare trends between groups
group_analysis <- linechart(
  data = treatment_data,
  xvar = "weeks",
  yvar = "pain_score",
  groupby = "treatment_arm",
  trendline = TRUE
)

# Report format:
# "Pain scores decreased significantly in both treatment groups over 12 weeks.
# The experimental group showed a steeper decline (slope = -0.8 points/week,
# r = -0.85, p < 0.001) compared to control (slope = -0.3 points/week,
# r = -0.62, p = 0.003)."
```

## Troubleshooting Common Issues

### 1. Irregular Time Points

**Problem**: Clinical visits don’t occur at regular intervals

**Solutions**:

``` r

# Option 1: Use actual visit times
irregular_chart <- linechart(
  data = visit_data,
  xvar = "actual_visit_day", # Use actual times
  yvar = "lab_result",
  smooth = TRUE # Smooth over irregular intervals
)

# Option 2: Standardize to visit windows
standardized_data <- visit_data %>%
  mutate(
    visit_period = case_when(
      actual_visit_day <= 10 ~ "Baseline",
      actual_visit_day <= 35 ~ "Month 1",
      actual_visit_day <= 95 ~ "Month 3",
      TRUE ~ "Month 6"
    )
  )

window_chart <- linechart(
  data = standardized_data,
  xvar = "visit_period",
  yvar = "lab_result"
)
```

### 2. Highly Variable Data

**Problem**: Large fluctuations obscure underlying trends

**Solutions**:

``` r

# Use smoothed lines for noisy data
smooth_chart <- linechart(
  data = noisy_data,
  xvar = "time",
  yvar = "variable_outcome",
  smooth = TRUE, # LOESS smoothing
  confidence = TRUE, # Show uncertainty
  points = FALSE # Hide individual points
)

# Alternative: Moving averages
smoothed_data <- noisy_data %>%
  arrange(patient_id, time_point) %>%
  group_by(patient_id) %>%
  mutate(
    moving_avg = zoo::rollmean(outcome, k = 3, fill = NA, align = "center")
  ) %>%
  ungroup()
```

### 3. Multiple Y-Variables

**Problem**: Want to show multiple related outcomes

**Solutions**:

``` r

# Option 1: Standardize to z-scores
standardized_data <- clinical_data %>%
  mutate(
    sbp_z = as.numeric(scale(systolic_bp)),
    dbp_z = as.numeric(scale(diastolic_bp))
  ) %>%
  tidyr::pivot_longer(
    cols = c(sbp_z, dbp_z),
    names_to = "bp_type",
    values_to = "z_score"
  )

multi_outcome_chart <- linechart(
  data = standardized_data,
  xvar = "visit_month",
  yvar = "z_score",
  groupby = "bp_type",
  ylabel = "Standardized Blood Pressure (Z-score)"
)

# Option 2: Separate charts with same scale
sbp_chart <- linechart(data = bp_data, xvar = "month", yvar = "systolic_bp")
dbp_chart <- linechart(data = bp_data, xvar = "month", yvar = "diastolic_bp")
```

### 4. Small Sample Sizes

**Problem**: Few patients or time points

**Solutions**:

``` r

# Emphasize individual trajectories
small_sample_chart <- linechart(
  data = pilot_data,
  xvar = "time",
  yvar = "outcome",
  points = TRUE, # Show all data points
  confidence = FALSE, # Don't show CI with small n
  smooth = FALSE, # Use straight lines
  title = "Individual Patient Trajectories (n=8)"
)

# Consider spaghetti plots for individual patients
individual_chart <- linechart(
  data = pilot_data,
  xvar = "time",
  yvar = "outcome",
  groupby = "patient_id", # Each patient as separate line
  theme = "minimal"
)
```

## Publication and Presentation Guidelines

### Journal Submission Standards

#### Figure Preparation Checklist

``` r

# Publication-ready line chart
publication_figure <- linechart(
  data = study_data,
  xvar = "time_weeks",
  yvar = "primary_endpoint",
  groupby = "treatment_arm",

  # Professional appearance
  theme = "publication",
  colorPalette = "colorblind",

  # Appropriate sizing
  width = 800, # Suitable for 2-column format
  height = 600,

  # Clear labeling
  xlabel = "Time (weeks)",
  ylabel = "Primary Endpoint (units)",
  title = "", # Usually caption provides title

  # Statistical elements
  confidence = TRUE,
  trendline = TRUE
)
```

#### Essential Figure Elements

1.  **Clear axes labels** with units
2.  **Legible font sizes** (minimum 10pt)
3.  **Colorblind-friendly palettes**
4.  **Statistical information** (p-values, confidence intervals)
5.  **Sample sizes** for each group and time point
6.  **Reference lines** for clinical thresholds

#### Caption Writing Guidelines

    Figure 1. Treatment response over time by intervention group. 
    Line chart showing mean (±95% CI) primary endpoint values over 
    24 weeks of follow-up. Control group (n=45, blue), Intervention 
    group (n=43, red). Dotted horizontal line indicates clinical 
    significance threshold (threshold value). P-values from linear 
    mixed-effects models comparing slopes between groups.

### Presentation Best Practices

#### 1. Audience-Specific Design

``` r

# For clinical audiences
clinical_presentation <- linechart(
  data = clinical_data,
  colorPalette = "clinical",
  theme = "classic",

  # Larger fonts for projection
  width = 1000,
  height = 700,

  # Clear reference lines
  refline = clinical_threshold,
  reflineLabel = "Clinical Target"
)

# For research conferences
research_presentation <- linechart(
  data = research_data,
  theme = "publication",
  confidence = TRUE, # Show statistical rigor
  trendline = TRUE,
  colorPalette = "viridis" # Professional color scheme
)
```

#### 2. Interactive Elements

For presentations where interaction is possible:

- **Hover information**: Display exact values and sample sizes
- **Group toggle**: Allow showing/hiding specific treatment groups
- **Time range selection**: Focus on specific periods of interest
- **Statistical overlay**: Toggle trend lines and confidence intervals

## Conclusion

Line charts are powerful tools for clinical research visualization that
enable:

### Key Clinical Applications

- **Longitudinal Analysis**: Track patient outcomes over time
- **Treatment Monitoring**: Assess intervention effectiveness  
- **Biomarker Evolution**: Follow disease progression markers
- **Quality Improvement**: Monitor healthcare performance metrics
- **Comparative Research**: Compare treatments or populations

### Statistical Capabilities

- **Trend Analysis**: Linear and non-linear pattern detection
- **Correlation Assessment**: Quantify time-outcome relationships
- **Confidence Intervals**: Display uncertainty and precision
- **Group Comparisons**: Statistical comparison of trends

### Best Practices Summary

1.  **Design for audience**: Clinical vs. research presentations
2.  **Include clinical context**: Reference lines and thresholds  
3.  **Handle missing data**: Transparent reporting of dropout patterns
4.  **Statistical rigor**: Report correlations, confidence intervals,
    and p-values
5.  **Professional appearance**: Publication-ready formatting

### Future Directions

- **Real-time monitoring**: Integration with electronic health records
- **Predictive modeling**: Combine trends with machine learning
- **Patient-specific trajectories**: Personalized medicine applications
- **Multi-outcome visualization**: Simultaneous monitoring of related
  endpoints

The `linechart` function in ClinicoPath provides researchers and
clinicians with a comprehensive tool for creating publication-quality
visualizations that effectively communicate temporal patterns and
treatment effects in clinical data.

------------------------------------------------------------------------

*For more information about ClinicoPath visualization tools and clinical
data analysis, visit the package documentation and tutorials.*
