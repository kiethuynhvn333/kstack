---
name: quick-metric-self-check
description: Check a fresh number before you share it — grain, duplicates, fan-out, missing days, and a few raw examples. Use before presenting any unchecked query or report result, or when the user asks for a sanity check. This is a self-check, not an independent verification.
---

# Quick metric self-check

> **Step 0 — read first:** `rules/analysis.md` (rules 22–29)
> (repo root). This skill does that work, so load it before anything else.

A structural check on the whole result catches what you thought to check for. Looking at a few
real rows catches what you didn't. Do both — a clean aggregate check has hidden broken data before.

## 1. Write down the metric's hidden assumption
One sentence, before checking anything. "Average days live" quietly assumes the days are
continuous; "leads per user" assumes one row is one lead. Step 3 tests this sentence.

## 2. Check the whole result (cheap — add it to the same query)
| Risk | Check |
|---|---|
| Duplicates / fan-out | Does `COUNT(*)` equal `COUNT(DISTINCT <key>)` at the grain you report? |
| Wrong grain | Recompute the number a different way (other join order, distinct users vs rows) — do they match? |
| Missing or partial days | Every day in the range present? Is the latest day complete, or still loading (rule 24)? |
| Censoring | Are unfinished records (still live, cut off at the window edge) mixed in? |
| Label meaning | Does a field like "category" or "channel" mean what you assume? Check its definition. |

If any check fails, stop — that is the finding, not a footnote.

## 3. Look at 2–4 raw examples
One near the median, one at a notable tail. Read the actual rows — dates, flags, gaps — against
the sentence from step 1. Don't pick samples by whatever sort order is handy.

## 4. Say what you found
- **All clear:** say so, and say it was a self-check — same method, same blind spots (rule 26).
- **Something surprising:** report it as its own finding and what it changes about the number.
  If it could happen again, log it in `mistakes-and-learnings.md` (rule 41).
- **Headed into a decision or a canonical file:** it still needs an independent check — another
  source, a reconciliation, or another person or agent who doesn't see your method (rule 26).

This checks your query, not the source. It cannot catch a gap inside the table you queried.
