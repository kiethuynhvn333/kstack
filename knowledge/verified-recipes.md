# Verified Recipes (trust ledger)

**Owner:** <name> · **Last reviewed:** <YYYY-MM-DD> · **Policy:** `verification.md` (read it first)

A recipe = one saved query + the window and numbers it must reproduce. Once **verified**, a fresh
number from the *unchanged* query does not need another round trip to the independent checker.
Trust is tied to the query's hash: edit the query and `scripts/recipe-check.sh` marks it STALE.

Status: **verified** = golden numbers came from an independent source and your replay matches ·
**replayed** = your own earlier number reproduces (stable, NOT proven right) · **candidate** =
golden known, query not yet pinned or replayed · **stale** = hash changed or replay no longer matches.

| ID | Metric and scope | Query file | Hash | Golden (window → value) | Origin | Status | Verified on |
|---|---|---|---|---|---|---|---|
| R-000 | EXAMPLE (synthetic): kept orders per day, Example Co online store | - | - | 2026-01-01..31 → 412 orders/day | independent checker | candidate | - |

## How a row gets added
1. After the independent checker agrees (or a raw ground-truth join agrees), save the query under
   `knowledge/` and run `scripts/recipe-check.sh --hash <file>`.
2. Add a row. The window must be a **closed period** (finished month/week) so it can be replayed.
   Live numbers are never golden.
3. Replay once from the saved file; if it matches set Status (`verified` if the origin is
   independent, else `replayed`).
4. Never edit a Golden cell to make a replay pass. A mismatch is a finding: log it in
   `mistakes-and-learnings.md`.
