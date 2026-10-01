---
name: verify-number
description: The one entry point for trusting a number before it is shown or used. Runs cheap checks first (SQL lint, grain/freshness/invariants, golden replay of a saved recipe), stamps the result with what was and was not checked, and goes to the independent checker only when the method is new or changed, batched and without waiting. Use before presenting a fresh number, before writing one into a canonical file or report, and before a live change.
---

# Verify a number

> **Step 0 — read first:** `rules/analysis.md` (rules 22–29)
> (repo root). This skill does that work, so load it before anything else.

Policy, tiers and the stamp format: `knowledge/verification.md`. Read it once per session. The
independent checker (who, how to reach, how long it takes) is in `workspace.md` → Verification.

1. **Say what the number is and what it's for.** One line: metric, scope, window, source. Write the
   required level in one line with all its parts (e.g. "report → T0 + T1 + T2, or T3 if the method is
   new"), picked from the policy table. Don't over-verify an exploration; don't under-verify a
   budget decision.
2. **T0 — lint and self-check (always).** Save the query to a file and run
   `scripts/sql-lint.sh <file.sql>`. FAIL = stop and fix before running. WARN = mention it next to
   the number. If the flagged pattern is deliberate, ask the user; only with their OK add
   `-- lint-allow: <ID> <reason>` to the query (the lint prints ALLOWED + the reason). Never add it
   yourself, and list it under `Allowed:` in the stamp.
   Run `skills/quick-metric-self-check/`. Its checks read real rows, so they need data access. If
   you can't query (no connector, no result in hand), do NOT call the self-check done: the stamp
   says "T0 lint clean, self-check not run (no data access)". Search the project's
   `mistakes-and-learnings.md` for the metric first (rule 17).
3. **T1 — grain, freshness, invariants (shown in chat or higher).** Run the matching file in
   `knowledge/checks/` over the same window. A non-zero HARD column is the finding. Use `MAX(date)`
   as the as-of date and state it. Compute the metric's own math rules on your result.
4. **T2 — recipe replay (canonical, report, or live change).** Find the row in
   `knowledge/verified-recipes.md`; run `scripts/recipe-check.sh`. Match + hash OK + `verified`
   → replay the golden window; if it reproduces, a new window from the same unchanged query
   inherits that trust. No row, `replayed`/`candidate`, or STALE → go to T3. A replay that
   doesn't match is a finding: log it, never tune the golden.
5. **T3 — independent source (only if T2 can't cover it).** Prefer a raw ground-truth join when
   it's cheap. Otherwise ask the independent checker: **one batched message, non-blocking** —
   continue working, mark dependents `T3 pending`. On a match, add or upgrade a ledger row
   (closed-period golden, hash from `scripts/recipe-check.sh --hash`). A raw join that uses a filter
   you chose checks the pipeline, not the definition: label it "T3 raw join (own definition)", and if
   it disagrees with the table, suspect a definition difference (`knowledge/metrics.md`) first. On a mismatch, log a `C-`
   row (`scripts/next-id.sh C`) with both methods and numbers; no silent winner. Sending a message
   needs the user's approval unless `workspace.md` → Permissions already grants it (rule 35).
6. **Stamp it.** Put the stamp directly under the numbers, before any recommendation. If T3
   disagreed, add a `Contested:` line (both numbers, the gap, the open question) and don't call
   either number wrong until it's answered. Save any query that feeds a decision in the repo, not a
   temp folder. End the number with the stamp block from the policy: as-of date, query path, tiers
   run, tiers pending, one line of what is **not** covered. Plain words, short.
7. **Learn from it.** If a check caught something, or the user corrected the number: add a lint
   rule + fixtures, a T1 invariant, or a golden row, or run `skills/fix-and-save-mistake/`. Then
   run `scripts/sql-lint.sh --selftest` and `scripts/recipe-check.sh`.
