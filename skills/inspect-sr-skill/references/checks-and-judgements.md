# INSPECT-SR Checks and Judgements

## Response Options

Use `Yes`, `No`, `Unclear`, or `Not applicable` for each check. `Yes` indicates a potentially problematic feature. Do not escalate automatically from one `Yes`; judge severity from the nature, extent, and explanation of the issue.

Use `No concerns`, `Some concerns`, or `Serious concerns` for each domain and overall. Overall judgement should usually be at least as severe as the most severe domain judgement. Several `Some concerns` domains may justify `Serious concerns` overall if they substantially lower confidence.

For every response, record:

- source(s) checked;
- exact reported data or wording, where relevant;
- whether the answer is direct evidence, inference, unresolved uncertainty, or author clarification;
- what evidence would change the response.

Avoid using INSPECT-SR as a scoring tool. It is a structured judgement framework.

INSPECT-SR is not a diagnostic test for fraud, and trustworthiness concerns do not constitute an accusation of misconduct. Do not assess risk of bias, generalisability, conflicts of interest, adherence to reporting standards, or outcome reporting bias under INSPECT-SR unless the issue also creates a trustworthiness concern covered by a check.

## Domain 1: Post-Publication Notices

1.1 Retraction: Check journal pages and the Retraction Watch database. Search by DOI when possible because names and titles may contain errors. A retracted, removed, or withdrawn main report usually warrants serious concerns. Repeat close to review completion because notices can appear during the review. If a retracted report was replaced by a corrected version, assess the replacement.

1.2 Expression of concern or other notice: Check journal notices, Retraction Watch, PubPeer, letters, corrections, comments, and publisher notes. Consider relevance to trustworthiness rather than treating any comment as decisive. If a notice says an investigation is ongoing, revisit the journal page close to review completion.

1.3 Other studies by the research team: Search first, corresponding, and senior authors for retractions or integrity-related notices. Consider author role, contribution statement, and whether notices concern data integrity, honest error, duplicate publication, or unrelated issues.

## Domain 2: Conduct, Governance, and Transparency

2.1 Ethical approval: Look for committee name, approval number, date, and informed consent. Compare approval date with recruitment dates. If an approval number is reported, search it online to see whether it appears to belong to an unrelated study. Partial information may be `Unclear`; verify if feasible. If ethics documents are supplied by authors, distinguish them from public registry records.

2.2 Study registration: Consider whether absence or timing of registration prevents verification of planned methods. Do not treat lack of registration as an automatic concern; consider study date, jurisdiction, field norms, and available protocol/ethics documents. Retrospective registration may still be useful but cannot verify prospective planning.

2.3 Registration-publication consistency: If registration exists, compare first posted/pre-recruitment versions and change history with publications. Focus on sample size, interventions, dates, eligibility, outcomes, and analysis populations. If no registration exists, use `Not applicable` and consider protocol/ethics documents elsewhere.

2.4 Recruitment plausibility: Compare recruited sample size and timeframe with site capacity, disease frequency, screening pool, staff availability, and follow-up requirements. Do not confuse total study duration with recruitment period.

2.5 Methods/resources plausibility: Consider whether reported visits, procedures, staffing, funding, assessments, equipment, monitoring, and logistics are feasible for the setting.

## Domain 3: Text and Figures

3.1 Duplicated or incompatible text/tables: Look for copied, tortured, or context-incompatible text. Reused text across legitimate reports of the same study is not automatically concerning. If author clarification resolves study identity, move residual concerns about dates, arm sizes, or outcomes to Domain 4 rather than leaving them here.

3.2 Figure manipulation or duplication: Inspect plots, images, survival curves, and multi-panel figures for duplication, shifted curves, false error bars, reused panels, or inconsistent sample sizes. If no figures exist, use `Not applicable`.

## Domain 4: Results in the Study

4.1 Eligibility-data discrepancies: Check whether baseline data contradict eligibility criteria, such as age outside range, wrong sex/population, disease stage excluded by protocol, or laboratory values incompatible with inclusion/exclusion.

