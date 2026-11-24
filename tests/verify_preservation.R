# Compare the pre-cleanup public script with the current script in fresh R processes.
# Usage: Rscript --vanilla tests/verify_preservation.R PATH_TO_BASELINE
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 3L && args[1] == "--worker") {
  program <- parse(args[2], keep.source = FALSE)
  e <- new.env(parent = globalenv())
  trace <- list()
  set.seed(165) # Verification only; never added to the analysis.
  for (expr in program) {
    if (is.call(expr) && identical(expr[[1]], as.name("for")) &&
        identical(expr[[2]], as.name("k"))) {
      # Observe each iteration without changing draws or calculations.
      for (iteration in eval(expr[[3]], e)) {
        e$k <- iteration
        eval(expr[[4]], e)
        weight_prefix <- if (exists("block_w", e, inherits = FALSE)) "block_w" else "random_w"
        theta_name <- if (exists("WB_theta_real_199", e, inherits = FALSE)) "WB_theta_real_199" else "RW_theta_real_199"
        trace[[iteration]] <- list(
          be = e[[paste0(weight_prefix, "_be")]],
          ex = e[[paste0(weight_prefix, "_ex")]],
          selected = e[[weight_prefix]],
          theta = e[[theta_name]],
          seed = .Random.seed)
      }
    } else eval(expr, e)
  }
  saveRDS(list(objects = as.list(e), trace = trace, seed = .Random.seed,
               session = sessionInfo()), args[3])
} else {
  stopifnot(length(args) == 1L)
  script <- normalizePath("tests/verify_preservation.R")
  baseline <- normalizePath(args[1])
  files <- c(baseline, normalizePath("original_analysis.R"))
  results <- lapply(files, function(file) {
    out <- tempfile(fileext = ".rds")
    on.exit(unlink(out))
    status <- system2(file.path(R.home("bin"), if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript"),
                      c("--vanilla", shQuote(script), "--worker", shQuote(file), shQuote(out)))
    stopifnot(status == 0L)
    readRDS(out)
  })
  old <- results[[1]]
  new <- results[[2]]
  removed <- c("block_size", "block_number", "start_index", "end_index")
  old$objects[removed] <- NULL
  names(old$objects) <- gsub("block_w", "random_w", gsub("WB", "RW", names(old$objects), fixed = TRUE), fixed = TRUE)
  stopifnot(setequal(names(old$objects), names(new$objects)))
  for (name in names(old$objects)) {
    if (!identical(old$objects[[name]], new$objects[[name]])) stop("Mismatch: ", name)
  }
  stopifnot(identical(old$trace, new$trace), identical(old$seed, new$seed))
  cat("PASS: all", length(new$objects), "remaining analysis objects match exactly after renaming.\n")
  cat("PASS: all 34,825 two-point and exponential weights, selected weights, 199 coefficient estimates and iteration-end RNG states match exactly.\n")
  cat("PASS: complete-run final RNG states match exactly.\n")
  for (name in c("OLS_theta_real", "Q_s_real", "Q_s_real_pv", "Q_RW_s_pvalue_real_199")) {
    cat(name, "\n"); print(new$objects[[name]])
  }
  print(new$session)
}
