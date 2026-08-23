#!/usr/bin/env Rscript
# INSPECT-SR check 4.9 — scan a WHOLE baseline table for rounding-inconsistent p-values
#
# The guidance is explicit that 4.9 is a study-level check: sample the baseline table as
# well as the review outcomes, because a fabricator may tend the key outcomes and neglect
# incidental variables. Checking one comparison at a time does not serve that. This scans
# every row at once.
#
# Wraps reappraised::pval_cont_fn() (Mark Bolland), whose $pval_cont_check component gives
# the min and max p-value possible from maximally rounded summary statistics and flags
# reported values outside that range. Bolland also wrote the app the guidance cites for
# this check (https://reappraised.shinyapps.io/check_p_vals_cont/), so this is the same
# method by the same author.
#
# Usage
#   Rscript baseline_scan.R --csv baseline.csv [--study "Smith 2019"]
#
# CSV columns: var, n1, n2, m1, m2, s1, s2, p        (p may be blank where not reported)
#   optionally n3/n4, m3/m4, s3/s4 for three- and four-arm trials
#
# IMPORTANT: only the rounding check is used here. reappraised's headline outputs are
# p-value distribution and AUC methods designed for GROUPS of trials, and the guidance
# advises against routine use of formal baseline-balance and digit-distribution methods
# by non-experts (check 4.3). Do not read this script's output as a balance test.

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0 || any(args %in% c("-h", "--help"))) {
  cat(readLines(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)))[2:26], sep = "\n")
  quit(status = 0)
}
get_arg <- function(flag, default = NA_character_) {
  i <- match(flag, args); if (is.na(i) || i == length(args)) return(default); args[i + 1]
}

if (!requireNamespace("reappraised", quietly = TRUE)) {
  cat("ERROR: the 'reappraised' R package is not installed.\n\n",
      "Install it with:\n",
      '  Rscript -e \'install.packages("reappraised", repos="https://cloud.r-project.org")\'\n\n',
      "For a single comparison you can instead use:\n",
      "  Rscript pval_check.R continuous --n1 .. --mean1 .. --sd1 .. --n2 .. --mean2 .. --sd2 .. --reported ..\n",
      "which computes the same bounds without this dependency.\n", sep = "")
  quit(status = 2)
}

csv <- get_arg("--csv")
if (is.na(csv)) stop("supply --csv with columns: var,n1,n2,m1,m2,s1,s2,p")
study <- get_arg("--study", "index study")

d <- read.csv(csv, stringsAsFactors = FALSE)
names(d) <- tolower(trimws(names(d)))
if (!"var" %in% names(d)) stop("CSV needs a 'var' column naming each baseline variable")
for (cl in c("n1","n2","n3","n4","m1","m2","m3","m4","s1","s2","s3","s4","p")) {
  if (!cl %in% names(d)) d[[cl]] <- NA_real_
  d[[cl]] <- suppressWarnings(as.numeric(d[[cl]]))
}
dat <- data.frame(study = study, var = d$var,
                  n1=d$n1, n2=d$n2, n3=d$n3, n4=d$n4,
                  m1=d$m1, m2=d$m2, m3=d$m3, m4=d$m4,
                  s1=d$s1, s2=d$s2, s3=d$s3, s4=d$s4,
                  p = d$p, stringsAsFactors = FALSE)

suppressMessages(library(reappraised))
# load_clean() resolves its input by NAME from the calling environment
assign(".inspect_sr_baseline", dat, envir = .GlobalEnv)
cleaned <- suppressWarnings(load_clean(import = "no", file.cont = ".inspect_sr_baseline",
                                       pval_cont = "yes", format.cont = "wide", verbose = FALSE))
res <- suppressWarnings(pval_cont_fn(df = cleaned$pval_cont_data, verbose = FALSE,
                                     btsp = 10, sims = 10))
chk <- as.data.frame(res$pval_cont_check)
names(chk) <- sub("_either\\.var$", "", names(chk))

out <- data.frame(
  variable = chk$variable,
  reported_p = chk$reported_pvalue,
  min_possible = chk$min_possible_p,
  max_possible = chk$max_possible_p,
  verdict = ifelse(trimws(as.character(chk$pvalue_flag)) == "", "consistent", "OUTSIDE RANGE"),
  stringsAsFactors = FALSE)

cat("INSPECT-SR check 4.9 — baseline table scan for ", study,
    "\n(reappraised ", as.character(packageVersion("reappraised")), ")\n\n", sep = "")
print(out, row.names = FALSE)

n_flag <- sum(out$verdict == "OUTSIDE RANGE")
n_test <- sum(!is.na(out$reported_p))
cat("\n", n_test, " reported p-value(s) testable; ", n_flag, " outside the range the rounded\n",
    "summary statistics permit.\n\n", sep = "")

if (n_flag == 0) {
  cat("No rounding-inconsistent p-values found in this table. Note that this reassures you\n")
  cat("only about the values tested — it is not evidence the study is sound.\n")
} else {
  cat("Before answering 'Yes' to check 4.9: consider undisclosed covariate adjustment, a\n")
  cat("different analysis population, non-parametric or paired tests, and transcription\n")
  cat("slips. The guidance warns against basing the study judgement on a single isolated\n")
  cat("recalculation — weigh how many errors there are and where they fall.\n")
}
cat("\nIf EVERY continuous result reproduces exactly from rounded summaries, that is itself\n",
    "a warning sign: it can imply no underlying dataset was analysed.\n\n", sep = "")
cat("Scope: this uses only reappraised's rounding check. Its p-value distribution and AUC\n")
cat("outputs are group-of-trials methods, and the guidance advises against routine use of\n")
cat("formal balance and digit-distribution methods by non-experts (check 4.3).\n")
