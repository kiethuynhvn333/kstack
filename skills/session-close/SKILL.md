---
name: session-close
description: End-of-session step — the one place knowledge is captured. Answers 4 questions about the session (what did we do, what are the next steps, any fixed knowledge, any unproven knowledge), writes the worklog entry in that layout, then proposes open items, fixed knowledge (the segment's knowledge.md, decisions.md) and unproven knowledge (an experiments.md row) for the user to approve while the session is still fresh. Never writes a row without approval. Use when the user says "wrap up", "done for today", "close the session", "end of session", or when a session that touched a project is ending.
---

# Session close — 4 questions, propose, write what the user approves

> **Step 0 — read first:** `rules/memory.md` (rules 37–45, repo root).

Why it exists: a weekly review asks the user to judge work they no longer remember. Here the user
decides while the session is fresh, so the files only hold what they actually agreed to.

Write in the user's working style (`profile.md`; default: plain words, short). The message the user
sees is **at most ~12 lines**, one line per item. Do the thinking silently.

## Two kinds of knowledge
| Kind | Means | Goes to |
|---|---|---|
| **Fixed** | Verified (a trusted source, a checked analysis, or the user's direct confirmation), unlikely to change, will shape what you do next time. Example: "on this account, broad match always leaks to unrelated searches". | The segment's `knowledge.md` (Facts, or a Traps row for a mistake). Also a `decisions.md` row only if it is a standing rule backed by evidence (rule 39). |
| **Unproven** | Looks true, needs more time or data. Example: "the new creative may lower cost per lead". | `experiments.md`: the running test's Result, or a new row with Status `Hypothesis`. Never `knowledge.md`. |

Keep each source's own confidence words ("one campaign", "not checked", "estimate"). Never upgrade
them. Unsure which kind → unproven.

## Steps
1. **Find the project and segment(s)** the session touched.
2. **Answer the 4 questions** from the session:
   1. **What did we do?** Work done; external actions with date, destination, change and state
      (proposed / attempted / completed / verified — rule 38).
   2. **What are the next steps?** Each with an owner and a trigger (date or event). If you can do it
      right now, do it instead.
   3. **Any fixed knowledge?** Claim, evidence, exact target file. Mark **↑** if it would hold outside
      this project (a metric definition, a platform mechanic, a rule for any project) or already
      appears in another segment.
   4. **Any unproven knowledge?** Claim with its confidence words, and the experiments row it goes to.
3. **Write the worklog entry** at the top of `projects/<p>/worklog.md` — always, no approval needed,
   no length limit. Format in `rules/memory.md`. Write the knowledge lines as `proposed`.
4. **Check existing rows** the session finished or changed: an open item done, a test concluded, a
   hypothesis verified (move it to `knowledge.md`) or disproven, a review date passed.
5. **Show the proposal:**
   ```
   Session close — <project>, <date>. Worklog written.
   Next → open items:     1. <what + who> → <file>
   Fixed knowledge:       2. <claim> → knowledge.md [↑]   3. Decision: <rule> → decisions.md
   Unproven knowledge:    4. <claim> → experiments.md (Hypothesis)
   Also: close <open item> (done) · <test> concluded
   Reply e.g. "1,2,4 yes". No reply = nothing written.
   ```
   Max 3 items per section; if more passed, say "+N left out".
6. **Write only what was approved**, exactly as approved. IDs from `scripts/next-id.sh <D|O|E|C>`.
   Fill every column (`unknown` rather than blank). Archive, never delete (rule 45). Update the worklog
   knowledge lines to `written` / `skipped`.
7. **Run `scripts/validate.sh`** and fix what it reports. If you cannot run shell, say so in the entry.
8. **Close in 2–3 lines:** what was written, what was skipped, then one bold line reminding the user
   nothing is backed up until they say **commit and push**.

## Don'ts
- Don't write rows, knowledge edits or experiments before the user's reply. Silence is not approval.
  Exception: the user says "log this" — write at once and say what you wrote.
- Don't put unproven knowledge in `knowledge.md`, or a fact in `decisions.md`.
- Don't pad the proposal with "might be useful" items.
