---
name: weekly-knowledge-review
description: The weekly self-update of the knowledge base — scan recent sessions and project files, find missed decisions and lessons, conflicts, stale and duplicate items, and propose evidence-backed changes for the owner to approve. Use on the review cadence, when the inbox reaches 20 items, or when the user asks to review or clean up knowledge.
---

# Weekly knowledge review

> **Step 0 — read first:** `rules/memory.md` (rules 37–45)
> (repo root). This skill does that work, so load it before anything else.

This is how a week of project work becomes durable knowledge. It proposes; the owner decides.
It never changes a canonical file before the owner approves (rules 42, 44).

## 1. Set the window
1. Read `knowledge/meta/maintenance.md` and the last row of `knowledge/meta/review-log.md`.
2. The window runs from that review to today (7 days if there's no earlier review). If reviews
   were skipped, cover the whole gap and say so — don't quietly shrink it.
3. Use `git log --since=<date> --name-only` to list what changed.

## 2. Scan every project, every segment
Read the window's worklog entries and changed rows in each project's decisions, open-items,
experiments and mistakes-and-learnings — including quiet segments. For each possible lesson
note: the exact claim, its type, the source file and date, the evidence, confidence, one
destination, and any conflict with current knowledge.
Repetition, recency, or an agent saying so is not evidence.

## 3. Sort each candidate
Promote · Supersede · Deduplicate · Defer · Drop (definitions in `knowledge/meta/maintenance.md`).
Also check:
- **Experiments:** mark each row Running, Concluded or Unclear from its own text. Never infer
  Concluded from silence or an old date — Unclear rows need the owner's answer.
- **Open items:** stale rows go to the owner; never close one just because it's quiet.
- **IDs:** run `scripts/validate.sh` — it fails on duplicate or wrong-prefix IDs.

## 4. Show the report, then stop
Window and files scanned · missed decisions and lessons · conflicts and stale items · proposed
disposition per candidate · the exact file-by-file changes · the experiment status table ·
questions for the owner. Wait for approval. Silence is not approval.

## 5. Apply only what was approved
1. Write each approved claim into its one home: a `knowledge/` topic, or
   `knowledge/universal-learnings.md` if it holds across projects.
2. New rows get IDs from `scripts/next-id.sh`. Update inbox statuses; move resolved rows to `archive/`.
3. Move experiments the owner confirmed Concluded to `archive/<YYYY-MM>/<project>-<segment>-experiments-closed.md`.
4. Append one row to `knowledge/meta/review-log.md`. Run `scripts/validate.sh`.

**Done when:** every approved promotion is in its file, archived rows are gone from live files
(not just copied), the review-log row exists, and validation passes.
