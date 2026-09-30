---
name: run-verification-tests
description: Rerun saved mistake regression cases and report PASS, FAIL or UNABLE with evidence. Use when the user asks to run the tests, or when fix-and-save-mistake validates a new case.
---

# Run verification tests

> **Step 0 — read first:** `rules/memory.md` (rules 37–45)
> (repo root). This skill does that work, so load it before anything else.

1. Read `skills/fix-and-save-mistake/verification-contract.md`.
2. List the cases in `skills/fix-and-save-mistake/cases/`. Run the IDs asked for, or all of them
   if the user asks for the full suite. No cases means NO TESTS, not PASS. A missing or malformed
   case is UNABLE.
3. For each case, check its prerequisites, then run its actual command, read-only check, or
   fresh-agent evaluation. Respect cost and permission limits (rules 33, 35). If it can't run,
   mark UNABLE and move on. Never run a destructive command you haven't reviewed.
4. Compare what happened with the case's pass conditions. Record passes and failures alike.
5. Save a dated record in `skills/run-verification-tests/runs/<YYYY-MM-DD>-<case-id>.md`. Never
   overwrite an earlier run, and never fix the source or the test while checking.
6. Report counts and the failed/UNABLE IDs in a few lines, linking the record. Offer
   `fix-and-save-mistake` for failures — a request to check is not a request to fix.

Runs happen when the user asks. Don't schedule them or add them to session start (rule 35).
Code tests don't prove the agent behaves; agent tests don't prove the live data is complete.
