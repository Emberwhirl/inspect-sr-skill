#!/usr/bin/env Rscript
# INSPECT-SR check 4.8 — are the means and variances of integer data impossible?
#
# Thin wrapper over the 'scrutiny' R package (Lukas Jung), the same implementation
# underlying the official INSPECT-SR consistency checker for means and variances at
# https://errors.shinyapps.io/inspect-sr-means-variances/ . Results are therefore
# directly comparable to the tool the guidance names, and citable as scrutiny.
#
# Usage
#   Rscript grim_grimmer.R --n 30 --mean 8.96
#   Rscript grim_grimmer.R --n 30 --mean 9.93 --sd 0.18
#   Rscript grim_grimmer.R --csv values.csv        # columns: label,n,mean[,sd]
#
# Means and SDs are read as text so that trailing zeros are preserved: "9.90" and
# "9.9" are different claims about reporting precision and give different verdicts.

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0 || any(args %in% c("-h", "--help"))) {
  cat(readLines(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)))[2:22], sep = "\n")
  quit(status = 0)
}

get_arg <- function(flag) {
  i <- match(flag, args)
  if (is.na(i) || i == length(args)) return(NA_character_)
  args[i + 1]
}

if (!requireNamespace("scrutiny", quietly = TRUE)) {
  cat("ERROR: the 'scrutiny' R package is not installed.\n\n",
      "Install it with:\n",
      '  Rscript -e \'install.packages("scrutiny", repos="https://cloud.r-project.org")\'\n\n',
      "Do not substitute a hand-rolled GRIM/GRIMMER implementation: GRIMMER in particular\n",
      "has subtle edge cases, and a divergent implementation risks manufacturing a false\n",
      "'Yes' on check 4.8. If scrutiny cannot be installed, report that the check could\n",
      "not be computed and point the reviewer at the official web app.\n", sep = "")
  quit(status = 2)
}

suppressMessages(library(scrutiny))

# ---- assemble the values to test -------------------------------------------------
csv <- get_arg("--csv")
if (!is.na(csv)) {
  d <- read.csv(csv, colClasses = "character", stringsAsFactors = FALSE)
  names(d) <- tolower(names(d))
  if (!all(c("n", "mean") %in% names(d))) stop("CSV needs at least columns: n, mean (optionally sd, label)")
  vals <- data.frame(
    label = if ("label" %in% names(d)) d$label else paste0("row", seq_len(nrow(d))),
    x     = trimws(d$mean),
    sd    = if ("sd" %in% names(d)) trimws(d$sd) else NA_character_,
    n     = as.numeric(d$n),
    stringsAsFactors = FALSE
  )
} else {
  mean_s <- get_arg("--mean"); n_s <- get_arg("--n"); sd_s <- get_arg("--sd")
  if (is.na(mean_s) || is.na(n_s)) stop("supply --n and --mean (and optionally --sd), or --csv")
  vals <- data.frame(label = "value", x = mean_s, sd = sd_s, n = as.numeric(n_s),
                     stringsAsFactors = FALSE)
}

has_sd <- !all(is.na(vals$sd) | vals$sd == "")

# ---- run the checks --------------------------------------------------------------
res <- withCallingHandlers({
  if (has_sd) {
    as.data.frame(grimmer_map(
      tibble::tibble(x = vals$x, sd = vals$sd, n = vals$n), show_reason = TRUE))
  } else {
    as.data.frame(grim_map(tibble::tibble(x = vals$x, n = vals$n)))
  }
}, warning = function(w) invokeRestart("muffleWarning"))

reason <- if ("reason" %in% names(res)) res$reason else
  ifelse(res$consistency, "Passed GRIM", "GRIM inconsistent")

# GRIMMER test 3 carries a known false-positive bug in scrutiny (issue #80): it can
# flag genuinely consistent values as inconsistent. Never let it produce a firm 'Yes'.
test3 <- grepl("test 3", reason, fixed = TRUE)

verdict <- ifelse(res$consistency, "CONSISTENT",
           ifelse(test3, "INCONSISTENT (unreliable)", "IMPOSSIBLE"))

out <- data.frame(label = vals$label, n = res$n, mean = res$x,
                  sd = if (has_sd) res$sd else "-",
                  verdict = verdict, reason = reason, stringsAsFactors = FALSE)

cat("INSPECT-SR check 4.8 — GRIM/GRIMMER (scrutiny ",
    as.character(packageVersion("scrutiny")), ")\n\n", sep = "")
print(out, row.names = FALSE)

n_imp <- sum(verdict == "IMPOSSIBLE")
n_bad <- sum(test3)

cat("\nInterpretation\n")
cat("  IMPOSSIBLE                 the reported values cannot arise from integer data at this n\n")
cat("  INCONSISTENT (unreliable)  flagged only by GRIMMER test 3, which has a known\n")
cat("                             false-positive bug (scrutiny issue #80) — treat as\n")
cat("                             Unclear and confirm via the official web app\n")
cat("  CONSISTENT                 possible; this is not evidence that the value is correct\n\n")

cat("Before answering 'Yes' to check 4.8:\n")
cat("  - This check applies ONLY to variables that can take integer values. Percentages\n")
cat("    derived from integer counts may be tested with GRIM but NOT GRIMMER. Times\n")
cat("    (age in years, duration in months) qualify only if recorded in whole units.\n")
cat("  - Missing data reducing the effective n is the usual benign explanation for a\n")
cat("    single failure. Several impossible combinations are far harder to explain away,\n")
cat("    and that is what the guidance's worked example turns on.\n")
cat("  - The guidance recommends consulting a statistician to verify a borderline judgement.\n")
if (n_imp > 0) cat("\n  -> ", n_imp, " impossible value(s) found.\n", sep = "")
if (n_bad > 0) cat("  -> ", n_bad, " value(s) rest on the unreliable test 3; do not report these as impossible.\n", sep = "")
