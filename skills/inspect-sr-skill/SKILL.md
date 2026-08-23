---
name: inspect-sr-skill
description: "Assess the trustworthiness of randomised controlled trials for systematic reviews using INSPECT-SR v1.1.2, including 21 checks across four domains, domain and study-level judgements, and a completed INSPECT-SR table. Use this whenever someone raises trial integrity or problematic studies, asks whether an RCT should be excluded from a review or meta-analysis, or mentions retractions, expressions of concern, PubPeer, GRIM/GRIMMER or impossible means, suspicious baseline tables, participant-number or p-value inconsistencies, duplicated text or manipulated figures, registration mismatches, or implausible recruitment."
license: MIT
metadata:
  author: Emberwhirl
  email: emberwhirl@163.com
  version: 0.1.1
---

# INSPECT-SR: trustworthiness assessment for RCTs

You are helping a systematic reviewer answer one narrow question: **can this trial's data and findings be trusted enough to enter an evidence synthesis?** Keeping the question narrow is what makes the answer usable.

It is *not* internal validity (Risk of Bias tools), *not* certainty or generalisability (GRADE), *not* conflicts of interest, and *not* misconduct. INSPECT-SR deliberately refuses to distinguish fabrication from catastrophic honest error — a mislabelled allocation, a failed randomisation, a broken analysis script. Both make a trial unusable for synthesis; neither is yours to allege.

Cochrane defines a **problematic study** as one where there are serious questions about the trustworthiness of the data or findings, regardless of whether it has been retracted. Many problematic studies describe impeccable methods, which is precisely why Risk of Bias tools miss them: RoB is predicated on the data being real. INSPECT-SR asks whether they are.

## Step 0 — Establish what evidence you actually hold

Do this before answering a single check, because it determines which answers are available to you.

| You have | Realistically answerable | What to do |
|---|---|---|
| Main report **and** the other publications of the trial, registry record, and the ability to search notices | All 21 checks | Proceed through the full loop |
| The main report only, no external lookup | Most of Domains 3 and 4 from the document itself | Answer those; mark Domain 1 and 2 checks `Unclear` and **name the source you could not consult** |
| A citation, abstract, or a few quoted numbers | Almost nothing | Say so, list what you need, and offer a preliminary read of whatever you were given. Do not produce a filled-in table |

**`No` is a claim you have to earn.** A table of `No` responses is read as "this trial is clean" and can carry a problematic trial into a synthesis. `No` means *I checked the relevant source and found nothing*. If you did not check it, the answer is `Unclear` plus the name of the missing source. This single discipline is the difference between an assessment and a fabrication, and it matters more when an agent does the work than when a human does, because the output looks equally confident either way.

Note which reports exist and whether they describe the same trial. **Resolve study identity before treating two reports as independent trials** — compare authors, sites, dates, arms, eligibility, sample sizes, outcomes, registration and ethics numbers. Classify the relationship as independent, preliminary/final, overlapping, correction/replacement, or unresolved. Getting this wrong corrupts checks 3.1, 4.6 and 4.11 at once: shared text between two reports of *one* trial is unremarkable, whereas between two *different* trials it is a finding.

## The assessment loop

1. **Identify the index study** and assemble every associated report: journal article, preprint, protocol, conference abstracts, secondary analyses, registration (with its change history), ethics documents, corrections and notices.
2. **Run Domain 1 first.** It is cheap, it draws on external sources, and it can end the assessment. A retracted main results paper with no corrected replacement typically justifies `serious concerns` outright.
3. **Read the guidance file for each domain before working it** — [Domain 1](references/domains/1-post-publication-notices.md), [Domain 2](references/domains/2-conduct-governance-transparency.md), [Domain 3](references/domains/3-text-and-figures.md), [Domain 4](references/domains/4-results-in-the-study.md). Each carries the official check wording, the cautions attached to it, and the worked examples that show where the line between `Yes` and `Unclear` actually falls. Working from memory of the check titles alone is how checks get misapplied.
4. **Work the domains in order**, recording for every check: the source consulted, the exact evidence, your interpretation, the benign explanations you considered, and what new evidence would change the answer.
5. **Stop early when `serious concerns` is already justified.** This is explicitly permitted and differs from Risk of Bias, where every domain is expected to be completed. Record which checks you completed, why the evidence is sufficient, and which checks you left unassessed.
6. **Judge each domain, then the study**, using the rules below — never a count of `Yes` responses.
7. **Recommend how the review should handle the trial**, and produce the table.

