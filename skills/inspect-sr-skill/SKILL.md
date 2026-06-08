---
name: inspect-sr-agent
description: Apply INSPECT-SR to assess the trustworthiness of randomised controlled trials in systematic reviews. Use when evaluating potentially problematic RCTs, comparing multiple reports of one index study, checking post-publication notices, assessing conduct/governance/transparency, inspecting duplicated text or manipulated figures, checking statistical or participant-number inconsistencies, preparing INSPECT-SR tables, or recommending author clarification, sensitivity analysis, risk-of-bias deferral, or exclusion from synthesis.
---

# INSPECT-SR Agent

## Provenance

Skill version: v0.0.1

Author: Emberwhirl <emberwhirl@163.com>

This skill is based on the official **INSPECT-SR guidance version 1.1.1** dated 2026-05-01, the editable template, the official website at `https://inspect.sr/` and its source at `https://github.com/ianhussey/inspect-sr-guidance`, and the INSPECT-SR medRxiv preprint version 3.

Citation: Wilkinson J, Heal C, Flemyng E, et al. INSPECT-SR: a tool for assessing trustworthiness of randomised controlled trials. medRxiv [Preprint]. 2025:2025.09.03.25334905. doi: 10.1101/2025.09.03.25334905. PMID: 40950444; PMCID: PMC12424918.

## Purpose

Use this skill to assess whether an RCT included or considered in a systematic review raises trustworthiness concerns. INSPECT-SR is not a risk-of-bias tool, does not assess generalisability or conflicts of interest, and is not a fraud or misconduct detector. It asks whether the reported study and data are sufficiently trustworthy to include in evidence synthesis.

INSPECT-SR was developed primarily for health-related RCTs in systematic reviews, but the guidance notes possible utility in other fields. It does not require individual participant data (IPD); when IPD are available or unresolved uncertainty remains, consider requesting IPD or using an IPD-focused integrity tool.

## License

The original INSPECT-SR guidance and tools are licensed under **CC-BY 4.0**. This skill is an independent agent-oriented implementation guide released under the **MIT License**. Preserve attribution to the INSPECT-SR guidance and cite Wilkinson et al. when using this skill to support review methods or reporting.

## Core Take-Aways

- Assess the **study**, not only one publication. Collect all reports: full articles, abstracts, protocols, registry entries, preprints, secondary analyses, corrections, and author correspondence.
- Use four domains: post-publication notices; conduct, governance, and transparency; text and figures; and study results.
- Answer each check as `Yes`, `No`, `Unclear`, or `Not applicable`; a `Yes` means a potentially problematic feature was found.
- Domain and overall judgements are `No concerns`, `Some concerns`, or `Serious concerns`; they are not computed mechanically from check counts.
- Reserve `Serious concerns` for cases where serious concerns about trustworthiness are established beyond a reasonable doubt, either from one major issue or cumulative issues.
- You may stop early when a judgement of `Serious concerns` is already justified, especially after a retraction of the main report, but document why stopping is justified.
- Absence of trial registration is context-sensitive. It may limit verification, but should not automatically be treated as a trustworthiness concern.
- Apply INSPECT-SR before risk-of-bias assessment and data extraction when possible. Trials with `Serious concerns` should not be included in the review; trials with Some concerns should generally be evaluated using sensitivity analyses (e.g., comparing overall results with and without these trials) in accordance with the protocol.
- Prefer two independent assessors and consensus resolution. Ensure the assessment includes content expertise where plausibility is clinical/biological and statistical competence where numerical checks are material.
- Author clarification can change which domain a concern belongs to. Update all tables and reports when new evidence arrives.
- Use automation and AI only for assistance. Critique outputs, record sources and methods, and keep the human judgement explicit.

## Workflow

Run the workflow in phases. Each phase produces audit output.

| Phase | Input | Action | Output |
|---|---|---|---|
| 1. Scope | Request, review question, citations, files, registry IDs, extracted data | Define the index trial, review decision, assessors, and protocol rule for `Some concerns` or `Serious concerns` | Scope statement and inventory plan |
| 2. Build study file | PDFs, records, registries, protocols, ethics docs, abstracts, preprints, notices, author emails | List each source with date/version, DOI, registry ID, path/URL, and type | Source inventory and missing-source list |
| 3. CHECKPOINT - Source sufficiency | Source inventory | If only a citation, abstract, or excerpt is available, stop before a final judgement unless the user accepts a preliminary assessment | Source request list or permission to proceed preliminarily |
| 4. Resolve identity | Potentially related reports | Compare authors, sites, dates, arms, eligibility, sample sizes, outcomes, identifiers, ethics approvals, and distinctive methods | `independent`, `preliminary/final`, `overlapping`, `correction/replacement`, or `unresolved` |
| 5. Notices first | DOI, title, PMID, registry ID, authors | Check journal pages, Retraction Watch, PubMed/Medline, citation links, PubPeer, corrections, letters, comments, and publisher notes | Domain 1 notes and any decisive notice |
| 6. CHECKPOINT - Early termination | Domain 1 evidence | If a retraction, withdrawal, removal, or equivalent notice already justifies `Serious concerns`, stop broad checking unless a full table is needed | Completed checks, decisive evidence, reason for stopping, and unassessed checks |
| 7. Apply checks | Study file and `references/checks-and-judgements.md` | Answer checks as `Yes`, `No`, `Unclear`, or `Not applicable`; record source, evidence state, benign alternative, missing evidence, and change conditions | Table aligned to `references/table-template.md` |
| 8. Numerical checks | Flow, totals, denominators, events, means, SDs, p-values, CIs, review-critical outcomes | Recalculate feasible values, check rounded percentages, test integer means/variances, and reconcile cross-report totals | Inputs, method, recalculated value, reported value, interpretation |
| 9. CHECKPOINT - Serious concerns | Completed checks and alternatives | Before assigning `Serious concerns`, verify that serious concerns are established beyond a reasonable doubt or cumulative unresolved issues | Severity rationale and rejected/accepted benign alternatives |
| 10. Recommend handling | Judgements, protocol, author correspondence, missing evidence | Assign judgements without counting `Yes` responses | Trustworthiness report plus include / flag / clarify / sensitivity / defer risk-of-bias / exclude recommendation |

