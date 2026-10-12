# Memory and learning — rules 37–45

**Load when:** writing to any memory file, ending a session, or running the weekly knowledge review.
Knowledge is captured at the **end of each session**, while it is fresh — not in a weekly batch.

## Rules
37. When writing is allowed, end every substantive session with `skills/session-close/`. It answers
    4 questions — what did we do, what are the next steps, any fixed knowledge, any unproven
    knowledge — writes the worklog entry, and proposes (never silently writes) the rest for approval.
38. Record external actions with their date, destination, actual change, and verification result.
    Distinguish proposed, attempted, completed, and verified work.
39. `decisions.md` holds only standing rules that would cause a real, repeatable mistake if ignored,
    with scope, approver, date, evidence (experiment ID or analysis), and what they replace.
40. Keep unresolved work in `open-items.md`: status, owner, blocker, next action, review date.
41. A mistake becomes a **Traps** row in the segment's `knowledge.md`: symptom, supported cause,
    correction, scope, and a repeatable prevention check connected to the workflow that needs it.
42. **Fixed knowledge** (verified, unlikely to change, shapes future action) goes to the segment's
    `knowledge.md`. **Unproven knowledge** (needs time to verify) goes to `experiments.md` — a running
    test's Result or a `Hypothesis` row. Keep the source's own confidence words; repetition, recency
    or an agent saying so is not evidence. Strategy, metric definitions, customer and legal claims,
    and commitments always need the owner's approval.
43. Give each fact or rule one home and link to it elsewhere. IDs come from `scripts/next-id.sh`;
    never silently overwrite decision history.
44. Weekly (`skills/weekly-knowledge-review/`): move ↑ items up to shared `knowledge/` on the owner's
    yes, flag sessions that skipped session-close, audit experiments. Silence is not approval.
45. Keep active context compact: archive (never delete) finished rows and worklog entries older
    than 7 days, with links to what replaced them.

## Where things go
| What | Where |
|---|---|
| What happened in a session | `projects/<p>/worklog.md` (no length limit; >7 days → `archive/` weekly) |
| Next steps | worklog **Next** line + `projects/<p>/<segment>/open-items.md` |
| A standing rule with evidence | `projects/<p>/<segment>/decisions.md` |
| Fixed knowledge for one project, incl. Traps | `projects/<p>/<segment>/knowledge.md` |
| Unproven knowledge | `projects/<p>/<segment>/experiments.md` (Result, or a `Hypothesis` row) |
| Fixed knowledge true beyond one project | shared `knowledge/` — `measurement/`, `channels/`, `universal-learnings.md` — only via ↑ and the weekly review |

- **Down:** the project `README.md` and each segment's `knowledge.md` **Depends on** table name the
  shared files to load. Agents read the project first, then follow those links.
- **Up:** mark a fixed item ↑ if it would hold outside the project (a metric, a platform mechanic, a
  rule for any project) or shows up in 2+ segments. A fact, link or URL is not a decision.
- New IDs: D- decision, O- open item, E- experiment (and hypothesis), C- trap — from
  `scripts/next-id.sh <prefix>`. Date check at session start: tell the user in one line about any
  Planned test past its start, Running past its end, Hypothesis past its verify-by date, or open item
  past its review date. Never close or mark Concluded by inference (rule 44).

## Session-end worklog entry (rule 37)
```text
## YYYY-MM-DD (<segment>) — <topic>
**Did:**                what was done (evidence links); external actions + state
**Next:**               next steps (O- IDs once approved, else "not tracked: …")
**Fixed knowledge:**    claim → file [↑]   (proposed → written / skipped)
**Unproven knowledge:** claim (confidence words) → experiments.md row
**Decided:**            decisions the user made this session (D- ID if written)
```
Then run `scripts/validate.sh` and fix what it reports; if you cannot run shell, say so in the entry.