4.2 Allocation numbers: Compare arm sizes with reported randomization method. Consider simple randomization, block size, stratification, unequal ratios, early stopping, partial recruitment, and whether an extended report added participants symmetrically. For blocked randomisation with a fixed block size and no stratification, an imbalance cannot exceed half the block size. A surprising allocation pattern may be `Unclear` rather than `Yes` if the exact allocation method is missing.

4.3 Baseline data plausibility: Assess clinical/numerical plausibility, repeated values, digit patterns, impossible ranges, unusual balance, identical means/SDs across many variables, and variables inconsistent with disease biology. Do not routinely use baseline-balance or Benford-type checks unless the reviewer has appropriate methodological expertise; these can create spurious concerns.

4.4 Results across text/tables/figures: Check repeated results for contradictions across abstracts, main text, tables, figures, supplements, and registry results.

4.5 Loss to follow-up: Judge whether attrition is plausible for the condition, follow-up length, incentives, setting, and outcome collection method. Complete follow-up can be plausible in short trials but should be explained in demanding or long studies.

4.6 Participant-number consistency: Check totals across abstract, methods, CONSORT flow, baseline tables, outcome tables, supplements, registry results, and author correspondence. For extended reports, reconcile preliminary and final datasets explicitly.

4.7 Outcome plausibility: Assess whether outcomes, event rates, treatment effects, variances, and confidence intervals are clinically and statistically plausible. Revisit after meta-analysis if a forest plot shows an outlier or duplicated effect patterns. Do not overinterpret a large point estimate without its uncertainty; false positive results can occur even when an intervention has no plausible mechanism.

4.8 Impossible means/variances for integer data: Use GRIM/GRIMMER logic where integer variables, sample size, means, and variances are reported. Percentages can be tested with GRIM if they derive from integer counts. Account for rounding, missing data, and whether the variable is truly integer-valued. Official guidance lists these tools: INSPECT-SR consistency checker for means and variances (`https://errors.shinyapps.io/inspect-sr-means-variances/`), scrutiny (`https://errors.shinyapps.io/scrutiny/`), and Nick Brown's GRIM calculator (`http://nickbrown.fr/GRIM`).

4.9 Statistical errors: Recalculate selected p-values or effects from reported counts or summary data. For continuous rounded data, assess consistency rather than exact equality. For categorical counts, test plausible alternatives such as Fisher exact, chi-square with/without continuity correction, and risk ratio/odds ratio calculations as needed. Official guidance lists GraphPad t-test, OpenEpi, Mark Bolland's continuous-data p-value checker (`https://reappraised.shinyapps.io/check_p_vals_cont/`), and Mark Bolland's categorical-data p-value checker (`https://reappraised.shinyapps.io/check_p_vals_cat/`). Do not base the study judgement on a single isolated recalculation when plausible explanations remain.

4.10 Other contradictions implied by data: Check subgroup totals, means outside ranges, impossible event combinations, incompatible derived values, or denominators that cannot produce reported percentages.

4.11 Cross-publication inconsistency: Compare all reports of the same study. Major unexplained differences in methods, dates, arm sizes, event counts, eligibility, outcomes, analysis populations, or authorship/contribution statements may warrant concerns. First resolve whether reports are independent, preliminary/final, overlapping, or corrected versions.

## Judgement Notes

- `Serious concerns` is appropriate when identified issues make the authenticity, conduct, or reporting of the trial seriously doubtful.
- If author correspondence resolves a concern, update the relevant check and move residual issues to the correct domain.
- If uncertainty remains and IPD or protocol access could resolve it, state what evidence is needed.
- Prefer `Unclear` when a finding is unusual but plausible under an unstated method; use `Yes` when the reported information is internally inconsistent, implausible, or contradicted without adequate explanation.
- Report benign explanations separately from the judgement so reviewers can reassess if new evidence arrives.
- When using AI or automated tools, record the tool, inputs, and reviewer verification. Accept no automated output without checking whether it is fit for purpose for the specific check.