## Outputs

Prefer a template-aligned table plus a narrative summary:

- Completed INSPECT-SR table in markdown or document format. Use `references/table-template.md` when the user has not supplied another format.
- Short trustworthiness report with the index trial identity, sources checked, key concerns, author-contact needs, and synthesis recommendation.
- Reproducibility notes for statistical checks, including inputs and test methods.
- Consensus notes when two assessors are used: reviewer 1 response, reviewer 2 response, disagreement, final consensus, and rationale.
- Methods text for systematic reviews when requested, including the INSPECT-SR guidance version used.

## Response Discipline

- Use `Not applicable` when a check cannot logically apply, such as check 2.3 when no registration exists or check 3.2 when no figures exist.
- Use `Unclear` when information is partial or unverified and no direct contradiction has been established.
- Use `Yes` when the study has an internally inconsistent, implausible, contradicted, or integrity-relevant feature that remains unresolved.
- Treat `No` as an evidence-backed absence of identified concern from the sources checked, not proof that no concern exists anywhere.
- Never imply misconduct. Say "trustworthiness concern", "potentially problematic feature", "unresolved inconsistency", or "serious doubts about trustworthiness".

For every check, label reviewer comments as `Direct evidence`, `Inference`, `Missing information`, `Author clarification`, or `Benign alternative`.

## Failure Modes and Fallbacks

| Trigger condition | First-line action | If still unresolved |
|---|---|---|
| Only a citation, abstract, or excerpt is available | Request full article, registry, protocol, notices, and extracted outcomes | Mark affected checks `Unclear` or `Not applicable`; avoid final judgement unless preliminary |
| Multiple reports may describe the same or overlapping trial | Resolve identity before counting studies or judging cross-publication inconsistency | Classify as `unresolved`, request author clarification, and avoid treating reports as independent |
| No trial registration exists | Use `Not applicable` for check 2.3 and assess absence/timing under check 2.2 in context | Seek protocol, ethics documents, SAP, or author clarification; do not automatically call absence a concern |
| Numerical recalculation does not match | Check rounding, missing data, test choice, continuity correction, population, and transcription | Report the discrepancy; use `Unclear` unless contradiction or implausibility remains |
| A post-publication notice is found | Assess relevance to the index trial and trustworthiness before judging severity | If decisive, use the early-termination checkpoint; if not decisive, complete relevant remaining checks |
| Figure or text similarity is unverified | Describe the similarity, sources compared, and limits of inspection | Keep `Unclear` until duplication/manipulation is substantiated or clarification resolves it |
| Author correspondence provides an explanation | Treat it as evidence and update only the checks it resolves | Preserve unresolved concerns in the correct domain and record remaining missing evidence |
| User asks for risk-of-bias, fraud detection, or conflict-of-interest scoring | State that INSPECT-SR does not perform that assessment | Offer methods text or a handoff note without merging frameworks |

## Do Not Do

- Do not accuse authors, journals, or sponsors of fraud, fabrication, falsification, or misconduct.
- Do not use INSPECT-SR as a numeric score or convert `Yes` counts into a judgement.
- Do not treat missing registration, missing ethics details, a large treatment effect, unusual baseline balance, or one recalculated p-value mismatch as automatically decisive.
- Do not assess risk of bias, reporting quality, generalisability, conflicts of interest, or outcome reporting bias unless covered by an INSPECT-SR check.
- Do not classify two reports as independent trials until study identity has been resolved.
- Do not mark `No` when sources were not checked; use `Unclear` and name the missing source.
- Do not rely on AI, plagiarism tools, image tools, or statistical calculators without recording inputs and human verification.
- Do not continue exhaustive checking after a decisive `Serious concerns` finding unless the user needs a full table or a protocol requires completion.

## Reference Files

- `references/checks-and-judgements.md`: the 21 checks, response guidance, judgement rules, and robustness prompts.
- `references/assessment-workflow.md`: practical workflow for source inventory, multi-report trials, author correspondence, numerical checks, and reporting.
- `references/table-template.md`: markdown version of the INSPECT-SR table template structure, with domains shown as section headings and each table using `Check`, `Reviewer comments`, and `Response` columns.
- `references/Wilkinson_MedRxiv_40950444_MEDLINE.txt`: MEDLINE-style citation export for the INSPECT-SR preprint; use it to verify citation details when preparing methods text or bibliographies.
