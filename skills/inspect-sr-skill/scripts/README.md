# Scripts

Four R scripts covering the INSPECT-SR checks that are arithmetic questions with definite
answers. The official guidance points reviewers at Shiny web apps; these give an agent the
same answers locally, so a computable check produces a real verdict rather than a retreat
to `Unclear`.

Run any of them with `--help` for usage.

| Script | Checks | What it answers |
|---|---|---|
| `grim_grimmer.R` | 4.8 | Is this mean, or mean and SD, possible for integer data at this n? |
| `pval_check.R categorical` | 4.9 | Does the reported p-value match any plausible test of these frequencies? |
| `pval_check.R continuous` | 4.9 | Is one reported p-value *consistent with* rounded means and SDs? |
| `baseline_scan.R` | 4.9 | Same rounding check across a whole baseline table at once |
| `consistency.R subgroups` | 4.10 | Do the subgroup means recombine to the reported overall mean? |
| `consistency.R percent` | 4.3, 4.6 | Does this percentage match its denominator, and which group sizes could produce it? |

## Requirements

`pval_check.R` and `consistency.R` need only base R. The two wrappers need a package each:

```bash
Rscript -e 'install.packages(c("scrutiny", "reappraised"), repos="https://cloud.r-project.org")'
```

Both are wrapped rather than reimplemented, so their verdicts stay comparable to the tools
the guidance names and can be cited as those tools:

- **`scrutiny`** (Lukas Jung) is the implementation underlying the official INSPECT-SR
  consistency checker for means and variances. GRIMMER has subtle edge cases, and a
  divergent reimplementation risks producing a false `Yes` on check 4.8 against real
  authors.
- **`reappraised`** (Mark Bolland) is by the author of the rounding-aware app the guidance
  cites for check 4.9. Its `pval_cont_fn()$pval_cont_check` gives the minimum and maximum
  p-value obtainable from maximally rounded summary statistics, and flags reported values
  outside that range.

If a package is unavailable, the script says so and exits rather than guessing. For a
single comparison, `pval_check.R continuous` computes the same bounds with no dependency
at all.

## Scope limit on `reappraised`

`reappraised` is subtitled *Statistical Tools for Assessing Publication Integrity of Groups
of Trials*, and most of what it exports — `match_fn`, `cohort_fn`, `anova_fn` (Carlisle),
`final_digit_fn`, `cat_fn`, `cat_all_fn`, `pval_cat_fn`, `sr_fn` — analyses distributions
across **many trials**. INSPECT-SR assesses a **single index study**, and check 4.3 states
that formal baseline-balance methods and digit-distribution methods such as Benford's law
should **not** be used routinely by non-experts, because they malfunction when misapplied
and generate spurious concerns.

`baseline_scan.R` therefore uses only the rounding check and suppresses the distributional
output. Do not extend it to the other functions on your own initiative. A reviewer with
the relevant methodological expertise may choose to use them; that is their call.

The categorical side of check 4.9 — reproducing a p-value across test variants — is not in
`reappraised`; it exists only as Bolland's separate Shiny app. `pval_check.R categorical`
covers it with base R.

## Known upstream issue

`scrutiny` 0.6.1 warns that GRIMMER's **test 3** can flag genuinely consistent values as
inconsistent (upstream issue #80). `grim_grimmer.R` detects this case and reports it as
`INCONSISTENT (unreliable)` rather than `IMPOSSIBLE`, so it can never on its own support a
`Yes`. Treat those as `Unclear` and confirm through the official app.

## Verification

Each script reproduces the worked example the guidance gives for its check:

| Script | Guidance example | Expected | Reproduced |
|---|---|---|---|
| `grim_grimmer.R` | 4.8: Apgar, n=30, means 8.96 / 9.96; mean 9.93 with SD 0.18 | all impossible | yes |
| `pval_check.R continuous` | 4.9 Ex.1: n=30/30, 20±4 vs 21±2, reported p=0.02 | naive p≈0.23 but consistent (floor p≈0.006) → answer `No` | yes |
| `baseline_scan.R` | same example as one row of a table | consistent, floor 0.006 | yes |
| `consistency.R subgroups` | 4.10: n=41, 30 at 6.2 and 11 at 7.4, overall 7.3 | 6.52, ceiling 6.57, still impossible | yes |

The continuous check has been cross-validated against `reappraised`: on the guidance
example both put the floor at 0.006, and both treat a reported p of 0.008 as consistent
while flagging 0.001. Independent agreement between the bundled implementation and
Bolland's own package.

Re-run after any change:

```bash
Rscript grim_grimmer.R --n 30 --mean 8.96
Rscript pval_check.R continuous --n1 30 --mean1 20 --sd1 4 --n2 30 --mean2 21 --sd2 2 --reported 0.02
Rscript consistency.R subgroups --n "30,11" --mean "6.2,7.4" --overall 7.3
```

## Reporting results

Record the inputs and the method alongside the verdict so another reviewer can reproduce
it — `4/50 vs 3/46, Fisher exact, p = 0.71`, not "the p-value did not match". A failed
reproduction is evidence; a passed one reassures you only about that one value.
