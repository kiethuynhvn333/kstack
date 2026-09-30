# Memory and learning — rules 37–45

**Load when:** writing to any memory file, ending a session, or running the knowledge review.

## Rules
37. When writing is allowed, finish substantive sessions by updating the active project's worklog
    with completed work, findings, approved decisions, evidence links, and the next resume point.
38. Record external actions with their date, destination, actual change, and verification result.
    Distinguish proposed, attempted, completed, and verified work.
39. Keep decisions in `decisions.md`, including scope, owner or approver, date, rationale, evidence,
    and any decision they replace.
40. Keep unresolved work in `open-items.md`, including status, owner, blocker, next action, and a
    review date when useful.
41. Record mistakes with the symptom, supported cause, correction, scope, and a repeatable
    prevention check. Connect that check to the workflow that needs it.
42. Put unreviewed lessons in `knowledge/meta/inbox.md`. Promote factual claims with traceable
    evidence; require owner approval for strategy, metric definitions, customer claims, legal
    claims, and commitments.
43. Give each fact or rule one authoritative home and link to it elsewhere. Keep record identifiers
    unique and never silently overwrite decision history.
44. Review knowledge at the agreed cadence. Propose corrections, supersession, deduplication, and
    archiving; do not treat silence as approval.
45. Keep active context compact. Archive superseded records with links to their replacements,
    preserve useful evidence, and respect privacy and retention requirements.

## Where things go
| What | Where |
|---|---|
| What happened this session | `projects/<p>/worklog.md` |
| Decision / open item / running test / mistake | `projects/<p>/<segment>/{decisions,open-items,experiments,mistakes-and-learnings}.md` |
| Lesson true beyond one project | `knowledge/universal-learnings.md` |
| Stable "how it works" knowledge | the matching `knowledge/` topic |
| Likely true, not yet confirmed | `knowledge/meta/inbox.md` |

The fields in rules 39–41 are the template columns — fill the columns, don't add free text.
New IDs (D- decision, C- mistake, O- open item, E- experiment, K- inbox) come from
`scripts/next-id.sh <prefix>`, never "the next number" in one file. Review cadence comes from
`workspace.md`; the review itself is `skills/weekly-knowledge-review/`.

## Session-end entry
```text
## YYYY-MM-DD — <topic>
Done:      what was completed (with evidence links)
Found:     findings, labeled fact / estimate / guess
Decided:   approved decisions (ID + approver)
Actions:   external changes — proposed / attempted / completed / verified
Open·Next: unresolved items (IDs) and the exact next resume point
```
