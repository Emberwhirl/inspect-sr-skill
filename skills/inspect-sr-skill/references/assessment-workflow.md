# Assessment Workflow

## 1. Build the Study File

Create a source inventory:

- Bibliographic records and PDFs.
- Trial registration, protocol, ethics documents, statistical analysis plan.
- Conference abstracts, preprints, secondary reports, corrections, comments, and author emails.
- Review-specific extracted outcomes.

Record exact source dates, versions, DOIs, registry IDs, and file paths. Treat all reports as potentially linked until study identity is resolved. Preserve extracted text and numerical-check scripts or calculations so another reviewer can reproduce the assessment.

Plan the assessment at review-protocol stage when possible. Specify how studies with `Some concerns` and `Serious concerns` will be handled before seeing results, for example whether the primary analysis will include only `No concerns` studies or include `Some concerns` studies with a sensitivity analysis restricted to `No concerns`.

## 2. Resolve Study Identity

Compare title, authors, sites, dates, interventions, comparators, eligibility, sample size, outcomes, trial identifiers, ethics approval numbers, and distinctive methods. If two reports may describe the same or overlapping trial, do not count them as independent until clarified.

If author clarification confirms one report is preliminary or extended, update the assessment: repeated wording may no longer be a Domain 3 concern, but unexplained changes in dates, arm sizes, or events may remain Domain 4 concerns.

Classify report relationships as one of:

- independent trials;
- same trial, preliminary and final/extended reports;
- overlapping cohorts or pooled continuation;
- correction or replacement;
- unresolved.

State the classification and evidence before extracting data.

## 3. Apply Domains in Order

Start with post-publication notices because retraction or an active investigation may be decisive. Repeat checks 1.1 and 1.2 close to review completion. Then inspect governance/transparency, text/figures, and results.

For each check:

1. State the evidence.
2. State the response.
3. Explain whether the issue affects trustworthiness.
4. Note alternative benign explanations.
5. Identify missing evidence that would resolve uncertainty.

Do not let one strong impression drive every domain. If new evidence resolves a concern, change that check even if the overall judgement remains severe for other reasons.

If `Serious concerns` is already justified, early termination is acceptable. Record which checks were completed, why the evidence is sufficient, and why further checking would not change the review handling.

## 4. Perform Numerical Checks

Prioritize values relevant to the review plus a sample of baseline and safety data. Common checks:

- arm totals and participant flow;
- categorical p-values from 2x2 tables;
- consistency of percentages with counts;
- impossible means/variances for integer data;
- repeated or copied treatment effects across reports;
- subgroup totals versus overall totals.

Report exact inputs and methods, for example: `4/50 vs 3/46, Fisher exact p = ...`.

For categorical outcomes, create a small table with numerator, denominator, recalculated p-value/effect, and reported claim. For continuous outcomes, note that rounded means and SDs may not reproduce exact p-values; test ranges where feasible.

## 5. Use Author Correspondence Carefully

Ask neutral, factual questions. Request protocol, registry, ethics approval, randomization method, CONSORT flow, and deidentified IPD or aggregate reconciliation when needed. Do not imply misconduct.

Treat author replies as evidence, not automatic resolution. If a reply explains study identity but not participant flow, update the identity issue while retaining unresolved flow concerns.

Useful neutral questions:

- Are these publications separate trials or reports of the same trial?
- Which report contains the final dataset?
- Is a protocol, ethics submission, registry record, or statistical analysis plan available?
- What was the randomization method and allocation ratio?
- Can the authors provide a participant flow from screened to analyzed?
- Can the authors reconcile specific arm-size or event-count differences?

## 6. Write the Review Recommendation

State one of the following practical outcomes:

- no trustworthiness concern identified;
- include but flag uncertainty;
- include only in sensitivity analysis;
- seek further clarification before synthesis;
- exclude from the review or primary synthesis due to serious concerns, if consistent with the review protocol.

Keep INSPECT-SR separate from risk-of-bias assessment. Apply INSPECT-SR before risk-of-bias assessment when possible; if a study receives `Serious concerns`, risk-of-bias assessment may be unnecessary because the trial should not be included in the review. A trial can have low risk of bias but serious trustworthiness concerns, or vice versa.

## 7. Reporting Template

Use this compact structure:

1. Trial identity and reports assessed.
2. Data sources and searches performed.
3. Completed INSPECT-SR table.
4. Key concerns and resolved issues.
5. Numerical checks with reproducible inputs.
6. Author correspondence and remaining missing evidence.
7. Overall judgement and review handling recommendation.

When the review team uses two independent assessors, include both initial judgements and the consensus resolution.

## 8. Responsible Automation

Use AI or automated tools to assist with source finding, text comparison, figure screening, or numerical checking only when the tool is appropriate for the task. Record the tool name, version or URL, inputs, and reviewer verification. Be cautious with any tool that lacks public documentation, transparent evaluation, clear terms, or a known scope of validity.
