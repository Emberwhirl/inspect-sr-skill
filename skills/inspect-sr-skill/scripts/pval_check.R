#!/usr/bin/env Rscript
# INSPECT-SR check 4.9 — are there errors in statistical results?
#
# Two modes, because continuous and categorical data pose different problems.
#
#   categorical   Frequencies are reported exactly, so a p-value CAN be reproduced.
#                 Authors use test variants, so this tries the plausible alternatives
#                 before concluding anything is wrong.
#
#   continuous    Means and SDs are ROUNDED, so a p-value generally CANNOT be
#                 reproduced exactly. Asking "does it match?" is the wrong question and
#                 produces false accusations. This computes the interval of p-values
#                 consistent with the rounding, and asks whether the reported value
#                 falls inside it. Equivalent to Mark Bolland's app at
#                 https://reappraised.shinyapps.io/check_p_vals_cont/
#
# Usage
#   Rscript pval_check.R categorical --table "12,38,7,43" --reported 0.21
#   Rscript pval_check.R continuous --n1 30 --mean1 20 --sd1 4 \
#                                   --n2 30 --mean2 21 --sd2 2 --reported 0.02
#
# Base R only; no packages required.

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0 || any(args %in% c("-h", "--help"))) {
  cat(readLines(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)))[2:26], sep = "\n")
  quit(status = 0)
}

mode <- args[1]
get_arg <- function(flag, default = NA_character_) {
  i <- match(flag, args)
  if (is.na(i) || i == length(args)) return(default)
  args[i + 1]
}
num <- function(flag, default = NA_real_) {
  v <- get_arg(flag); if (is.na(v)) default else as.numeric(v)
}
# decimal places as *reported* — "20" and "20.0" are different precision claims
dp <- function(s) { if (!grepl("\\.", s)) 0L else nchar(sub("^[^.]*\\.", "", s)) }
fmt <- function(p) formatC(p, format = "g", digits = 4)

# ==================================================================================
if (mode == "categorical") {
  tab_s <- get_arg("--table")
  if (is.na(tab_s)) stop('supply --table "a,b,c,d" (row-major)')
  nrow_t <- as.integer(get_arg("--nrow", "2"))
  counts <- as.numeric(strsplit(tab_s, "[,;[:space:]]+")[[1]])
  counts <- counts[!is.na(counts)]
  if (length(counts) %% nrow_t != 0) stop("count of cells is not divisible by --nrow")
  m <- matrix(counts, nrow = nrow_t, byrow = TRUE)
  reported <- num("--reported")

  cat("INSPECT-SR check 4.9 — categorical results\n\nObserved table:\n")
  print(m)
  cat("\nFrequencies are reported exactly, so p-values here are genuinely reproducible.\n",
      "Authors commonly use variants, so all plausible tests are shown.\n\n", sep = "")

  res <- list()
  tryCatch({ res[["chi-squared, no correction"]] <-
    suppressWarnings(chisq.test(m, correct = FALSE)$p.value) }, error = function(e) NULL)
  if (all(dim(m) == c(2, 2))) {
    tryCatch({ res[["chi-squared, Yates' correction"]] <-
      suppressWarnings(chisq.test(m, correct = TRUE)$p.value) }, error = function(e) NULL)
    tryCatch({ res[["Fisher exact, two-sided"]] <- fisher.test(m)$p.value },
             error = function(e) NULL)
    tryCatch({ res[["Fisher exact, one-sided"]] <-
      fisher.test(m, alternative = "greater")$p.value }, error = function(e) NULL)
  } else {
    tryCatch({ res[["Fisher exact (simulated)"]] <-
      fisher.test(m, simulate.p.value = TRUE, B = 2e5)$p.value }, error = function(e) NULL)
  }

  # print p to 6 dp: a 4-significant-digit display hides the very rounding behaviour
  # the reader needs to see when deciding whether a reported value matches
  out <- data.frame(test = names(res),
                    p = formatC(unlist(res), format = "f", digits = 6),
                    stringsAsFactors = FALSE)
  if (!is.na(reported)) {
    # match at the precision the paper reported the p-value to
    d <- dp(get_arg("--reported"))
    out$matches_reported <- ifelse(
      abs(round(unlist(res), d) - reported) < 1e-12, "MATCH", "")
  }
  print(out, row.names = FALSE)

  if (!is.na(reported)) {
    if (any(out$matches_reported == "MATCH")) {
      cat("\n-> The reported p =", reported,
          "is reproducible by at least one plausible test. No error demonstrated here.\n")
    } else {
      pv <- unlist(res)
      k <- which.min(abs(pv - reported))
      cat("\n-> The reported p =", reported,
          "matches NONE of the plausible tests.\n")
      cat("   Closest is", names(pv)[k], "at p =", formatC(pv[k], format = "f", digits = 6),
          sprintf("(difference %s).\n", formatC(abs(pv[k] - reported), format = "f", digits = 6)))
      cat("   Before answering 'Yes': check the direction and grouping of the table, whether\n")
      cat("   the test was adjusted for covariates, and whether the p-value belongs to a\n")
      cat("   different comparison. The guidance also warns that a single isolated mismatch\n")
      cat("   should not drive the study judgement — weigh it with the other errors found.\n")
    }
  }
  cat("\nNote: results of non-parametric tests on continuous measures generally cannot be\n",
      "checked from reported summary data at all.\n", sep = "")
  quit(status = 0)
}

