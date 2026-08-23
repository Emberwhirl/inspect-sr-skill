# Domain 4: Inspecting results in the study

## What this domain asks

Ask whether numbers inside the index study (and across its publications) can exist. Several checks need statistical competence; 4.3, 4.5, and 4.7 also need clinical/biological domain knowledge. Revisit **4.7** at meta-analysis / forest-plot stage. Each check **contributes to** the domain judgement.

| Check | Question |
|-------|----------|
| **4.1** | Are there any unexplained discrepancies between reported data and participant eligibility criteria? |
| **4.2** | Are numbers of participants allocated to each group implausible given the allocation method? |
| **4.3** | Are any baseline data implausible? |
| **4.4** | Are there any discrepancies between results reported in figures, tables, and text? |
| **4.5** | Are the numbers of participants lost to follow-up implausible? |
| **4.6** | Are there any unexplained inconsistencies in the numbers of participants? |
| **4.7** | Are any outcome data, including estimated treatment effects, implausible? |
| **4.8** | Are the means and variances of integer data impossible? |
| **4.9** | Are there errors in statistical results? |
| **4.10** | Are any other contradictions implied by the data? |
| **4.11** | Are there inconsistencies in descriptions of methods and results across publications describing the study? |

---

## 4.1 Unexplained discrepancies between reported data and eligibility criteria

Check whether any **participant-characteristic** results are incompatible with eligibility. **It is crucial** to see whether the manuscript **explains** them.

**Worked example**: Trial in postmenopausal women; baseline table lists sex; a **substantial portion** of both arms described as male; no explanation → `Yes`.

---

## 4.2 Allocation counts vs stated method

Check whether arm ns are plausible under the **stated** allocation method. **Simple randomisation usually yields unequal ns** (equal is possible). In a **two-arm, single-centre** trial with **blocked randomisation, fixed block size, no stratification**, imbalance **cannot exceed half the block size**. Authors may have **described the method incorrectly**. Basic understanding of randomisation is required.

**Worked example**: Single centre, blocked, fixed block size 4, no stratification; control has **5** more participants than intervention; maximum possible imbalance is **2** → `Yes`.

---

## 4.3 Implausible baseline data

Plausibility includes **clinical/biological** (needs domain knowledge) **and numerical**. Trial participants are **not expected to be “typical”** of a population; even a representative sample will wander by chance — that is **not** a problem.

Consider magnitude, frequency, variance, and **repetition of values** for distinct measurements. Known problematic patterns: excess of even or odd numbers; excess of **multiples of 5**.

**Formal baseline-balance tests**: may be useful when the user understands the method; they **malfunction if misused** and can create spurious concerns. **Routine use by non-experts is not recommended.**

**Digit-distribution / Benford**: **routine use is not recommended.** Benford’s law is **not expected to be valid** for most RCT baseline variables.

This caution extends to tooling. The `reappraised` package implements several of these methods (`match_fn`, `cohort_fn`, `anova_fn`, `final_digit_fn`, `cat_fn`, `pval_cat_fn`) and they are designed for **groups of trials** rather than the single index study INSPECT-SR assesses. Do not reach for them here. Only the rounding check, exposed through `scripts/baseline_scan.R`, is in scope.

Unusual values may be **reporting errors** (e.g. SEs printed as SDs). That may **not** be a trustworthiness concern but **must be corrected** if the data enter a meta-analysis.

**Worked example**: Identical means, SDs, or range limits in both groups for **nine of 11** baseline characteristics, to two decimal places; simple randomisation — cloning unlikely → `Yes`.

---

## 4.4 Figure, table, and text mismatches

Check contradictions where the **same results** appear in figures, tables, main text, **abstract**. Include **numbers of participants described vs plotted**.

**Worked example**: Bar-chart means clearly inconsistent with the corresponding text → `Yes`.

---

## 4.5 Implausible loss to follow-up

Judge whether attrition is plausible given **context, condition, follow-up duration, and protocol** (domain knowledge). Consider **incentives** that could explain low attrition.

If the **sample-size calculation anticipated substantial attrition** and the trial reports little or none with **no explanation**, that may lead to concerns.

**Round, equal losses**, or losses that produce a **perfect match to planned N**, may **suggest** problems but are **unlikely sufficient** unless other problematic features are also present.

