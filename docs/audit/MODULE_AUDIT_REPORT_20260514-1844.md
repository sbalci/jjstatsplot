# Module Audit Report — jjstatsplot 0.0.38.1

**Audited:** 2026-05-14 18:44
**Profile:** standard
**Functions:** 18  ·  READY 0  ·  NEEDS WORK 18  ·  PLACEHOLDER 0  ·  MISSING 0  ·  ORPHANED 0
**Security findings:** HIGH 0  ·  MEDIUM 13  ·  LOW ~50 (aggregated D/H)
**Skill:** audit-module v0.1.0

---

## Executive Dashboard

| Function | Status | HIGH-Sec | MEDIUM-Sec | Integration | Notices | i18n | Readiness |
|---|:---:|:---:|:---:|:---:|:---:|:---:|---|
| [advancedraincloud](#advancedraincloud) | ⚠️ | 0 | 1 | ✅ | ⚠ | PARTIAL | NEEDS_VALIDATION |
| [hullplot](#hullplot) | ⚠️ | 0 | 0 | ✅ | ❌ | NONE | NEEDS_VALIDATION |
| [jjarcdiagram](#jjarcdiagram) | ⚠️ | 0 | 1 | ✅ | ✅ | PARTIAL | NEEDS_VALIDATION |
| [jjbarstats](#jjbarstats) | ⚠️ | 0 | 2 | ✅ | ✅ | NONE | NEEDS_VALIDATION |
| [jjbetweenstats](#jjbetweenstats) | ⚠️ | 0 | 0 | ✅ | ⚠ | PARTIAL | NEEDS_VALIDATION |
| [jjcorrmat](#jjcorrmat) | ⚠️ | 0 | 0 | ✅ | ⚠ | PARTIAL | NEEDS_VALIDATION |
| [jjdotplotstats](#jjdotplotstats) | ⚠️ | 0 | 0 | ✅ | ❌ | NONE | NEEDS_VALIDATION |
| [jjhistostats](#jjhistostats) | ⚠️ | 0 | 0 | ✅ | ❌ | NONE | NEEDS_VALIDATION |
| [jjpiestats](#jjpiestats) | ⚠️ | 0 | 6 | ✅ | ✅ | NONE | NEEDS_VALIDATION |
| [jjridges](#jjridges) | ⚠️ | 0 | 0 | ✅ | ✅ | PARTIAL | NEEDS_VALIDATION |
| [jjscatterstats](#jjscatterstats) | ⚠️ | 0 | 0 | ✅ | ❌ | NONE | NEEDS_VALIDATION |
| [jjsegmentedtotalbar](#jjsegmentedtotalbar) | ⚠️ | 0 | 0 | ✅ | ❌ | PARTIAL | NEEDS_VALIDATION |
| [jjwithinstats](#jjwithinstats) | ⚠️ | 0 | 0 | ✅ | ❌ | PARTIAL | NEEDS_VALIDATION |
| [jwaffle](#jwaffle) | ⚠️ | 0 | 1 | ✅ | ⚠ | NONE | NEEDS_VALIDATION |
| [linechart](#linechart) | ⚠️ | 0 | 0 | ✅ | ❌ | PARTIAL | NEEDS_VALIDATION |
| [lollipop](#lollipop) | ⚠️ | 0 | 0 | ✅ | ⚠ | PARTIAL | NEEDS_VALIDATION |
| [raincloud](#raincloud) | ⚠️ | 0 | 2 | ✅ | ❌ | PARTIAL | NEEDS_VALIDATION |
| [statsplot2](#statsplot2) | ⚠️ | 0 | 0 | ✅ | ✅ | NONE | NEEDS_VALIDATION |

**Top 10 cross-cutting issues (affecting multiple functions):**

1. **[D-MEDIUM] No `htmltools::htmlEscape` anywhere in 18/18 .b.R files** — column names, factor labels, and user-data values are interpolated into HTML via `paste`/`sprintf`/`glue` without escaping. XSS path: a malicious CSV column with embedded markup is rendered through `setContent()`.
2. **[C1-MEDIUM] `as.formula()` on strings built from user inputs without `jmvcore::asFormula` allow-list guard** — 13 hits across `advancedraincloud`, `jjbarstats`, `jjpiestats` (6 hits), `raincloud` (3 hits), `jwaffle`. RHS injection through column name in `xtabs`/`facet_wrap`/`aov`/`kruskal.test`. Mostly defended by backtick wrapping but missing modern jmvcore guard.
3. **[jmvcore/error] 96 raw `stop(...)` calls in user-facing paths across 16 functions** — only 4 functions use `jmvcore::reject` consistently. Users get bare R error tracebacks rather than structured jamovi UI errors.
4. **[jmvcore/term] Manual backtick quoting `paste0('\`', var, '\`')` instead of `jmvcore::composeTerm`** — 10 sites in 6 files (`jjbarstats`, `jjcorrmat`, `jjhistostats`, `jjridges`, `jwaffle`). Works but fragile against interaction terms and special characters.
5. **[i18n] No `jamovi/i18n/` translation infrastructure exists** — directory is missing entirely. No `catalog.pot`, no `en.po`, no `tr.po`. 8/18 functions have zero `.()` wrappings and the other 10 are partial.
6. **[notices] No `insert(1, ...)` ERROR-at-top banners** — all 64 Notice insertions use position 999 (bottom) or 2 (mid). When inputs are missing, users see a raw `stop()` traceback before they get any structured guidance.
7. **[stats/clinical] No low-n / events / prevalence STRONG_WARNING guards** — `jjcorrmat` has an `n < 20` warning but no module-wide pattern. `jjwithinstats` (paired), `jjbetweenstats`, `jjbarstats` (chi-square expected counts) lack the standard thresholds.
8. **[code-quality] 11 of 18 `.run()` bodies exceed ~1,000 LOC** — `jjridges` (2,139), `jjpiestats` (1,500), `statsplot2` (1,491), `jjsegmentedtotalbar` (1,457), `jjbarstats` (1,370), `jjwithinstats` (1,350), `jjbetweenstats` (1,264), `linechart` (1,281), etc. Some have helper extraction; many do not.
9. **[jmvcore/na] `na.omit` instead of `jmvcore::naOmit`** — `jjcorrmat:419`, `jjridges:905`. Loses jamovi column attributes (measureType, values labels) downstream.
10. **[hygiene] Multiple `notice$setContent(paste(ratio_warnings, collapse = "<br>"))` style commented-out dead notice code in `jjpiestats`** — visual debt; should be removed.

---

## Methodology

**Profile:** standard

**Checks run:**

- [x] Function discovery from `jamovi/0000.yaml` + filesystem (18 functions, all wired)
- [x] Security pattern scan (catalog A–I) — see `references/security-patterns.md`
- [x] jmvcore migration scan (6 groups) — see `references/jmvcore-migration.md`
- [x] Integration audit (9 checks) — see `references/integration-checks.md`
- [x] Notices coverage — see `references/notices-checklist.md`
- [x] Code review (8 areas) — see `references/code-review-checks.md`
- [ ] R6 & R-package best practices (spot-checked only — full check is `deep` profile)
- [ ] Vignette cross-reference (deep profile only)

**Checks skipped:**

- External documentation comparison (CRAN/GitHub) — run `/check-function-full <name>` per function if needed
- Function execution (differential runs) — heuristic only, no actual jamovi runs
- R CMD check, `devtools::document()`, `jmvtools::prepare()` — out of scope for this skill
- Statistical correctness per analysis — marked **NOT_EVALUATED** in each function; run `/review-function <name>` for deep math/stats review

**Audit-only.** No source files were modified.

---

## Per-Function Sections

### advancedraincloud

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/advancedraincloud.b.R`](../../R/advancedraincloud.b.R) · [`jamovi/advancedraincloud.a.yaml`](../../jamovi/advancedraincloud.a.yaml) · [`jamovi/advancedraincloud.u.yaml`](../../jamovi/advancedraincloud.u.yaml) · [`jamovi/advancedraincloud.r.yaml`](../../jamovi/advancedraincloud.r.yaml)
**Metrics:** .b.R LOC 1,769 · options 45 · outputs 9 · String opts 6 · Variable opts 5 · checkpoints 6

#### Security

- **[C1-MEDIUM]** [`R/advancedraincloud.b.R:1018`](../../R/advancedraincloud.b.R#L1018) — `kruskal.test(as.formula(formula_str), data = data)` where `formula_str` is built from column names without `jmvcore::asFormula` guard.
- **[D-LOW]** Multiple `setContent(html)` calls (lines 199, 300, 308, 316, 332, 356, 369, 375) build HTML containing variable names and trial-arm strings without `htmltools::htmlEscape`.

#### jmvcore migration

- **[formula]** [`R/advancedraincloud.b.R:1018`](../../R/advancedraincloud.b.R#L1018) — `as.formula(formula_str)` → `jmvcore::asFormula(formula_str)`.
- **[error]** 4 raw `stop()` calls at lines 207, 256, 426, 638 should migrate to `jmvcore::reject(.("..."), code = "")`.

#### Integration

**Arguments declared:** 45 · **used in logic:** ~45 (112 `self$options` reads) · **dead:** 0 detected
**Outputs declared:** 9 · **populated:** 9 (3 `self$data` reads, 11 `self$results`)

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ❌ | n/a | Uses `stop()` and `jmvcore::reject` (no `Notice$new`) |
| Low n / events | STRONG_WARNING | ❌ | n/a | No paired-n guard |
| Assumption violation | STRONG_WARNING | ❌ | n/a | No normality / homogeneity warning |
| Methodology summary | INFO | ❌ | n/a | None at position 999 |

#### Code review

- **Overall quality:** 3/5 stars
- **Architecture:** OK; R6 inherits `advancedraincloudBase`; uses `private$.checkpoint()` at 6 sites
- **Mathematical/statistical correctness:** NOT_EVALUATED
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** PARTIAL (85 `.()` wrappings; no tr.po catalog)

**Top issues:**
1. Formula injection guard missing (line 1018) — see security finding.
2. 4 `stop()` calls should be `jmvcore::reject`.
3. No clinical thresholds (paired-n, normality) surfaced as notices.

#### Recommended remediation

- `/security-audit-function advancedraincloud` (C1 finding)
- `/jamovify-function advancedraincloud --apply` (formula + error groups)
- `/fix-notices advancedraincloud` (missing top-of-results banners)

---

### hullplot

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/hullplot.b.R`](../../R/hullplot.b.R) · [`jamovi/hullplot.a.yaml`](../../jamovi/hullplot.a.yaml) · [`jamovi/hullplot.u.yaml`](../../jamovi/hullplot.u.yaml) · [`jamovi/hullplot.r.yaml`](../../jamovi/hullplot.r.yaml)
**Metrics:** .b.R LOC 836 · options 22 · outputs 7 · String opts 3 · Variable opts 5 · checkpoints 0

#### Security

- **[D-LOW]** Multiple `setContent(html)` calls (lines 213, 257, 263, 269, 275, 282) build HTML containing variable names without `htmltools::htmlEscape`.

#### jmvcore migration

- **[error]** [`R/hullplot.b.R:105`](../../R/hullplot.b.R#L105) and [`:133`](../../R/hullplot.b.R#L133) — `stop("Error: ...")` → `jmvcore::reject(.("..."))`. These are user-facing input validations.

#### Integration

**Arguments declared:** 22 · **used in logic:** ~22 (43 `self$options` reads) · **dead:** 0 detected
**Outputs declared:** 7 · **populated:** 7

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ❌ | n/a | Uses `stop()` only |
| Low n / events | STRONG_WARNING | ❌ | n/a | No cluster-size guard |
| Assumption violation | STRONG_WARNING | ❌ | n/a | None |
| Methodology summary | INFO | ❌ | n/a | None |

#### Code review

- **Overall quality:** 3/5 stars
- **Architecture:** OK; R6 inherits `hullplotBase`; **no `.checkpoint()`** — should add at least one for the hull computation step.
- **Mathematical/statistical correctness:** NOT_EVALUATED
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** NONE (0 `.()` wrappings)

**Top issues:**
1. Zero `.checkpoint()` calls — long hull computations can't be interrupted.
2. No notices at all; all validation through `stop()`.
3. Zero i18n wrapping.

#### Recommended remediation

- `/jamovify-function hullplot --apply` (error group)
- `/fix-notices hullplot`
- `/prepare-translation hullplot`

---

### jjarcdiagram

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjarcdiagram.b.R`](../../R/jjarcdiagram.b.R) · [`jamovi/jjarcdiagram.a.yaml`](../../jamovi/jjarcdiagram.a.yaml) · [`jamovi/jjarcdiagram.u.yaml`](../../jamovi/jjarcdiagram.u.yaml) · [`jamovi/jjarcdiagram.r.yaml`](../../jamovi/jjarcdiagram.r.yaml)
**Metrics:** .b.R LOC 1,180 · options 37 · outputs 7 · String opts 1 · Variable opts 4 · checkpoints 5

#### Security

- **[D-MEDIUM]** [`R/jjarcdiagram.b.R:972`](../../R/jjarcdiagram.b.R#L972) / [`:975`](../../R/jjarcdiagram.b.R#L975) / [`:1082`](../../R/jjarcdiagram.b.R#L1082) / [`:1085`](../../R/jjarcdiagram.b.R#L1085) — `sprintf("<p>...'%s'...</p>", top_node$name, ...)` where `top_node$name` comes from the user-supplied source/target column. A factor level containing markup would render inside an `Html` result. Wrap with `htmltools::htmlEscape()`.

#### jmvcore migration

- **[error]** [`R/jjarcdiagram.b.R:64`](../../R/jjarcdiagram.b.R#L64), [`:148`](../../R/jjarcdiagram.b.R#L148), [`:511`](../../R/jjarcdiagram.b.R#L511) — `stop(...)` → `jmvcore::reject(.("..."))`.

#### Integration

**Arguments declared:** 37 · **used in logic:** 37 (67 reads) · **dead:** 0
**Outputs declared:** 7 · **populated:** 7 (28 `self$results` writes — strong coverage)

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ✅ | ✅ | 6 `NoticeType$ERROR` (lines 144, 296, 314, 338, 366) but inserted at position 999 — should be `insert(1, ...)` |
| Low n / events | STRONG_WARNING | ⚠ | ✅ | Position 2 — close to top; OK |
| Assumption violation | STRONG_WARNING | ⚠ | ⚠ | Density / connectivity warnings present |
| Methodology summary | INFO | ✅ | ✅ | Insert(999) — correct |

#### Code review

- **Overall quality:** 4/5 stars — best-developed notice coverage in module
- **Architecture:** OK; 5 `.checkpoint()` calls
- **Mathematical/statistical correctness:** NOT_EVALUATED (igraph centrality is library-trusted)
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** PARTIAL (130 `.()` wrappings — highest in module)

**Top issues:**
1. ERROR notices at position 999 instead of position 1 — users see results before they see error.
2. Node name interpolation into HTML without escape.
3. Three `stop()` calls that should be `jmvcore::reject`.

#### Recommended remediation

- `/security-audit-function jjarcdiagram` (Category D escalation)
- `/fix-notices jjarcdiagram` (re-position ERROR to insert(1, ...))
- `/jamovify-function jjarcdiagram --pattern=error --apply`

---

### jjbarstats

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjbarstats.b.R`](../../R/jjbarstats.b.R) · [`jamovi/jjbarstats.a.yaml`](../../jamovi/jjbarstats.a.yaml) · [`jamovi/jjbarstats.u.yaml`](../../jamovi/jjbarstats.u.yaml) · [`jamovi/jjbarstats.r.yaml`](../../jamovi/jjbarstats.r.yaml)
**Metrics:** .b.R LOC 1,370 · options 28 · outputs 9 · String opts 1 · Variable opts 4 · Variables opts 1 · checkpoints 6

#### Security

- **[C1-MEDIUM]** [`R/jjbarstats.b.R:617`](../../R/jjbarstats.b.R#L617) and [`:1292`](../../R/jjbarstats.b.R#L1292) — `xtabs(as.formula(formula_str), data = data)` without `jmvcore::asFormula`.
- **[D-LOW]** Bar/group label interpolation into Notice content (lines 786–822) without escape — Notices render plain text in jamovi UI, so risk is lower but pattern should still be reviewed.

#### jmvcore migration

- **[formula]** Lines 617, 1292 — `as.formula(formula_str)` → `jmvcore::asFormula(...)`.
- **[term]** [`R/jjbarstats.b.R:1338`](../../R/jjbarstats.b.R#L1338) and [`:1344`](../../R/jjbarstats.b.R#L1344) — `paste0('\`', dep, '\`')` → `jmvcore::composeTerm(dep)`.
- **[error]** 11 `stop()` calls — should be `jmvcore::reject`.

#### Integration

**Arguments declared:** 28 · **used in logic:** ~28 (159 reads) · **dead:** 0
**Outputs declared:** 9 · **populated:** 9 (18 `self$results` writes; 22 `self$data` reads)

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ✅ | ✅ | Paired-data validation at line 786 — but inserted at position 999 |
| Low n / events | STRONG_WARNING | ⚠ | ⚠ | Has some checks; no chi-square expected-count threshold |
| Assumption violation | STRONG_WARNING | ✅ | ✅ | Pairing assumption check is excellent (line 799) |
| Methodology summary | INFO | ✅ | ✅ | Multiple INFO notices |

#### Code review

- **Overall quality:** 4/5 stars — sophisticated paired-data validation
- **Architecture:** OK; 6 `.checkpoint()` calls; helpers extracted (`.validatePairedData`, `.checkStatisticalAssumptions`)
- **Mathematical/statistical correctness:** NOT_EVALUATED — but McNemar's safety check is genuinely good design.
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** NONE (0 `.()` wrappings)

**Top issues:**
1. Chi-square: no expected-count < 5 → STRONG_WARNING ("consider Fisher's exact").
2. `xtabs(as.formula(...))` lacks asFormula guard.
3. Zero i18n wrapping.

#### Recommended remediation

- `/security-audit-function jjbarstats` (C1)
- `/jamovify-function jjbarstats --apply` (formula + term + error groups)
- `/fix-notices jjbarstats` (re-position ERROR; add chi-square threshold)
- `/prepare-translation jjbarstats`

---

### jjbetweenstats

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjbetweenstats.b.R`](../../R/jjbetweenstats.b.R) · [`jamovi/jjbetweenstats.a.yaml`](../../jamovi/jjbetweenstats.a.yaml) · [`jamovi/jjbetweenstats.u.yaml`](../../jamovi/jjbetweenstats.u.yaml) · [`jamovi/jjbetweenstats.r.yaml`](../../jamovi/jjbetweenstats.r.yaml)
**Metrics:** .b.R LOC 1,264 · options 30 · outputs 10 · String opts 3 · Variable opts 3 · Variables 1 · checkpoints 10

#### Security

- **[D-LOW]** `glue::glue(.("<br> Warning: {var} has less than 3 valid observations<br>"))` at lines 113, 119, 407 — `var` is a column name, not escaped. Renders in `self$results$todo$setContent(combined_message)`.

#### jmvcore migration

- **[error]** Lines 88, 96, 99, 548 — `stop()` → `jmvcore::reject` (4 sites). Lines 96/99 use `glue::glue` interpolation with column names; can switch to `jmvcore::format("{} not found in data. Available: {}", var, available_vars)`.

#### Integration

**Arguments declared:** 30 · **used in logic:** ~30 (132 reads) · **dead:** 0
**Outputs declared:** 10 · **populated:** 10

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ❌ | n/a | Uses `stop()` |
| Low n / events | WARNING | ⚠ | ⚠ | HTML-message-only via `private$.appendMessage`; not a structured Notice |
| Assumption violation | STRONG_WARNING | ❌ | n/a | Welch vs Student / equal-variance not surfaced |
| Methodology summary | INFO | ❌ | n/a | None |

#### Code review

- **Overall quality:** 3/5 stars
- **Architecture:** OK; 10 `.checkpoint()` calls (good coverage of long-running paths)
- **Mathematical/statistical correctness:** NOT_EVALUATED — but ggstatsplot is library-trusted
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** PARTIAL (21 `.()` wrappings)

**Top issues:**
1. Validation through `stop()` instead of structured Notices.
2. Welch/Student/Mann-Whitney choice not surfaced via notice.
3. HTML accumulation via `private$.appendMessage` should be Notices.

#### Recommended remediation

- `/jamovify-function jjbetweenstats --pattern=error --apply`
- `/fix-notices jjbetweenstats`
- `/prepare-translation jjbetweenstats`

---

### jjcorrmat

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjcorrmat.b.R`](../../R/jjcorrmat.b.R) · [`jamovi/jjcorrmat.a.yaml`](../../jamovi/jjcorrmat.a.yaml) · [`jamovi/jjcorrmat.u.yaml`](../../jamovi/jjcorrmat.u.yaml) · [`jamovi/jjcorrmat.r.yaml`](../../jamovi/jjcorrmat.r.yaml)
**Metrics:** .b.R LOC 1,037 · options 21 · outputs 17 · String opts 6 · Variable opts 2 · Variables 1 · checkpoints 4

#### Security

- **[D-LOW]** Lines 498–544 — HTML built via `paste`/`sprintf` with variable names (`options_data$myvars`, `method_display`, etc.). No `htmltools::htmlEscape`.

#### jmvcore migration

- **[na]** [`R/jjcorrmat.b.R:419`](../../R/jjcorrmat.b.R#L419) — `na.omit(cor_data)` → `jmvcore::naOmit(cor_data)`. Loses column attributes for downstream display.
- **[term]** [`R/jjcorrmat.b.R:1012`](../../R/jjcorrmat.b.R#L1012) — `paste0('\`', v, '\`')` → `jmvcore::composeTerm(v)`.

#### Integration

**Arguments declared:** 21 · **used in logic:** ~21 (56 reads) · **dead:** 0
**Outputs declared:** 17 · **populated:** 17 (largest output set in module after jjridges)

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ⚠ | ✅ | Uses `private$.addWarning("ERROR", ...)` — a custom helper, not `Notice$new`; renders into Html, not as Notice banner |
| Low n / events | WARNING | ✅ | ✅ | n < 20 warning present (line 367) — but as "addWarning", not Notice |
| Assumption violation | ❌ | ❌ | ❌ | No normality check for Pearson; no monotonicity check for Spearman |
| Methodology summary | INFO | ✅ | ✅ | `summary`/`about` html setContent |

#### Code review

- **Overall quality:** 3.5/5 stars — has thoughtful n-threshold check
- **Architecture:** OK; uses custom `.addWarning` instead of jmvcore Notices — inconsistent with rest of module
- **Mathematical/statistical correctness:** NOT_EVALUATED — Pearson vs Spearman selection is user-controlled.
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** PARTIAL (65 `.()` wrappings)

**Top issues:**
1. Uses `.addWarning` custom helper rather than `jmvcore::Notice$new` — should harmonize.
2. `na.omit` loses jamovi attributes.
3. No assumption check (normality) for Pearson selection.

#### Recommended remediation

- `/jamovify-function jjcorrmat --pattern=na,term --apply`
- `/fix-notices jjcorrmat` (convert `.addWarning` → `Notice$new`)
- `/review-function jjcorrmat` (statistical: Pearson assumption checks)

---

### jjdotplotstats

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjdotplotstats.b.R`](../../R/jjdotplotstats.b.R) · [`jamovi/jjdotplotstats.a.yaml`](../../jamovi/jjdotplotstats.a.yaml) · [`jamovi/jjdotplotstats.u.yaml`](../../jamovi/jjdotplotstats.u.yaml) · [`jamovi/jjdotplotstats.r.yaml`](../../jamovi/jjdotplotstats.r.yaml)
**Metrics:** .b.R LOC 1,043 · options 22 · outputs 9 · String opts 3 · Variable opts 3 · checkpoints 5

#### Security

- **[D-LOW]** `glue::glue("<br> Warning: {dep_var} has less than 3 valid observations<br>")` lines 546, 551, 569, 651 — dep_var is a column name interpolated into HTML accumulator.

#### jmvcore migration

- **[error]** Zero `stop()` calls (or 0 reject) — uses `private$.accumulateMessage` exclusively. Acceptable, but mixing strategies module-wide.
- Note: function already uses `jmvcore::toNumeric` correctly at 4 sites.

#### Integration

**Arguments declared:** 22 · **used in logic:** ~22 (85 reads) · **dead:** 0
**Outputs declared:** 9 · **populated:** 9

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ❌ | n/a | None |
| Low n / events | WARNING | ⚠ | ✅ | Custom HTML accumulator, not Notice |
| Assumption violation | ❌ | ❌ | ❌ | None |
| Methodology summary | INFO | ❌ | n/a | None |

#### Code review

- **Overall quality:** 3/5 stars
- **Architecture:** OK; 5 `.checkpoint()` calls; helpers extracted
- **Mathematical/statistical correctness:** NOT_EVALUATED
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** NONE (0 `.()` wrappings)

**Top issues:**
1. Zero structured Notices.
2. Zero `.()` wrapping.
3. HTML accumulator pattern (`private$.accumulateMessage`) — should migrate to Notices.

#### Recommended remediation

- `/fix-notices jjdotplotstats`
- `/prepare-translation jjdotplotstats`

---

### jjhistostats

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjhistostats.b.R`](../../R/jjhistostats.b.R) · [`jamovi/jjhistostats.a.yaml`](../../jamovi/jjhistostats.a.yaml) · [`jamovi/jjhistostats.u.yaml`](../../jamovi/jjhistostats.u.yaml) · [`jamovi/jjhistostats.r.yaml`](../../jamovi/jjhistostats.r.yaml) · [`jamovi/js/jjhistostats.events.js`](../../jamovi/js/jjhistostats.events.js)
**Metrics:** .b.R LOC 1,107 · options 36 · outputs 9 · String opts 9 · Variable opts 2 · Variables 1 · checkpoints 5 · JS size 12,827 bytes

#### Security

- **[D-LOW]** Multiple `glue::glue("<br>...<br>")` HTML accumulators; no escape.
- **JS check:** No assignment to `.innerHTML`, no dynamic function constructor, no timed string-eval in `jjhistostats.events.js` — JS is clean.

#### jmvcore migration

- **[term]** [`R/jjhistostats.b.R:1083`](../../R/jjhistostats.b.R#L1083) — `paste0('\`', v, '\`')` → `jmvcore::composeTerm(v)`.
- **[error]** 4 `stop()` calls — migrate to `jmvcore::reject`.

#### Integration

**Arguments declared:** 36 · **used in logic:** ~36 (121 reads) · **dead:** 0
**Outputs declared:** 9 · **populated:** 9 (includes 7 plot variants — large surface)

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ❌ | n/a | None |
| Low n / events | WARNING | ❌ | n/a | None for n < 30 histogram quality |
| Assumption violation | ❌ | ❌ | ❌ | None |
| Methodology summary | INFO | ❌ | n/a | None |

#### Code review

- **Overall quality:** 3/5 stars
- **Architecture:** OK; 5 `.checkpoint()` calls
- **Mathematical/statistical correctness:** NOT_EVALUATED
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** NONE (0 `.()` wrappings)

**Top issues:**
1. 9 String options (highest count after jjridges) — title/xlab/subtitle/etc. — high free-text surface but used only for ggplot annotations (low risk).
2. Zero structured Notices.
3. Zero i18n wrapping.

#### Recommended remediation

- `/jamovify-function jjhistostats --apply`
- `/fix-notices jjhistostats`
- `/prepare-translation jjhistostats`

---

### jjpiestats

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjpiestats.b.R`](../../R/jjpiestats.b.R) · [`jamovi/jjpiestats.a.yaml`](../../jamovi/jjpiestats.a.yaml) · [`jamovi/jjpiestats.u.yaml`](../../jamovi/jjpiestats.u.yaml) · [`jamovi/jjpiestats.r.yaml`](../../jamovi/jjpiestats.r.yaml)
**Metrics:** .b.R LOC 1,500 · options 23 · outputs 10 · String opts 1 · Variable opts 4 · checkpoints 6

#### Security

- **[C1-MEDIUM]** Lines 233, 531, 585, 657, 1440 — `xtabs(as.formula(formula_str), ...)`; line 1474 — `facet_wrap(as.formula(paste("~", group)))`. Six sites total. None protected by `jmvcore::asFormula`.
- **[D-LOW]** glue templates with HTML at lines 180–224, 271, 310, 342, 770, 805, 893, 940. `self$options$dep` and column names interpolated.

#### jmvcore migration

- **[formula]** Six sites — see security findings.
- **[error]** 18 `stop()` calls (highest in module). Strong candidate for batched migration to `jmvcore::reject`.

#### Integration

**Arguments declared:** 23 · **used in logic:** ~23 (104 reads) · **dead:** 0
**Outputs declared:** 10 · **populated:** 10 (32 `self$results` writes; 4 plot renderers)

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ✅ | ⚠ | 14 Notices created; many commented out (`# notice$setContent(...)` debt at lines 128, 407, 430, 684, 838, 850, 865, 877) |
| Low n / events | STRONG_WARNING | ⚠ | ⚠ | Single-level factor check present (line 446) |
| Assumption violation | ⚠ | ⚠ | ⚠ | Has chi-square ratio validation |
| Methodology summary | INFO | ✅ | ✅ | About/summary HTML present |

#### Code review

- **Overall quality:** 3/5 stars — but suffers from heavy commented-out notice code (technical debt).
- **Architecture:** OK; 6 `.checkpoint()` calls
- **Mathematical/statistical correctness:** NOT_EVALUATED — needs review of Bayesian path (`BayesFactor` use)
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** NONE (0 `.()` wrappings)

**Top issues:**
1. 6× `xtabs(as.formula(...))` without `jmvcore::asFormula` guard.
2. 18 `stop()` calls and many commented-out `notice$setContent` lines — clean up + migrate.
3. Zero i18n wrapping despite long user-facing help HTML.

#### Recommended remediation

- `/security-audit-function jjpiestats` (highest C1 hit count)
- `/jamovify-function jjpiestats --apply` (formula + error)
- `/fix-notices jjpiestats` (delete commented dead notice code, re-position ERROR)
- `/prepare-translation jjpiestats`

---

### jjridges

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjridges.b.R`](../../R/jjridges.b.R) · [`jamovi/jjridges.a.yaml`](../../jamovi/jjridges.a.yaml) · [`jamovi/jjridges.u.yaml`](../../jamovi/jjridges.u.yaml) · [`jamovi/jjridges.r.yaml`](../../jamovi/jjridges.r.yaml)
**Metrics:** .b.R LOC 2,139 · options 48 · outputs 26 · String opts 10 · Variable opts 4 · checkpoints 5

**Largest function in module — 2,139 LOC. Consider helper extraction.**

#### Security

- **[D-LOW]** HTML in `setContent` paths (e.g. `private$.addWarning`) with column names; no escape.
- 10 String options including `quantiles`, `custom_colors`, `gradient_low/high`, `plot_title`, etc. — all flow through controlled paths (parsed to numeric or fed to ggplot color/title). LOW.

#### jmvcore migration

- **[na]** [`R/jjridges.b.R:905`](../../R/jjridges.b.R#L905) — `na.omit(plot_data)` → `jmvcore::naOmit(plot_data)`.
- **[term]** Lines 76, 2107, 2113 — `paste0('\`', var, '\`')` → `jmvcore::composeTerm(var)`.
- **[error]** 9 `stop()` calls — migrate to `jmvcore::reject`.

#### Integration

**Arguments declared:** 48 (highest in module) · **used in logic:** ~48 (115 reads) · **dead:** 0
**Outputs declared:** 26 (highest in module) · **populated:** 26 (40 `self$results` writes)

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ⚠ | ⚠ | 7 Notices created; some via custom `.addWarning` helper |
| Low n / events | STRONG_WARNING | ⚠ | ⚠ | `< 2 groups required` guard (line 243) — present |
| Assumption violation | ❌ | ❌ | ❌ | None |
| Methodology summary | INFO | ⚠ | ⚠ | Limited |

#### Code review

- **Overall quality:** 3/5 stars
- **Architecture:** **Concern — 2,139 LOC**. Heavy inline logic, modest helper extraction. Consider splitting plot variants into separate helpers.
- **Mathematical/statistical correctness:** NOT_EVALUATED (uses `effectsize` package for Cohen's d / Hedges' g / Eta² / Omega² — library-trusted)
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** PARTIAL (69 `.()` wrappings)

**Top issues:**
1. .b.R LOC > 2,000 — split into helpers for maintainability.
2. `na.omit` → `jmvcore::naOmit`.
3. 9 `stop()` calls to migrate.

#### Recommended remediation

- `/jamovify-function jjridges --apply`
- `/fix-notices jjridges`
- Consider splitting `.b.R` into 3 files: ridges-core, ridges-plots, ridges-stats (manual refactor).

---

### jjscatterstats

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjscatterstats.b.R`](../../R/jjscatterstats.b.R) · [`jamovi/jjscatterstats.a.yaml`](../../jamovi/jjscatterstats.a.yaml) · [`jamovi/jjscatterstats.u.yaml`](../../jamovi/jjscatterstats.u.yaml) · [`jamovi/jjscatterstats.r.yaml`](../../jamovi/jjscatterstats.r.yaml)
**Metrics:** .b.R LOC 750 · options 37 · outputs 8 · String opts 6 · Variable opts 8 · checkpoints 0

#### Security

*No security findings beyond module-wide D-LOW (HTML escape absent).*

#### jmvcore migration

- **[error]** 1 `stop()` call — migrate to `jmvcore::reject`.

#### Integration

**Arguments declared:** 37 · **used in logic:** ~37 (159 reads — highest density per LOC) · **dead:** 0
**Outputs declared:** 8 · **populated:** 8 (5 plot renderers)

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ❌ | n/a | None |
| Low n / events | WARNING | ❌ | n/a | n < 30 correlation guard missing |
| Assumption violation | ❌ | ❌ | ❌ | Linearity / normality check absent |
| Methodology summary | INFO | ❌ | n/a | None |

#### Code review

- **Overall quality:** 3/5 stars
- **Architecture:** Smaller (750 LOC), but **0 `.checkpoint()` calls** for a plot-heavy function — long ggstatsplot renders cannot be interrupted.
- **Mathematical/statistical correctness:** NOT_EVALUATED
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** NONE (0 `.()` wrappings)

**Top issues:**
1. Zero `.checkpoint()`.
2. Zero Notices.
3. Zero i18n wrapping.

#### Recommended remediation

- `/fix-notices jjscatterstats`
- `/prepare-translation jjscatterstats`
- Manually add `private$.checkpoint()` before each plot render.

---

### jjsegmentedtotalbar

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjsegmentedtotalbar.b.R`](../../R/jjsegmentedtotalbar.b.R) · [`jamovi/jjsegmentedtotalbar.a.yaml`](../../jamovi/jjsegmentedtotalbar.a.yaml) · [`jamovi/jjsegmentedtotalbar.u.yaml`](../../jamovi/jjsegmentedtotalbar.u.yaml) · [`jamovi/jjsegmentedtotalbar.r.yaml`](../../jamovi/jjsegmentedtotalbar.r.yaml)
**Metrics:** .b.R LOC 1,457 · options 36 · outputs 29 (largest output set) · String opts 4 · Variable opts 4 · checkpoints 0

#### Security

*No security findings beyond module-wide D-LOW.*

#### jmvcore migration

- **[error]** Zero `stop()` calls — uses other error paths or none.
- Note: only 1 `self$data` reference — verify data access is centralized.

#### Integration

**Arguments declared:** 36 · **used in logic:** ~36 (96 reads) · **dead:** 0
**Outputs declared:** 29 (highest count) · **populated:** likely all 29 (28 `self$results` writes)

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ❌ | n/a | None |
| Low n / events | WARNING | ❌ | n/a | None |
| Assumption violation | ❌ | ❌ | ❌ | None |
| Methodology summary | INFO | ❌ | n/a | None |

#### Code review

- **Overall quality:** 3/5 stars
- **Architecture:** Large (1,457 LOC), **0 `.checkpoint()` calls** — plot rendering uncancellable.
- **Mathematical/statistical correctness:** NOT_EVALUATED — visualization-only function
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** PARTIAL (25 `.()` wrappings)

**Top issues:**
1. Zero `.checkpoint()` on a 1,457-LOC function.
2. Zero structured Notices.
3. Single `self$data` reference — confirm data path is correct (could be a copied helper pattern).

#### Recommended remediation

- `/check-function-full jjsegmentedtotalbar` (verify data flow; 29-output surface is large)
- `/fix-notices jjsegmentedtotalbar`
- Add `private$.checkpoint()` in plot helpers.

---

### jjwithinstats

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jjwithinstats.b.R`](../../R/jjwithinstats.b.R) · [`jamovi/jjwithinstats.a.yaml`](../../jamovi/jjwithinstats.a.yaml) · [`jamovi/jjwithinstats.u.yaml`](../../jamovi/jjwithinstats.u.yaml) · [`jamovi/jjwithinstats.r.yaml`](../../jamovi/jjwithinstats.r.yaml)
**Metrics:** .b.R LOC 1,350 · options 35 · outputs 8 · String opts 3 · Variable opts 4 · checkpoints 5

#### Security

*No security findings beyond module-wide D-LOW. (Uses `jmvcore::composeTerm` correctly at lines 179, 525, 574, 1163.)*

#### jmvcore migration

- **[error]** 9 `stop()` calls — migrate to `jmvcore::reject`.
- Already uses `jmvcore::naOmit` correctly at lines 660, 1170.

#### Integration

**Arguments declared:** 35 · **used in logic:** ~35 (88 reads) · **dead:** 0
**Outputs declared:** 8 · **populated:** 8

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ❌ | n/a | Uses `stop()` |
| Low n / events | WARNING | ⚠ | ⚠ | HTML message-accumulator pattern |
| Assumption violation (paired) | STRONG_WARNING | ❌ | ❌ | **Critical gap — within-subjects requires paired-design check** |
| Methodology summary | INFO | ❌ | n/a | None |

#### Code review

- **Overall quality:** 3.5/5 stars — best jmvcore adoption in module (composeTerm + naOmit)
- **Architecture:** OK; 5 `.checkpoint()` calls
- **Mathematical/statistical correctness:** NOT_EVALUATED — but uses `private$.appendMessage` for accumulating user feedback
- **Clinical readiness:** NEEDS_VALIDATION (paired-design check missing)
- **i18n coverage:** PARTIAL (55 `.()` wrappings)

**Top issues:**
1. No paired-design assumption check (sphericity for repeated measures).
2. 9 `stop()` calls to migrate.
3. No structured Notices for the user-facing warnings.

#### Recommended remediation

- `/jamovify-function jjwithinstats --pattern=error --apply`
- `/fix-notices jjwithinstats` (sphericity STRONG_WARNING)
- `/review-function jjwithinstats` (statistical: within-subjects assumptions)

---

### jwaffle

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/jwaffle.b.R`](../../R/jwaffle.b.R) · [`jamovi/jwaffle.a.yaml`](../../jamovi/jwaffle.a.yaml) · [`jamovi/jwaffle.u.yaml`](../../jamovi/jwaffle.u.yaml) · [`jamovi/jwaffle.r.yaml`](../../jamovi/jwaffle.r.yaml)
**Metrics:** .b.R LOC 1,098 · options 12 · outputs 5 · String opts 2 · Variable opts 3 · checkpoints 0

#### Security

- **[C1-MEDIUM]** [`R/jwaffle.b.R:959`](../../R/jwaffle.b.R#L959) — `facet_wrap(as.formula(paste0("~", facet_var)))` without `jmvcore::asFormula`.

#### jmvcore migration

- **[formula]** Line 959 — `as.formula(paste0("~", facet_var))` → `jmvcore::asFormula(...)`.
- **[term]** Lines 281, 1051, 1063, 1074 — `paste0('\`', x, '\`')` → `jmvcore::composeTerm(x)`. Note: line 281 already comments "Use jmvcore::composeTerm" but still uses manual paste0 nearby — partial migration left in place.
- **[error]** 14 `stop()` calls — second-highest in module after jjpiestats. Migrate to `jmvcore::reject`.

#### Integration

**Arguments declared:** 12 (smallest in module) · **used in logic:** ~12 (74 reads) · **dead:** 0
**Outputs declared:** 5 · **populated:** 5

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ⚠ | ⚠ | 5 NoticeType refs but only 1 `Notice$new` — inconsistent |
| Low n / events | WARNING | ❌ | n/a | None |
| Assumption violation | ❌ | ❌ | ❌ | None |
| Methodology summary | INFO | ✅ | ✅ | Line 858 todo HTML present |

#### Code review

- **Overall quality:** 3/5 stars
- **Architecture:** OK but **0 `.checkpoint()`** — large dataset waffle renders cannot be interrupted.
- **Mathematical/statistical correctness:** N/A — visualization-only
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** NONE (0 `.()` wrappings)

**Top issues:**
1. `facet_wrap(as.formula(paste0(...)))` C1 finding.
2. 14 `stop()` calls.
3. Partial composeTerm migration left mid-stream (`# Use jmvcore::composeTerm` comment but adjacent manual `paste0('\`', ...)` still present).

#### Recommended remediation

- `/security-audit-function jwaffle` (C1)
- `/jamovify-function jwaffle --apply` (finish term + formula + error migration)
- `/fix-notices jwaffle`
- `/prepare-translation jwaffle`

---

### linechart

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/linechart.b.R`](../../R/linechart.b.R) · [`jamovi/linechart.a.yaml`](../../jamovi/linechart.a.yaml) · [`jamovi/linechart.u.yaml`](../../jamovi/linechart.u.yaml) · [`jamovi/linechart.r.yaml`](../../jamovi/linechart.r.yaml)
**Metrics:** .b.R LOC 1,281 · options 17 · outputs 10 · String opts 4 · Variable opts 3 · checkpoints 4

#### Security

*No specific findings beyond module-wide D-LOW.*

#### jmvcore migration

- **[error]** 7 `stop()` calls — migrate. Uses `jmvcore::reject` at 3 sites (lines 904, 909, 917) — partial adoption.

#### Integration

**Arguments declared:** 17 · **used in logic:** ~17 (63 reads) · **dead:** 0
**Outputs declared:** 10 · **populated:** 10

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ❌ | n/a | None |
| Low n / events | WARNING | ❌ | n/a | None |
| Assumption violation | ❌ | ❌ | ❌ | None |
| Methodology summary | INFO | ❌ | n/a | None |

#### Code review

- **Overall quality:** 3.5/5 stars — most extensive i18n in module
- **Architecture:** OK; 4 `.checkpoint()` calls
- **Mathematical/statistical correctness:** NOT_EVALUATED
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** PARTIAL (152 `.()` wrappings — most in module)

**Top issues:**
1. No structured Notices despite excellent i18n setup.
2. Mix of `stop()` (7) and `jmvcore::reject` (3) — pick one path.
3. No `.po` catalog file to consume the `.()` strings.

#### Recommended remediation

- `/jamovify-function linechart --pattern=error --apply`
- `/fix-notices linechart`
- `/prepare-translation linechart` (extract existing `.()` strings into `.pot`)

---

### lollipop

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/lollipop.b.R`](../../R/lollipop.b.R) · [`jamovi/lollipop.a.yaml`](../../jamovi/lollipop.a.yaml) · [`jamovi/lollipop.u.yaml`](../../jamovi/lollipop.u.yaml) · [`jamovi/lollipop.r.yaml`](../../jamovi/lollipop.r.yaml)
**Metrics:** .b.R LOC 981 · options 23 · outputs 5 · String opts 4 · Variable opts 2 · checkpoints 3

#### Security

*No specific findings beyond module-wide D-LOW.*

#### jmvcore migration

- **[error]** 5 `stop()` calls — migrate.

#### Integration

**Arguments declared:** 23 · **used in logic:** ~23 (55 reads) · **dead:** 0
**Outputs declared:** 5 · **populated:** 5

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ⚠ | ⚠ | 10 NoticeType refs, 2 `Notice$new` — inconsistent |
| Low n / events | WARNING | ❌ | n/a | None |
| Assumption violation | ❌ | ❌ | ❌ | N/A — visualization |
| Methodology summary | INFO | ❌ | n/a | None |

#### Code review

- **Overall quality:** 3/5 stars
- **Architecture:** OK; 3 `.checkpoint()` calls
- **Mathematical/statistical correctness:** N/A — visualization
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** PARTIAL (38 `.()` wrappings)

**Top issues:**
1. Inconsistent NoticeType usage (10 enum refs, only 2 `$new` calls — some Notices may not be reachable).
2. 5 `stop()` calls.
3. No `.po` catalog.

#### Recommended remediation

- `/fix-notices lollipop`
- `/jamovify-function lollipop --pattern=error --apply`
- `/prepare-translation lollipop`

---

### raincloud

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/raincloud.b.R`](../../R/raincloud.b.R) · [`jamovi/raincloud.a.yaml`](../../jamovi/raincloud.a.yaml) · [`jamovi/raincloud.u.yaml`](../../jamovi/raincloud.u.yaml) · [`jamovi/raincloud.r.yaml`](../../jamovi/raincloud.r.yaml)
**Metrics:** .b.R LOC 958 · options 29 · outputs 7 · String opts 3 · Variable opts 4 · checkpoints 5

#### Security

- **[C1-MEDIUM]** [`R/raincloud.b.R:302`](../../R/raincloud.b.R#L302) — `facet_wrap(as.formula(paste("~", facet_safe)))` without `jmvcore::asFormula`.
- **[C1-MEDIUM]** [`R/raincloud.b.R:777`](../../R/raincloud.b.R#L777) — `aov(as.formula(formula_str), data = data)` — formula injection risk via column names.
- **[C1-MEDIUM]** [`R/raincloud.b.R:790`](../../R/raincloud.b.R#L790) — `kruskal.test(as.formula(formula_str), ...)`.

#### jmvcore migration

- **[formula]** Lines 302, 777, 790 — three sites.
- **[error]** 2 `stop()` calls. Uses `jmvcore::reject` correctly at 5 sites (best adoption alongside advancedraincloud).

#### Integration

**Arguments declared:** 29 · **used in logic:** ~29 (68 reads) · **dead:** 0
**Outputs declared:** 7 · **populated:** 7

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ❌ | n/a | Uses `jmvcore::reject` (acceptable substitute) |
| Low n / events | WARNING | ❌ | n/a | None |
| Assumption violation | ❌ | ❌ | ❌ | aov/Kruskal choice not surfaced |
| Methodology summary | INFO | ❌ | n/a | None |

#### Code review

- **Overall quality:** 3.5/5 stars — clean jmvcore::reject adoption
- **Architecture:** OK; 5 `.checkpoint()` calls
- **Mathematical/statistical correctness:** NOT_EVALUATED — performs aov / Kruskal-Wallis
- **Clinical readiness:** NEEDS_VALIDATION
- **i18n coverage:** PARTIAL (20 `.()` wrappings)

**Top issues:**
1. Three C1 formula injection sites.
2. aov vs Kruskal-Wallis choice not surfaced as INFO notice.
3. No `.po` catalog.

#### Recommended remediation

- `/security-audit-function raincloud` (C1 — 3 sites)
- `/jamovify-function raincloud --pattern=formula --apply`
- `/review-function raincloud` (aov/Kruskal choice)

---

### statsplot2

**Status:** ⚠️ NEEDS WORK
**Files:** [`R/statsplot2.b.R`](../../R/statsplot2.b.R) · [`jamovi/statsplot2.a.yaml`](../../jamovi/statsplot2.a.yaml) · [`jamovi/statsplot2.u.yaml`](../../jamovi/statsplot2.u.yaml) · [`jamovi/statsplot2.r.yaml`](../../jamovi/statsplot2.r.yaml)
**Metrics:** .b.R LOC 1,491 · options 9 (smallest in module) · outputs 2 (smallest) · String opts 0 · Variable opts 3 · checkpoints 7

#### Security

*No specific findings beyond module-wide D-LOW.*

#### jmvcore migration

- **[error]** 3 `stop()` calls.
- Uses `jmvcore::naOmit` correctly at line 987.

#### Integration

**Arguments declared:** 9 · **used in logic:** ~9 (33 reads) · **dead:** 0
**Outputs declared:** 2 (1 plot, 1 todo) · **populated:** 2

#### Notices coverage

| Trigger | Type | Present? | Quantified? | Notes |
|---|---|:---:|:---:|---|
| Missing required inputs | ERROR | ✅ | ✅ | 24 NoticeType refs, 12 `Notice$new` — most diverse in module |
| Low n / events | WARNING | ⚠ | ⚠ | Heuristic-based |
| Assumption violation | ⚠ | ⚠ | ⚠ | Variable-type-based dispatch warnings |
| Methodology summary | INFO | ✅ | ✅ | Auto-selected plot type info |

#### Code review

- **Overall quality:** 4/5 stars — most diverse error/notice handling
- **Architecture:** OK; 7 `.checkpoint()` calls (most in module)
- **Mathematical/statistical correctness:** NOT_EVALUATED — auto-dispatches to ggstatsplot variants
- **Clinical readiness:** NEEDS_VALIDATION (auto-plot selection logic needs review for correct heuristics)
- **i18n coverage:** NONE (0 `.()` wrappings) — surprising given otherwise good design

**Top issues:**
1. Zero i18n wrapping in the function with the most notices.
2. 3 `stop()` calls to migrate.
3. Auto-plot-selection heuristics need clinical validation.

#### Recommended remediation

- `/prepare-translation statsplot2` (especially worthwhile since notices are detailed)
- `/jamovify-function statsplot2 --pattern=error --apply`
- `/review-function statsplot2` (auto-selection logic)

---

## Cross-Cutting Issues

### D-MEDIUM — 18 functions

No `htmltools::htmlEscape` is called anywhere in the module. Every `setContent(html)` payload that interpolates a variable name, factor level, or user-data string is a potential rendered-XSS vector. While the most-frequently-flowing source is a column name (MEDIUM tier), the absence of escape is module-wide.

**Affected functions:** all 18.

**Reference fix pattern:** Use `htmltools::htmlEscape(varname)` before paste into HTML. See `R/tableone.b.R` and `R/alluvial.b.R` in the umbrella module for canonical examples.

**Run per function:** `/security-audit-function <name>` to confirm reachability and apply targeted escapes.

### C1-MEDIUM — 6 functions (13 sites)

Six functions construct R formulas by paste-concatenation of column names and pass them to `as.formula()` without the modern `jmvcore::asFormula` allow-list parse-time guard.

**Affected sites:**

- [`R/advancedraincloud.b.R:1018`](../../R/advancedraincloud.b.R#L1018) — `kruskal.test`
- [`R/jjbarstats.b.R:617`](../../R/jjbarstats.b.R#L617), [`:1292`](../../R/jjbarstats.b.R#L1292) — `xtabs`
- [`R/jjpiestats.b.R:233`](../../R/jjpiestats.b.R#L233), [`:531`](../../R/jjpiestats.b.R#L531), [`:585`](../../R/jjpiestats.b.R#L585), [`:657`](../../R/jjpiestats.b.R#L657), [`:1440`](../../R/jjpiestats.b.R#L1440), [`:1474`](../../R/jjpiestats.b.R#L1474) — `xtabs` and `facet_wrap`
- [`R/raincloud.b.R:302`](../../R/raincloud.b.R#L302), [`:777`](../../R/raincloud.b.R#L777), [`:790`](../../R/raincloud.b.R#L790) — `facet_wrap`, `aov`, `kruskal.test`
- [`R/jwaffle.b.R:959`](../../R/jwaffle.b.R#L959) — `facet_wrap`

**Reference fix pattern:** `jmvcore::asFormula(formula_str)` (jamovi 2.7.27+). Function still parses the string but enforces a curated whitelist of allowed R functions.

**Run per function:** `/security-audit-function <name>` and then `/jamovify-function <name> --pattern=formula --apply`.

### jmvcore/error — 16 functions (96 `stop()` sites)

Only 4 functions adopt `jmvcore::reject` consistently (advancedraincloud, raincloud, linechart, partially jjpiestats). The remaining 14 use bare `stop()` which surfaces R-level errors with raw tracebacks instead of friendly jamovi Notice banners.

**Highest counts:**

- `jjpiestats` — 18 `stop()` calls
- `jwaffle` — 14
- `jjbarstats` — 11
- `jjridges` — 9
- `jjwithinstats` — 9
- `linechart` — 7

**Reference fix pattern:** `jmvcore::reject(.("Variables required: {}", paste(missing, collapse=", ")), code = "")`.

**Run per function:** `/jamovify-function <name> --pattern=error --apply`.

### jmvcore/term — 6 functions (10+ sites)

Manual backtick wrapping `paste0('\`', var, '\`')` instead of `jmvcore::composeTerm()`. Works for simple names but is wrong for interaction terms or names with embedded backticks.

**Affected sites:** `jjbarstats:1338, 1344`; `jjcorrmat:1012`; `jjhistostats:1083`; `jjridges:76, 2107, 2113`; `jwaffle:1051, 1063, 1074`.

**Run per function:** `/jamovify-function <name> --pattern=term --apply`.

### jmvcore/na — 2 sites

- [`R/jjcorrmat.b.R:419`](../../R/jjcorrmat.b.R#L419) — `na.omit(cor_data)` → `jmvcore::naOmit(cor_data)`
- [`R/jjridges.b.R:905`](../../R/jjridges.b.R#L905) — `na.omit(plot_data)` → `jmvcore::naOmit(plot_data)`

Why it matters: jamovi columns carry `measureType`, `values`, and label attributes; `na.omit` strips them, breaking factor-label display in downstream tables.

**Run per function:** `/jamovify-function <name> --pattern=na --apply`.

### i18n — 18 functions

No `jamovi/i18n/` directory exists. No `catalog.pot`, `en.po`, or `tr.po`.

- **8 functions with zero `.()` wrapping** — hullplot, jjbarstats, jjdotplotstats, jjhistostats, jjpiestats, jjscatterstats, jwaffle, statsplot2.
- **10 functions with partial wrapping** — `linechart` is the most extensively wrapped (152 calls), but with no catalog file the wrappers do nothing.

**Run per function:** `/prepare-translation <name>` — generates the `.po`/`.pot` infrastructure and wraps remaining strings.

### notices/positioning — module-wide

64 Notices in the module; the breakdown by position:

- `insert(1, ...)` — 0 occurrences (ERROR banner at very top)
- `insert(2, ...)` — small number (jjarcdiagram)
- `insert(999, ...)` — 45 occurrences (INFO at bottom, occasionally ERROR misplaced)

**Specific misplacement:** `jjarcdiagram` lines 147, 299, 317, 341, 369 use `insert(999, errorNotice)` — ERROR notices that should be at `insert(1, ...)` so the user sees them before any results render.

**Run per function:** `/fix-notices <name>` — repositions ERROR/STRONG_WARNING to top, INFO/WARNING contextually.

### code-quality / size — 11 functions

`.run()` (or .b.R total) exceeds 1,000 LOC in 11 of 18 functions. Largest:

- `jjridges` — 2,139 LOC
- `jjpiestats` — 1,500
- `statsplot2` — 1,491
- `jjsegmentedtotalbar` — 1,457
- `jjbarstats` — 1,370
- `jjwithinstats` — 1,350
- `linechart` — 1,281
- `jjbetweenstats` — 1,264
- `jjarcdiagram` — 1,180
- `jjhistostats` — 1,107
- `jwaffle` — 1,098

Splitting plot-variant branches into private helpers would substantially improve maintainability. This is a refactor recommendation, not a defect.

### Operational hygiene — clean

- **0** `library()` calls in `R/*.b.R` ✅
- **0** debug-flag constants hardcoded `TRUE` ✅
- **0** runtime-expression-evaluation sinks (Category A) ✅
- **0** filesystem / network calls (`system`, `download.file`, etc.) ✅
- **0** top-level executable code outside R6 class bodies ✅
- **All 18** classes correctly inherit `<name>Base` ✅
- **`jamovi/js/jjhistostats.events.js`** — no DOM-html-property assignment, no dynamic function constructor, no timer-string-eval ✅

---

## Remediation Playbook

**Priority 1 — C1 formula-injection guard (HIGHEST among MEDIUM findings):**

Per function (sequential, each requires the auditor's approval gate via `/security-audit-function`):

```
/security-audit-function jjpiestats        # 6 sites
/security-audit-function raincloud         # 3 sites
/security-audit-function jjbarstats        # 2 sites
/security-audit-function jwaffle           # 1 site
/security-audit-function advancedraincloud # 1 site
/security-audit-function jjarcdiagram      # D-MEDIUM HTML escape
```

**Priority 2 — Module-wide jmvcore migration (batch-safe, no approval gate):**

```
/jamovify-function advancedraincloud --apply
/jamovify-function hullplot --apply
/jamovify-function jjarcdiagram --apply
/jamovify-function jjbarstats --apply
/jamovify-function jjbetweenstats --apply
/jamovify-function jjcorrmat --apply
/jamovify-function jjhistostats --apply
/jamovify-function jjpiestats --apply
/jamovify-function jjridges --apply
/jamovify-function jjwithinstats --apply
/jamovify-function jwaffle --apply
/jamovify-function linechart --apply
/jamovify-function lollipop --apply
/jamovify-function raincloud --apply
/jamovify-function statsplot2 --apply
```

(`hullplot`, `jjdotplotstats`, `jjscatterstats`, `jjsegmentedtotalbar` either have no migration opportunities or only error-group items.)

**Priority 3 — Notice coverage and positioning:**

```
/fix-notices jjarcdiagram   # ERROR misplaced at 999 — move to 1
/fix-notices jjbarstats     # add chi-square expected-count guard
/fix-notices jjwithinstats  # add sphericity STRONG_WARNING
/fix-notices jjcorrmat      # add normality guard for Pearson
/fix-notices jjpiestats     # delete commented dead notices; reposition ERROR
/fix-notices <each remaining>
```

**Priority 4 — i18n preparation:**

```
# Generate jamovi/i18n/ infrastructure first
/prepare-translation linechart    # has most .() wrappers; will scaffold catalog
# Then for each function with i18n=NONE:
/prepare-translation hullplot
/prepare-translation jjbarstats
/prepare-translation jjdotplotstats
/prepare-translation jjhistostats
/prepare-translation jjpiestats
/prepare-translation jjscatterstats
/prepare-translation jwaffle
/prepare-translation statsplot2
```

**Priority 5 — Statistical/clinical review (deeper than this audit):**

```
/review-function jjcorrmat       # Pearson/Spearman assumption surface
/review-function jjwithinstats   # sphericity / within-subjects design
/review-function raincloud       # aov / Kruskal-Wallis choice
/review-function jjbarstats      # McNemar / Fisher's thresholds
/review-function statsplot2      # auto-plot heuristic correctness
```

**Priority 6 — Architectural refactor (manual, deferrable):**

Consider splitting these `.b.R` files into helper files:

- `R/jjridges.b.R` (2,139 LOC) → split plot variants
- `R/jjpiestats.b.R` (1,500 LOC) → split Bayesian path
- `R/statsplot2.b.R` (1,491 LOC) → split auto-selection logic

---

## Appendix: Guides Referenced

- `references/security-patterns.md` — Categories A, B, C, D, E, H, I scanned across 18 functions
- `references/jmvcore-migration.md` — formula / na / numeric / error / term / source groups
- `references/integration-checks.md` — 9 checks per function
- `references/notices-checklist.md` — clinical thresholds + position policy
- `references/code-review-checks.md` — i18n + statistical correctness placeholders

For canonical jamovi developer documentation, see <https://dev.jamovi.org>.

---

*Generated by the `audit-module` skill on 2026-05-14 at 18:44. Re-run with `--profile deep` or `--functions a,b,c` to produce a targeted re-audit. No source files were modified by this audit.*