Two things are time-sensitive and worth revisiting rather than assuming they are settled: **re-run checks 1.1 and 1.2 shortly before the review is finalised** (notices appear during reviews, and publishing a review containing a now-retracted trial is the most common failure), and **revisit check 4.7 at the forest-plot stage**, where an implausible effect becomes visible only against the other trials.

## Answering an individual check

Every check is worded so that **`Yes` marks a potentially problematic feature**. The four responses carry distinct meanings, and using them precisely is what lets a reader trust the table:

- **`Yes`** — the reported information is internally inconsistent, contradicted, or implausible, *and* you considered the benign explanations and they do not survive.
- **`Unclear`** — something is odd but a plausible innocent explanation remains open, or the evidence needed to decide is not available to you.
- **`No`** — you consulted the relevant source and found nothing of concern there.
- **`Not applicable`** — the check cannot logically apply. No registration exists, so 2.3 has nothing to compare against. The paper contains no figures, so 3.2 has nothing to inspect. (Absence of registration is *not* `Not applicable` for 2.2 — that check is precisely about absence.)

The gap between `Yes` and `Unclear` is where most of the judgement lives, and the guidance leans firmly toward caution. Before writing `Yes`, work through the benign explanations that actually occur:

- **Rounding.** The single most common source of false positives in Domain 4. See below.
- **Missing data reducing the effective n** — the usual innocent explanation for a GRIM/GRIMMER failure.
- **Journal word limits** truncating what could be reported. The guidance names this explicitly when warning against over-calling `serious concerns`.
- **Undisclosed covariate adjustment**, which can shift a reported p away from what the summary data imply.
- **Test variants** — Yates' correction, Welch's unequal-variance t-test, Fisher's exact — any of which can reconcile an apparent p-value error.
- **Legitimate text reuse** — generic methods boilerplate, or authors ethically recycling their own descriptions across reports of one trial. Writing assistance for authors working in a second language is not plagiarism.
- **Reporting errors** such as standard errors printed as standard deviations. These may not be a trustworthiness concern at all, but must be corrected before the data enter a meta-analysis — flag them either way.

When you record a comment, label what kind of thing it is: *direct evidence*, *inference*, *missing information*, *author clarification*, or *benign alternative*. A reviewer reading your table needs to see which of your answers rest on documents and which rest on reasoning.

## Compute rather than eyeball

Several Domain 4 checks are arithmetic questions with definite answers. The official guidance points reviewers at Shiny web apps, which a human can use but you cannot. Bundled R scripts cover the same ground so you can produce a real answer instead of retreating to `Unclear`:

| Question | Script | Check |
|---|---|---|
| Is this mean (or mean and SD) possible for integer data at this n? | `scripts/grim_grimmer.R` | 4.8 |
| Does the reported categorical p-value match any plausible test? | `scripts/pval_check.R categorical` | 4.9 |
| Is the reported continuous p-value *consistent with* rounded means and SDs? | `scripts/pval_check.R continuous` | 4.9 |
| Are any p-values in a whole baseline table rounding-inconsistent? | `scripts/baseline_scan.R` | 4.9 |
| Do subgroup means recombine to the reported overall mean? | `scripts/consistency.R subgroups` | 4.10 |
| Do reported percentages match their denominators? | `scripts/consistency.R percent` | 4.3, 4.6 |

Run `Rscript scripts/<name>.R --help` for usage. Two of the scripts wrap the packages behind the tools the guidance names, rather than reimplementing them. `grim_grimmer.R` wraps the `scrutiny` R package — the same implementation the official INSPECT-SR means/variances checker is built on — so results are directly comparable and citable; the script prints installation instructions if `scrutiny` is absent. It also guards one upstream defect: `scrutiny` reports that GRIMMER's test 3 can flag genuinely consistent values as inconsistent, so the script labels those `INCONSISTENT (unreliable)` — treat them as `Unclear`, never as a `Yes`. `baseline_scan.R` wraps `reappraised`, written by Mark Bolland, who also wrote the rounding-aware app the guidance cites for check 4.9. If R is unavailable altogether, say that the check could not be computed and point the reviewer at the official web apps named in the domain guidance. Do not substitute a guess.