**Worked example**: Multicentre psychotherapy vs usual care for long-term depression; on-site visits every 3 months for 18 months; N=524; **zero loss at all sites**; attrition typically high in this population even with shorter follow-up → `Yes`.

---

## 4.6 Unexplained inconsistencies in participant numbers

Check n reported in different parts of the manuscript. Do **not** treat as unexplained: **loss to follow-up** or **exclusion for non-adherence**. Use **CONSORT**. **Note** large unexplained discrepancies with **planned** sample size.

**Worked examples**:
- 100 randomised (text + baseline; exhaustive categoricals sum to 100); outcomes on **>150** → `Yes`.
- Sample-size calculation for 40; results on **more than twice** that many; no explanation → `Yes`.

---

## 4.7 Implausible outcome data, including estimated treatment effects

**Reconsider at meta-analysis**: forest plots may highlight highly implausible results.

Plausibility of arm outcome values and treatment effects includes **clinical/biological** (domain knowledge) **and statistical**. Consider magnitude, frequency, variance, and repetition in tables.

Do **not** over-interpret a **point estimate** without CIs/p-values. A large effect is **not necessarily unusual** if CIs are **wide**.

A significant result for a treatment with **no plausible mechanism is not a concern on its own**. Type 1 errors are expected under the null.

Compare estimates and CIs with **other studies in a meta-analysis**. Pooling may happen **after** the first trustworthiness pass — **revisit 4.7** if problems appear then.

**Duplication of estimated treatment effects between trials** may be implausible, especially across **multiple** outcomes.

**Worked examples**:
- Two trials, same team, **identical** treatment-effect point estimates; several other outcomes identical or nearly identical → `Yes`.
- Three trials from one team vs ten others: **more than a 6-fold** gap between the lowest lower-CI of the three and the upper-CI of the pooled ten → `Yes`.

---

## 4.8 Impossible means and variances of integer data

**Only** variables that can take integer values (1, 2, 3, …). For those, only certain mean and SD values are possible at a given n. Use **GRIM** and **GRIMMER**.

- **Percentages**: GRIM (**not** GRIMMER) if derived from integer counts (e.g. number of patients in a group).
- **Time** (age in years, duration in months): GRIM/GRIMMER **only if recorded in whole units**.
- Inconsistencies may reflect **missing data / smaller n**. Still problematic if you would use the result in the review, or if inconsistencies are **numerous** enough to doubt accuracy generally.
- Consult a **statistician** to verify judgement.

**Compute it**: `Rscript scripts/grim_grimmer.R --n 30 --mean 9.93 --sd 0.18`, which wraps the same `scrutiny` package the official checker is built on. Note that `scrutiny` reports a known bug in which GRIMMER's **test 3** can flag consistent values as inconsistent; the script marks those `INCONSISTENT (unreliable)` and they must not on their own support a `Yes`.

