## Output addition — 2026-11-24

The current version also prints Q_RW_s_real_199, the last-replication RW-Wald statistic, before its empirical p-value. Only this final display expression and documentation changed; all calculation expressions and RNG calls remain identical. The three-output descriptions below record the initial-version verification.

# Initial-version verification

This repository starts with the verified calculation version from predecessor commit abf2eb2, plus documentation and comment updates to introduce random weighting consistently. Its Git history begins with one initial commit. The records below describe pre-publication preservation checks and retain original-source provenance.

# RW cleanup verification — 2026-11-24

## Current baseline and scope

The pre-cleanup baseline was commit f13b653935986e1d56edbd0389621c1e12281def in the predecessor repository. This identifier records provenance; it is not a commit in this new repository. The current test replaces the earlier private-original structural check. Historical statements below describe the earlier version.

Changes remove unit block-size/index bookkeeping, rename WB identifiers to RW and block_w weights to random_w, and display only Q_s_real, Q_s_real_pv and Q_RW_s_pvalue_real_199. Fixed-coefficient and supplementary calculations remain. run.R was inspected and needs no identifier changes: it sources the primary script.

## Full calculation and RNG comparison

R 4.6.0 on Windows, with all 19 original imports installed, executed both programs in separate fresh R processes with test-only seed 165. The test evaluates every original top-level expression, observing each of the 199 outer-loop iterations without altering its body, formulas or random draws.

Using identical(), all 79 remaining workspace objects matched exactly after renaming and excluding the four removed bookkeeping objects (block_size, block_number, start_index, end_index). This includes OLS coefficients, residuals, covariance diagnostics, information matrices, ordinary and fixed-coefficient Wald results, both 199-element exceedance vectors, and both bootstrap p-values.

All 34,825 two-point weights, all 34,825 exponential weights, selected weights, all 199 bootstrap coefficient estimates and iteration-end RNG states matched exactly. Final complete-run .Random.seed states also matched. No imports, preprocessing or diagnostics were stubbed or replaced.

Results for this test seed (rounded for display):

- OLS coefficient rows: (0.431407063, -1.01506620), (0.003172177, -0.01255525).
- Q_s_real: 9.236255.
- Q_s_real_pv: 0.002372697.
- Q_RW_s_pvalue_real_199: 0.05527638 (11/199).

The analysis itself does not set a seed. These are equivalence checks, not independent validation of the paper's table or statistical conventions. Windows locale startup warnings and warnings that installed package binaries were built under R 4.6.1/4.6.2 did not prevent completion. A separate unseeded run through run.R completed and displayed only the three main result values; its bootstrap p-value naturally varies.

To repeat this historical comparison, supply a retained copy of the pre-cleanup original_analysis.R outside the repository and run from the repository root. The predecessor commit history is not included in this initial version:

    Rscript --vanilla tests/verify_preservation.R /path/to/pre_cleanup_original_analysis.R

The test prints sessionInfo() and fails on any object, weight or RNG mismatch. References to old WB/block names are intentional baseline mappings.

## Historical verification record (2026-11-09)

The following record is retained for original-source provenance. Its missing-package limitation and parsed-program equality statements describe the earlier verification only; the comparison above supersedes that limitation for this cleanup.

# Preservation verification — 2026-11-09

## Fixed seed removal

The analysis now uses the current R random-number state. The verification command below excludes the original `set.seed(165)` from the structural comparison and initializes both weight-loop checks with the same seed. The remaining sections record the earlier verification of the seeded version.

## Source and changes

The baseline is the attached original R research script supplied by the author, not the earlier condensed implementation. A local verification copy redirects only its private paths. This private baseline is not published because the supplied original contains personal directory names.

The primary public script translates the original comments into English, adds English explanatory comments, and redirects the two data paths. Private paths in inactive plotting comments are also sanitized. No executable statements are removed, reordered, refactored, or corrected. The original package imports and inactive code remain. All original Korean comments have been replaced with English explanations. Comment-only corrections clarify array dimensions and the stored exceedance indicators without changing executable statements.

## Completed checks

Using R 4.6.0 on Windows, `parse(..., keep.source = FALSE)` for the entire path-normalized original and primary script returned exactly identical expression trees. This covers all executable formulas, control flow, constants, imports, preprocessing, covariance calculations, diagnostics, and output expressions, rather than a selection of final formulas.

The original and revised weight-generation loops were separately executed for 199 iterations with 175 blocks and seed 165. All 34,825 two-point weights, all 34,825 exponential weights, and all 199 iteration-end `.Random.seed` states matched exactly using `identical()`. RNG kinds were `Mersenne-Twister`, `Inversion`, and `Rejection`. This is a scoped RNG check, not a claim that the complete analysis was run.

Both published data files were copied as bytes from the supplied attachments and checked against them. Their SHA-256 checksums are in `data/SHA256SUMS`. A scan of the proposed public files found no remaining personal absolute filesystem paths.

To repeat the structural and scoped RNG checks, prepare a local copy of the author's original with only its file paths redirected, then run from the repository root:

```sh
Rscript --vanilla tests/verify_preservation.R /path/to/path_only_original.R
```

## Not yet verified

The installed R environment lacks 18 of the 19 imported packages (only MASS is present). Consequently, neither full original nor full revised analysis was executed in this verification. Numerical equality of final Wald statistics, p-values, intermediate covariance matrices, and the complete-run RNG state remains unverified. Dependencies were not removed or replaced to manufacture a successful run. The startup also reported Windows locale-setting warnings.

For full verification, install the dependencies and run each complete script in a separate fresh R process with identical R/package versions and RNG settings. Compare all original result objects, both covariance diagnostics, both 199-element exceedance vectors, and the final `.Random.seed` exactly. Record `sessionInfo()` for both runs. The old archived CSVs are not new validation evidence for this primary script.

No comparison against a published paper table has been performed. 

## English-only documentation update

After translating the comments, the complete parsed-program equality and scoped RNG checks were rerun and passed. All tracked public text files were scanned for Hangul; no Korean text remains in the current files. The full-analysis verification limitations above remain unchanged.