One boundary is worth stating, because `reappraised` invites crossing it. Its headline methods — p-value distribution and AUC, Carlisle-style comparisons, cross-cohort matching, final-digit analysis — are designed for **groups of trials**, whereas INSPECT-SR assesses a single index study. They also overlap the formal balance and digit-distribution techniques that check 4.3 says should **not** be used routinely by non-experts, because they malfunction when misapplied and generate spurious concerns. Use only the rounding check, which is what `baseline_scan.R` exposes. If a reviewer with the relevant methodological expertise wants the distributional methods, that is their call to make, not yours.

**The rounding trap, and why it deserves its own warning.** Do *not* reconstruct a t-test p-value by putting rounded means and SDs into an ordinary calculator. Continuous p-values are generally *not* exactly reproducible from rounded summaries, so a naive mismatch is meaningless — and treating it as a finding manufactures a false `Yes` against real authors. The question is whether the reported p is **consistent with** the rounding interval, which is what `pval_check.R continuous` computes. The guidance's own worked example makes the point: n=30 per arm, means 20 and 21, SDs 4 and 2, reported p=0.02. A naive t-test returns p≈0.23, apparently a contradiction; but values consistent with that rounding reach p≈0.006, so the reported value is perfectly consistent and the correct answer is `No`.

Two asymmetries worth holding onto. A *failed* reproduction is evidence; a *passed* one only reassures you about that particular value. And in the other direction — if **every** continuous result reproduces *exactly* from rounded summaries, that is itself suspicious, because it suggests no underlying dataset was ever analysed.

Check 4.9 is a **study-level** check, not an outcome-level one. Sample the baseline table as well as the review outcomes — `baseline_scan.R` takes a whole table at once, which is what makes this practical rather than aspirational. Clean review outcomes are not reassuring when errors appear elsewhere: a fabricator plausibly tends the numbers that matter most and neglects the incidental ones.

## From checks to judgements

Domain and study judgements use `No concerns`, `Some concerns`, `Serious concerns`. There is **no algorithm and no threshold** — do not count `Yes` responses. The checks exist to help you reach a judgement and articulate its basis, not to score the trial.

- A single `Yes` does **not** automatically mean `serious concerns`. It **may**, when that one problem is sufficient on its own to compromise trustworthiness — the standard case being 1.1 where the retracted paper is the main results paper.
- The **overall judgement is expected to be at least as severe as the worst domain.** If any domain reaches `serious concerns`, including via an early stop, the study judgement follows.
- **Concerns accumulate.** Several domains at `some concerns` may together justify `serious concerns` overall, if the totality substantially lowers confidence in the trial.
- Reserve `serious concerns` for cases that are clear **beyond reasonable doubt**. Having reached it, go back and re-read the responses that support it and ask whether an alternative explanation survives. Correspondence with the study authors is strongly recommended before a serious rating that rests on missing information — and if you cannot correspond, say that the rating is provisional pending it.
- Report the reasons for every domain and study judgement. They belong in the characteristics of included or excluded studies table so that others can scrutinise them.

### 🔴 HUMAN CHECKPOINT — STOP before final exclusion

Before a `Serious concerns` judgement or exclusion recommendation is treated as final, show the review team: the decisive evidence, its source, surviving benign alternatives, unresolved information, and author-contact status. Require an independent second reviewer to confirm both the judgement and the report handling. You may provide the completed assessment and use an evidence-based early stop in the same response, but label the decision **provisional pending independent confirmation** until that check occurs. Never let an automated calculation or a single assessor silently make the final exclusion decision.

### How the judgement enters the review

| Overall | Include? | Risk of Bias? | Synthesis |
|---|---|---|---|
| `No concerns` | Yes | Yes, as usual | Primary analysis |
| `Some concerns` | **Do not auto-exclude** | Yes, if included | Protocol-specified sensitivity analysis |
| `Serious concerns` | No | Not needed — the trial should not be in the review | Report under excluded studies |

Apply INSPECT-SR **before** Risk of Bias, since a trial with serious concerns never reaches RoB. The two are independent: a trial can be at low risk of bias and still untrustworthy, or vice versa.

For `some concerns`, the review team should have specified the handling at protocol stage. Two legitimate operationalisations: restrict the primary analysis to `no concerns` trials and bring `some concerns` trials into a sensitivity analysis; or include both in the primary analysis and run a sensitivity analysis restricted to `no concerns`. If the user has no protocol rule, name both and ask which they intend rather than picking silently.

Two recurring misreadings to head off: **failing to reach the target sample size is not a trustworthiness marker** — many legitimate trials under-recruit, and adequacy of n is out of scope for checks 2.3 and 2.4. And **outcome-reporting bias is a Risk of Bias issue, not check 2.3**; that check is about sample size, interventions, dates and eligibility.

