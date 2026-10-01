# Knowledge Index

**Owner:** <name> · **Last reviewed:** <YYYY-MM-DD>

The router for `knowledge/`. Open it only after you know the active project (AGENTS.md rule 11),
then load just the topic(s) the task needs (rule 12).

## What lives here vs `projects/`
- **`knowledge/`** — things that are *true* and change slowly: metric details, platform
  mechanics, measurement method, lessons that hold across projects. Read it to learn *how* or *why*.
- **`projects/`** — things that are *happening*: decisions, open items, experiments, mistakes,
  per segment. Read it to learn *what's going on now*.

## Map
| Topic | File |
|---|---|
| Metric details beyond the `workspace.md` table (edge cases, known gaps between sources) | `metrics.md` |
| Platform mechanics and lessons, one file per platform | `channels/<platform>.md` |
| Lessons that hold across projects | `universal-learnings.md` |
| How a number earns trust: tiers, stamp, trust ledger of verified queries, T1 check queries | `verification.md`, `verified-recipes.md`, `checks/` |
| Source maps, dashboards, exports | `references/` |
| Candidate knowledge, not yet confirmed | `meta/inbox.md` |
| How knowledge gets reviewed and promoted | `meta/maintenance.md`, `meta/review-log.md` |

Add a row whenever you add a topic file. A file nothing routes to is a file no agent will read.

## Task router
| Task | Read after AGENTS.md and the project files |
|---|---|
| Performance analysis or diagnosis | `metrics.md`, the platform's `channels/` file |
| Planning or reading an experiment | the platform's `channels/` file, `universal-learnings.md` |
| Live campaign change | the platform's `channels/` file (lessons learned) |
| Stakeholder report | `metrics.md` |
| Trust a number before showing or using it | `verification.md`, then the `skills/verify-number/` skill |
| Knowledge maintenance | `meta/maintenance.md`, `meta/inbox.md`, `meta/review-log.md` |

## Loading limits
Never default-load `archive/`, skill `runs/`, or full worklog history. Keep this file ≤100 lines
and each topic ≤200 — split a long topic by decision domain rather than trimming it.
