# Knowledge Index (shared knowledge)

**Owner:** <name> · **Last reviewed:** <YYYY-MM-DD>

The map of the **shared** knowledge layer. Start from the project, not here: the project's `README.md`
and each segment's `knowledge.md` (its **Depends on** table) name the shared files a task needs. Open
this index only when something is still missing (AGENTS.md rule 11), then load just that topic (rule 12).

## Two layers of knowledge
| Layer | Where | Holds |
|---|---|---|
| **Shared** (this folder) | `knowledge/` | Fixed knowledge true for every project: metric details, measurement and verification, platform mechanics, lessons that hold everywhere |
| **Project** | `projects/<p>/<segment>/knowledge.md` | Fixed knowledge for one project: its facts, Depends-on links, Traps (mistakes turned into rules) |
| Unproven (either) | `projects/<p>/<segment>/experiments.md` | Test results and `Hypothesis` rows — not canonical until verified |

**Moving knowledge up:** at session close a project item that would hold outside its project (or shows
up in 2+ segments) is marked ↑. The weekly review moves it here on the owner's yes; the project keeps a
one-line pointer. Nothing project-specific is written here directly.

## Map
| Topic | File |
|---|---|
| Metric details beyond the `workspace.md` table (edge cases, known gaps between sources) | `measurement/metrics.md` |
| How a number earns trust: tiers, stamp, trust ledger of verified queries, T1 check queries | `measurement/verification.md`, `measurement/verified-recipes.md`, `measurement/checks/` |
| Platform mechanics and lessons, one file per platform | `channels/<platform>.md` |
| Working lessons that hold across projects and fit no topic above | `universal-learnings.md` |
| Source maps, dashboards, exports | `references/` |
| How knowledge is captured, moved up and reviewed | `meta/maintenance.md`, `meta/review-log.md` |

Add a row whenever you add a topic file. A file nothing routes to is a file no agent will read.

## Task router
| Task | Shared files to add after the project files |
|---|---|
| Performance analysis or diagnosis | `measurement/metrics.md`, the platform's `channels/` file |
| Planning or reading an experiment | the platform's `channels/` file, `universal-learnings.md` |
| Live campaign change | the platform's `channels/` file (lessons learned) |
| Stakeholder report | `measurement/metrics.md` |
| Trust a number before showing or using it | `measurement/verification.md`, then the `skills/verify-number/` skill |
| Knowledge maintenance | `meta/maintenance.md`, `meta/review-log.md` |

## Loading limits
Never default-load `archive/`, skill `runs/`, or full worklog history. Keep this file ≤100 lines
and each topic ≤200 — split a long topic by decision domain rather than trimming it.