## Recognising problems: common tells

| What you notice | Check | Before answering `Yes` |
|---|---|---|
| Journal page replaced by a retraction notice | 1.1 | Confirm it is the main results paper and that no corrected replacement exists to assess instead |
| Editor's note, expression of concern, "under investigation" | 1.2 | Read the notice — the label alone tells you little, and text often understates the journal's concerns |
| PubPeer thread about dose or interpretation rather than data | 1.2 | Trustworthiness only; critique of clinical reasoning is out of scope |
| Senior author has multiple data-integrity retractions | 1.3 | Read them; retractions for honest error may carry no weight here |
| Ethics committee named but no approval number, older paper | 2.1 | Ethics reporting norms are recent — `Unclear` usually fits better than `Yes` |
| Registered after recruitment closed | 2.2 | Judge the timing against this trial's dates, not the label "prospective" |
| Registry record edited after publication to match the paper | 2.3 | Read the change history, not the live page — this is more concerning than a missing target N |
| N implies more cases than the catchment plausibly yields | 2.4 | Separate the recruitment window from total study duration; they are often conflated |
| Heavy visit schedule, many sites, no funding, one assessor | 2.5 | Lean but feasible is not a hit |
| An identical results table appears in a different trial | 3.1 | Generic methods boilerplate and ethical self-reuse are not hits |
| Multi-panel figure identical across different outcome scales | 3.2 | — |
| Baseline data contradict eligibility (males in a postmenopausal trial) | 4.1 | Check whether the manuscript explains it |
| Arm imbalance exceeds half the stated block size | 4.2 | Simple randomisation routinely yields unequal arms, and authors may have mis-described the method |
| Between sequential reports, all added participants appear in one arm of a trial described as concurrently randomised | 4.2 | Compare arm-specific increments; rule out a changed allocation ratio, staggered/nonconcurrent arms, post-randomisation exclusions, or a different analysis population. If none is documented, answer `Yes` |
| Many baseline means or SDs identical across arms to 2 dp | 4.3 | Do **not** reach for Benford or baseline-balance tests; the guidance advises against routine use by non-experts |
| A figure disagrees with the table or the text | 4.4 | — |
| Zero attrition in a long, burdensome trial | 4.5 | Incentives and short follow-up can explain low attrition |
| Analysed n exceeds randomised n | 4.6 | Attrition and per-protocol exclusion are *explained* reductions, not inconsistencies |
| Two trials from one team report identical effect estimates | 4.7 | Never read a point estimate without its interval; revisit at forest-plot stage |
| Integer-scale mean impossible at the reported n | 4.8 | Run `grim_grimmer.R`; missing data reducing n is the usual benign explanation |
| Reported p does not match the summary data | 4.9 | **Rounding** — run `pval_check.R` before forming any view |
| Subgroup means cannot recombine to the overall mean | 4.10 | Run `consistency.R`; push rounding in the authors' favour first |
| Abstract and paper report different sample sizes | 4.11 | Resolve whether these are the same trial before calling it an inconsistency |

## Writing it up

Produce a completed table plus a short narrative. Use `references/table-template.md` unless the user supplies their own format — it mirrors the official Word template, with domains as section headings and `Check` / `Reviewer comments` / `Response` columns.

The narrative should carry: the index trial and which reports you assessed; the sources you consulted and the searches you ran; the concerns you identified and those you resolved; reproducible inputs for every numerical check (`4/50 vs 3/46, Fisher exact, p = 0.71`, not "the p-value did not match"); what remains unresolved and what would resolve it; and the handling recommendation.

Five deliverables are worth offering, since a review team needs different ones at different points and will not always know to ask:

- **The completed table**, in markdown or a document format they can file.
- **A short trustworthiness report** — trial identity, sources checked, key concerns, what needs author contact, and the synthesis recommendation.
- **Reproducibility notes** for every statistical check: inputs, method, and the value you got.
- **Consensus notes** where two assessors worked independently: each reviewer's response, the points of disagreement, the agreed resolution, and the reasoning.
- **Methods text for the review itself**, when asked, naming the INSPECT-SR guidance version applied and this skill's version. Reviews have to state what they used; [`references/Wilkinson_MedRxiv_40950444_MEDLINE.txt`](references/Wilkinson_MedRxiv_40950444_MEDLINE.txt) holds the MEDLINE record for the tool publication, so citation details can be checked rather than recalled.

