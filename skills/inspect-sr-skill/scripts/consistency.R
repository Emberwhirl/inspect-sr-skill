#!/usr/bin/env Rscript
# INSPECT-SR checks 4.10, 4.6 and 4.3 — arithmetic contradictions implied by the data
#
# Both modes deliberately resolve rounding IN THE AUTHORS' FAVOUR before declaring
# anything impossible. Small apparent contradictions are usually just rounding, and
# the guidance's own worked example turns on showing that the gap survives even the
# most generous rounding available.
#
# Usage
#   Rscript consistency.R subgroups --n "30,11" --mean "6.2,7.4" --overall 7.3
#   Rscript consistency.R percent --numerator 12 --denominator 50 --reported 24.0
#   Rscript consistency.R percent --reported 24.3 --max-n 200
#
# Base R only; no packages required.

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0 || any(args %in% c("-h", "--help"))) {
  cat(readLines(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)))[2:17], sep = "\n")
  quit(status = 0)
}
mode <- args[1]
get_arg <- function(flag, default = NA_character_) {
  i <- match(flag, args); if (is.na(i) || i == length(args)) return(default); args[i + 1]
}
dp <- function(s) if (!grepl("\\.", s)) 0L else nchar(sub("^[^.]*\\.", "", s))
splitnum <- function(s) as.numeric(strsplit(s, "[,;[:space:]]+")[[1]])
f <- function(x, d = 4) formatC(x, format = "f", digits = d)

# ==================================================================================
if (mode == "subgroups") {
  n_s <- get_arg("--n"); m_s <- get_arg("--mean"); ov_s <- get_arg("--overall")
  if (is.na(n_s) || is.na(m_s)) stop('supply --n "30,11" --mean "6.2,7.4" [--overall 7.3]')
  ns <- splitnum(n_s)
  m_txt <- strsplit(m_s, "[,;[:space:]]+")[[1]]; m_txt <- m_txt[nzchar(m_txt)]
  ms <- as.numeric(m_txt)
  if (length(ns) != length(ms)) stop("--n and --mean must have the same number of entries")

  h <- 0.5 * 10^(-sapply(m_txt, dp))         # rounding half-width per subgroup mean
  N <- sum(ns)
  point <- sum(ns * ms) / N
  lo <- sum(ns * (ms - h)) / N
  hi <- sum(ns * (ms + h)) / N

  cat("INSPECT-SR check 4.10 — do the subgroups recombine to the overall mean?\n\n")
  print(data.frame(subgroup = seq_along(ns), n = ns, mean = m_txt,
                   implied_range = paste0("[", f(ms - h), ", ", f(ms + h), "]"),
                   stringsAsFactors = FALSE), row.names = FALSE)
  cat("\n  total n across subgroups :", N, "\n")
  cat("  weighted mean as printed :", f(point), "\n")
  cat("  achievable range once subgroup rounding is pushed to both extremes:\n")
  cat("                             [", f(lo), ", ", f(hi), "]\n", sep = "")

  if (!is.na(ov_s)) {
    ov <- as.numeric(ov_s); oh <- 0.5 * 10^(-dp(ov_s))
    o_lo <- ov - oh; o_hi <- ov + oh
    cat("\n  reported overall mean    :", ov_s, "-> could be anything in [",
        f(o_lo), ",", f(o_hi), "]\n")
    if (hi < o_lo || lo > o_hi) {
      cat("\n-> IMPOSSIBLE. The two ranges do not overlap. Even resolving every rounding\n")
      cat("   decision in the authors' favour, the subgroups cannot produce the reported\n")
      cat("   overall mean. Shortfall at the closest point:",
          f(max(o_lo - hi, lo - o_hi)), "\n")
      cat("   Check first that the subgroups are exhaustive and mutually exclusive, and\n")
      cat("   that the overall figure covers the same population and timepoint.\n")
    } else {
      cat("\n-> CONSISTENT. The reported overall mean falls within what the subgroups can\n")
      cat("   produce once rounding is accounted for. No contradiction demonstrated.\n")
    }
  }
  cat("\nNote: the guidance treats 4.10 as an overflow check for contradictions not already\n",
      "caught by 4.1-4.9, and says these arise too infrequently to warrant routine checking.\n",
      "Record them when observed rather than hunting for them systematically.\n", sep = "")
  quit(status = 0)
}

# ==================================================================================
if (mode == "percent") {
  rep_s <- get_arg("--reported")
  if (is.na(rep_s)) stop("supply --reported")
  reported <- as.numeric(rep_s); d <- dp(rep_s)
  h <- 0.5 * 10^(-d)
  num_s <- get_arg("--numerator"); den_s <- get_arg("--denominator")

  if (!is.na(num_s) && !is.na(den_s)) {
    num <- as.numeric(num_s); den <- as.numeric(den_s)
    actual <- 100 * num / den
    cat("INSPECT-SR — does the reported percentage match its denominator?\n\n")
    cat("  reported   :", rep_s, "% -> consistent with anything in [",
        f(reported - h, d + 2), ",", f(reported + h, d + 2), "]\n")
    cat("  ", num, "/", den, "     : ", f(actual, 4), "%\n", sep = "")
    if (abs(round(actual, d) - reported) < 1e-12) {
      cat("\n-> CONSISTENT.\n")
    } else {
      cat("\n-> MISMATCH. Before treating this as a finding, check whether the denominator\n")
      cat("   is the randomised, analysed, or completing population — differing denominators\n")
      cat("   are the usual explanation, and are a reporting problem rather than necessarily\n")
      cat("   a trustworthiness one.\n")
    }
    cat("\n")
  }

  max_n <- suppressWarnings(as.numeric(get_arg("--max-n", "0")))
  if (!is.na(max_n) && max_n > 0) {
    cat("Denominators that could produce ", rep_s, "%",
        " (n = 1..", max_n, "):\n\n", sep = "")
    hits <- list()
    for (den in 1:max_n) {
      k <- 0:den
      ok <- which(abs(round(100 * k / den, d) - reported) < 1e-12)
      if (length(ok)) for (i in ok) hits[[length(hits) + 1]] <- c(k[i], den)
    }
    if (!length(hits)) {
      cat("  NONE. No group size up to", max_n, "can produce this percentage.\n")
      cat("  That is a hard inconsistency, subject to checking the reported precision.\n")
    } else {
      hm <- do.call(rbind, hits)
      show <- head(hm, 40)
      cat(paste0("  ", show[, 1], "/", show[, 2],
                 "  (", f(100 * show[, 1] / show[, 2], 3), "%)", collapse = "\n"), "\n")
      if (nrow(hm) > 40) cat("  ... and", nrow(hm) - 40, "more\n")
      cat("\n  If the paper's stated group size is absent from this list, the percentage and\n")
      cat("  the denominator cannot both be right.\n")
    }
  }
  quit(status = 0)
}

stop("unknown mode '", mode, "' — use 'subgroups' or 'percent'")
