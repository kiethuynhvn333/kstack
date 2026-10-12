---
name: weekly-knowledge-review
description: The short weekly knowledge check. Knowledge is captured at the end of each session by skills/session-close/; this skill only (1) asks the owner yes/no on moving project knowledge marked ↑ up to the shared knowledge/ folder, (2) flags sessions that skipped session-close, (3) audits experiments and hypotheses (running, overdue, concluded), and (4) moves worklog entries older than 7 days to archive/. Use on the review cadence in workspace.md, or when the user asks to review knowledge or audit experiments.
---

# Weekly knowledge review

> **Step 0 — read first:** `rules/memory.md` (rules 37–45, repo root).

Every item shown here is something the owner already approved once at session close, or a test
with a date, so they can answer without re-reading the week. The whole message fits on one screen.
Nothing changes before the owner answers (rule 44).

## 1. Window
The window runs from the last row of `knowledge/meta/review-log.md` to today (7 days if there is no
earlier review). If reviews were skipped, cover the whole gap and say so.

## 2. Move-up check (↑ items)
Find every ↑ in the projects' `knowledge.md` files (`grep -rn '↑' projects --include=knowledge.md`),
skipping lines already marked "moved up". For each, propose one line: `<claim> → <shared file>`
(`knowledge/measurement/` for metrics and data, `knowledge/channels/<platform>.md` for platforms,
`knowledge/universal-learnings.md` for working lessons). On yes: write it into the shared file with
its evidence and confidence words, and replace the project line with `→ moved up to <file> (date)`.
On no: remove the ↑ and add `kept in project`.

## 3. Missed captures
List worklog entries in the window with no **Fixed knowledge** / **Unproven knowledge** lines
(session-close was skipped). Don't rebuild their knowledge yourself — offer to run session-close on
that topic now, or skip.

## 4. Experiment audit
For every row in every `experiments.md`: **Running** (date not passed), **Overdue** (end or verify-by
date passed, no result), **Concluded** (the row itself says so). Never infer Concluded from silence or
an old date. Propose: archive concluded / stopped / verified / disproven rows, and one line per
overdue row.

## 5. Show, wait, apply
Message: `Move up?` list · `Missed sessions` · `Experiments: archive / overdue`. Wait for answers.
Then apply what was approved, move worklog entries older than 7 days to
`archive/<YYYY-MM>/<project>-worklog.md` (copy first, check, then remove from the live file), append
one row to `knowledge/meta/review-log.md`, and run `scripts/validate.sh`.

**Done when:** approved move-ups are in their shared files, archived rows are gone from live files
(not just copied), the review-log row exists, and validation passes.