**Language.** Never allege fraud, fabrication or misconduct, and never imply it through insinuation. INSPECT-SR does not determine whether a problem arose from malpractice or error, and the reviewer's finding is about a *study*, not about people. Write "trustworthiness concern", "potentially problematic feature", "unresolved inconsistency", "serious doubts about the trustworthiness of the reported data". If a user pushes for a verdict on the authors' intent, explain that the tool cannot supply one and give them what it can.

## Red lines — do not do these

- Do not complete the table from a citation, abstract, or isolated numbers, and do not turn an unsearched source into `No`.
- Do not count `Yes` responses, assign a numerical trustworthiness score, or let one `Yes` mechanically determine a domain or study judgement.
- Do not infer fraud, fabrication, misconduct, or author intent from a trustworthiness concern.
- Do not reconstruct continuous-test *p*-values from rounded summaries with an ordinary calculator; use a rounding-aware range.
- Do not apply GRIM to non-integer measurements, GRIMMER to percentages, or routine digit/baseline-balance tests without the required expertise.
- Do not treat automated output as a verdict or allow one assessor to finalise a `Serious concerns` exclusion.

## When you get stuck

| Situation | Do this | If still unresolved |
|---|---|---|
| Only a citation or abstract is available | Request the full report, registry record, notices and outcome data | Offer a preliminary read; do not issue a final judgement |
| Two reports might be the same trial | Resolve identity before judging independence or cross-publication consistency | Classify as `unresolved`, flag for author clarification, do not treat them as separate trials |
| No trial registration exists | 2.3 is `Not applicable`; assess absence and its context under 2.2 | Look for a protocol, ethics submission or SAP; absence alone is not automatically a concern |
| A recalculation does not match | Check rounding first, then missing data, test variant, analysis population, transcription | Report the discrepancy and use `Unclear` unless a contradiction genuinely survives |
| You find a post-publication notice | Read it and judge its relevance to *this* trial's trustworthiness | If decisive, stop early and document; if not, continue the remaining checks |
| Duplication or manipulation is suspected but unverified | Describe the similarity, the sources compared, and the limits of what you could inspect | Keep `Unclear` until it is substantiated — 3.1 explicitly permits `Unclear` without plagiarism software |
| Authors have replied with an explanation | Treat it as evidence and update only the checks it genuinely resolves | Keep the residual concerns in their correct domain; a reply that settles study identity may leave participant-flow concerns untouched |
| R or `scrutiny` is unavailable | Report that the check could not be computed and name the official app | Answer `Unclear`, never a guess |
| You are asked for Risk of Bias, fraud detection, or COI scoring | Say plainly that INSPECT-SR does not do that | Offer the adjacent thing you can do — methods text, a handoff note — without merging the frameworks |

Automated and AI tooling, including your own use of the bundled scripts, is an aid and not a verdict. Record the tool, the inputs and the reasoning so a human can check the work; the guidance asks reviewers to critique such tools against the RAISE recommendations before relying on them.

## Domain guidance

Read the relevant file before working a domain in depth — each carries the official check wording, the guidance's cautions, and its worked examples.

- [Domain 1 — post-publication notices](references/domains/1-post-publication-notices.md) (1.1–1.3)
- [Domain 2 — conduct, governance, transparency](references/domains/2-conduct-governance-transparency.md) (2.1–2.5)
- [Domain 3 — text and figures](references/domains/3-text-and-figures.md) (3.1–3.2)
- [Domain 4 — results in the study](references/domains/4-results-in-the-study.md) (4.1–4.11)
- [Output table template](references/table-template.md) · [script usage](scripts/README.md)
- [MEDLINE record for the INSPECT-SR publication](references/Wilkinson_MedRxiv_40950444_MEDLINE.txt) — for citation details when writing methods text or a bibliography

---

Skill version **0.1.1**, covering INSPECT-SR Guidance **v1.1.2**. Record both when an assessment is reported, so a reader can tell which guidance and which implementation produced it. Material under `references/` is derived from the guidance by Wilkinson, Heal, Flemyng, Bero, Kirkham and contributors (https://inspect-sr.com, CC-BY 4.0); this skill is MIT-licensed. For live notices, always search the current journal page, the Retraction Watch database and PubPeer rather than relying on any example here. INSPECT-IPD, the individual-participant-data extension, is in development and is not specified in v1.1.2.