**Official tools** (for the human reviewer): [INSPECT-SR means/variances checker](https://errors.shinyapps.io/inspect-sr-means-variances/) (Jung & Hussey; `scrutiny`); [scrutiny app](https://errors.shinyapps.io/scrutiny/).

**Worked example**: Apgar 0–10 at 1 and 5 minutes; n=30; means 8.96 and 9.96 impossible; mean 9.93 with SD 0.18 impossible. **Several** impossible combinations → `Yes`.

**Avoid**: GRIM on continuous/non-integer recording; GRIMMER on percentages.

---

## 4.9 Errors in statistical results

Check whether analysis results are **consistent with** reported summaries.

**Continuous t-tests — rounding (v1.1.2):** Do **not** reconstruct t-test *p*-values by putting rounded means/SDs into a calculator **unless that calculator explicitly handles rounding**. Continuous *p*-values will **not generally be exactly reproducible** from rounded summaries. Ask whether the *p* is **consistent with**, not exactly equal to, the rounded data.

**Compute it**: `Rscript scripts/pval_check.R continuous --n1 30 --mean1 20 --sd1 4 --n2 30 --mean2 21 --sd2 2 --reported 0.02` returns the interval of *p*-values the reported rounding permits, and says whether the reported value falls inside it. Equivalent to Bolland’s app: https://reappraised.shinyapps.io/check_p_vals_cont/.

**Scan the whole table**: `Rscript scripts/baseline_scan.R --csv baseline.csv` runs the same rounding check over every row at once, via Bolland’s own `reappraised` package. Because 4.9 is a study-level check that should sample the baseline table and not just the review outcomes, this is usually the more faithful way to run it.

Non-parametric continuous tests typically **cannot** be checked from summaries.

**Categorical** (χ² or similar, frequencies reported): you **may** reproduce *p* from the counts (no rounding issue). Authors may have used **variants** (Yates; unequal-variance t). If you find a discrepancy, consider those. **Compute it**: `Rscript scripts/pval_check.R categorical --table "12,38,7,43" --reported 0.31` tries chi-squared with and without Yates' correction and Fisher exact, and names the closest test when none match. Tools: [OpenEpi](https://www.openepi.com/Menu/OE_Menu.htm); Bolland categorical app https://reappraised.shinyapps.io/check_p_vals_cat/ (range of tests). The guidance also lists a [GraphPad t-test calculator](https://www.graphpad.com/quickcalcs/ttest1/?format=sd); do not use an ordinary t-test calculator as a Yes trigger unless it accounts for rounding.

If **all** continuous statistical results can be **exactly** reproduced from rounded summaries, that **may indicate no underlying dataset**.

Checking every test may be impracticable; then check a **selection from baseline and results tables**.

Some discrepancies may be **undisclosed covariate adjustment**.

This is a **study-level** check, not outcome-level. Include review outcomes, but **do not restrict** to them. Sample the baseline table. **Do not be reassured** by clean review outcomes plus errors elsewhere — a fabricator may tidy the key outcomes.

**Worked examples**:
- n=30 vs 30; means 20 vs 21; SDs 4 vs 2; reported p=0.02. Naive t-test on those summaries ≈0.23. Rounding-extreme means 19.5 vs 21.449 and SDs 3.5 vs 1.5 give p=0.006, **smaller** than 0.02 — so the reported *p* is **consistent**. If no other statistical errors → `No`.
- Table 1 sex 2×2 with **two** p-values (male and female). Neither matches χ² or plausible alternatives. This is **one of several** errors in the manuscript → `Yes`.

---

## 4.10 Other contradictions implied by the data

Overflow for contradictions **not caught by 4.1–4.9**. The listed types occur **too infrequently to warrant routine checking**; record them **if observed**:

- Subgroup counts or means conflict with the overall cohort.
- A mean falls **outside a reported range**.
- Impossible outcome combinations (guidance: more **birth events** — birth of at least one child — than **pregnancies**).

**Compute it**: `Rscript scripts/consistency.R subgroups --n "30,11" --mean "6.2,7.4" --overall 7.3` does the recombination and pushes rounding to the authors' advantage before declaring anything impossible.

**Worked example**: Intervention n=41; age <65 n=30 mean 6.2; ≥65 n=11 mean 7.4; overall mean 7.3. Recombination (6.2×30 + 7.4×11)/41 = 6.52. Most generous rounding (6.2499 and 7.499) → 6.57, still incompatible with 7.3 even if 7.3 was rounded up → `Yes`.

---

## 4.11 Inconsistencies across publications describing the study

Check **major unexplained** discrepancies between associated publications (e.g. conference abstract vs main results paper). Conflicting **results, group sizes, or methods** could warrant concerns. Requires the full index-study dossier (see SKILL.md).

**Worked example**: Abstract of the completed trial vs manuscript: methods, eligibility, and dates match; manuscript **sample size considerably larger**; no explanation → `Yes`.

---

## Reaching the domain judgement

No Yes-count. Integer impossibility (4.8) and rounding-aware 4.9 are proofs of inconsistency, not automatic overall serious unless the problem (alone or combined) compromises trustworthiness. Sample Domain 4; do not skip 4.11 because the domain is long.

## See also

- **[scripts/README.md](../../scripts/README.md)**: computing 4.8, 4.9, 4.10 and percentage checks.
- **SKILL.md**: Repeat 4.7 at synthesis; statistical competence on the team.
- **Domain 1**: Author-team sister trials.
- **Domain 2**: CONSORT, dates, and planned N.
