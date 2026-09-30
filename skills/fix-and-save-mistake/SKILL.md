---
name: fix-and-save-mistake
description: When the user corrects the agent or asks to log a mistake, find the real cause, fix the source, and save a rerunnable regression check so the same mistake is caught next time.
---

# Fix and save a mistake

> **Step 0 — read first:** `rules/memory.md` (rules 37–45)
> (repo root). This skill does that work, so load it before anything else.

Use when the user asks, or offer it when the user corrects you (AGENTS.md rule 20).

1. Read `skills/fix-and-save-mistake/verification-contract.md`. Search existing cases in
   `cases/` and the project's `mistakes-and-learnings.md` first — reuse a case if it's the same failure.
2. Write down the wrong result and the intended one. Separate the confirmed cause from a guess.
   Don't accept either the original answer or the correction on faith — check the evidence.
3. Fix the smallest source that caused it: a query, a skill step, a knowledge file. If a rule
   for it already existed, find out why it was missed instead of copying the rule somewhere else.
4. Log it in the project's `mistakes-and-learnings.md` with an ID from `scripts/next-id.sh C`
   (rule 41). Put the prevention check in the workflow that needs it and fill "Wired into".
5. Save a case in `cases/<short-id>.md` that follows the contract.
6. Run it with `skills/run-verification-tests/`. Show the negative control fails on the old
   behavior and the fixed source passes — using temporary copies, not by reverting live files.
   If you can't reproduce, fix or run it, keep the case, mark it UNABLE, and don't call it fixed.
7. Tell the user briefly: the cause, the fix, the case ID, the result, and the phrase to rerun it.

This skill does not authorize sending messages or changing live campaigns (rules 33, 35).