# ==================================================================================
if (mode == "continuous") {
  m1s <- get_arg("--mean1"); s1s <- get_arg("--sd1")
  m2s <- get_arg("--mean2"); s2s <- get_arg("--sd2")
  n1 <- num("--n1"); n2 <- num("--n2"); reported <- num("--reported")
  if (any(is.na(c(m1s, s1s, m2s, s2s))) || is.na(n1) || is.na(n2))
    stop("supply --n1 --mean1 --sd1 --n2 --mean2 --sd2")
  m1 <- as.numeric(m1s); s1 <- as.numeric(s1s)
  m2 <- as.numeric(m2s); s2 <- as.numeric(s2s)

  p_student <- function(m1, s1, n1, m2, s2, n2) {
    sp2 <- ((n1 - 1) * s1^2 + (n2 - 1) * s2^2) / (n1 + n2 - 2)
    se <- sqrt(sp2 * (1 / n1 + 1 / n2)); if (se <= 0) return(1)
    2 * pt(-abs((m1 - m2) / se), n1 + n2 - 2)
  }
  p_welch <- function(m1, s1, n1, m2, s2, n2) {
    a <- s1^2 / n1; b <- s2^2 / n2; se <- sqrt(a + b); if (se <= 0) return(1)
    df <- (a + b)^2 / (a^2 / (n1 - 1) + b^2 / (n2 - 1))
    2 * pt(-abs((m1 - m2) / se), df)
  }

  # rounding box: a value printed to d decimals came from within +/- 0.5*10^-d
  h <- function(s) 0.5 * 10^(-dp(s))
  eps <- 1e-9
  box <- function(v, s, floor0 = FALSE) {
    lo <- v - h(s); hi <- v + h(s) - eps
    if (floor0) lo <- max(lo, eps)
    c(lo, hi)
  }
  b_m1 <- box(m1, m1s); b_m2 <- box(m2, m2s)
  b_s1 <- box(s1, s1s, TRUE); b_s2 <- box(s2, s2s, TRUE)

  # |t| is monotone in each of the four quantities, so the extremes of p over the
  # rounding box lie at its corners. Evaluating all 16 is exact for the pooled test
  # and a tight bound for Welch, whose df also shift with the SDs.
  grid <- expand.grid(m1 = b_m1, m2 = b_m2, s1 = b_s1, s2 = b_s2)
  ps <- mapply(p_student, grid$m1, grid$s1, n1, grid$m2, grid$s2, n2)
  pw <- mapply(p_welch,   grid$m1, grid$s1, n1, grid$m2, grid$s2, n2)

  naive_s <- p_student(m1, s1, n1, m2, s2, n2)
  naive_w <- p_welch(m1, s1, n1, m2, s2, n2)
  lo <- min(ps, pw); hi <- max(ps, pw)

  cat("INSPECT-SR check 4.9 — continuous results, accounting for rounding\n\n")
  cat(sprintf("  group 1: n=%g, mean=%s, sd=%s   -> mean in [%s, %s], sd in [%s, %s]\n",
              n1, m1s, s1s, fmt(b_m1[1]), fmt(b_m1[2]), fmt(b_s1[1]), fmt(b_s1[2])))
  cat(sprintf("  group 2: n=%g, mean=%s, sd=%s   -> mean in [%s, %s], sd in [%s, %s]\n\n",
              n2, m2s, s2s, fmt(b_m2[1]), fmt(b_m2[2]), fmt(b_s2[1]), fmt(b_s2[2])))

  cat("Naive p-values from the rounded summaries as printed (DO NOT treat as the answer):\n")
  cat("  pooled-variance t-test      p =", fmt(naive_s), "\n")
  cat("  Welch t-test                p =", fmt(naive_w), "\n\n")
  cat("Range of p-values CONSISTENT with the reported rounding:\n")
  cat("  p in [", fmt(lo), ", ", fmt(hi), "]\n\n", sep = "")

  if (!is.na(reported)) {
    if (reported >= lo && reported <= hi) {
      cat("-> CONSISTENT. The reported p =", reported,
          "lies inside the interval the rounded\n   summary data permit.",
          "This is not an error, even though the naive\n   recalculation differs.",
          "Answer 'No' for this comparison unless errors appear elsewhere.\n")
    } else {
      cat("-> INCONSISTENT. The reported p =", reported,
          "lies OUTSIDE the interval the rounded\n   summary data permit",
          sprintf("[%s, %s].\n", fmt(lo), fmt(hi)))
      cat("   Before answering 'Yes': consider undisclosed covariate adjustment, a different\n")
      cat("   analysis population, a non-parametric or paired test, or a transcription slip.\n")
      cat("   The guidance warns against basing the study judgement on one recalculation.\n")
    }
  }
  cat("\nIf EVERY continuous result in the paper reproduces exactly from rounded summaries,\n",
      "that is itself a warning sign — it can imply no underlying dataset was analysed.\n", sep = "")
  quit(status = 0)
}

stop("unknown mode '", mode, "' — use 'categorical' or 'continuous'")
