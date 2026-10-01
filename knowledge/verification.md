# Verification — how a number earns trust

**Owner:** <name> · **Last reviewed:** <YYYY-MM-DD> · **Skill:** `skills/verify-number/`

**The idea.** Don't send every number to the person or bot who owns the data. Verify the **method**
once with them, save it as a recipe (`verified-recipes.md`), and let cheap automatic checks cover
everything after. Ask the independent checker only when the method is new or changed. Every number
leaves with a **stamp** saying what was checked, so you can see in 10 seconds how far to trust it.
(Inspired by Lauren Tan's pstack: verification is infrastructure, build the lever, evidence over explanation.)

## The tiers — cheapest first, each says what it can NOT catch
| Tier | What it is | Cost | Catches | Does NOT catch |
|---|---|---|---|---|
| T0 | `scripts/sql-lint.sh` on the query + `skills/quick-metric-self-check/` | seconds | known text-detectable traps from your own past mistakes | anything new; a clean lint is a smell test, not proof |
| T1 | Freshness, grain and invariants on the source (`knowledge/checks/`) | one query | missing days, duplicate rows, impossible values, stale tables | a wrong-but-consistent number (a bad filter that keeps the math tidy) |
| T2 | Golden replay: a recipe's saved query still reproduces its recorded closed-period numbers | one query | the query or table drifting since it was verified | a recipe wrong from the start, if its golden came from your own earlier number |
| T3 | Independent source: raw ground-truth join, another source, or the independent checker in `workspace.md` → Verification | minutes to hours | method errors, wrong scope, wrong definition | what the checker shares with you (same tables, same blind spot) |

## T1 invariants — write yours from the metric definitions
Typical: every day in the range present; one row per declared grain; parts sum to the whole;
funnel steps never grow (impressions ≥ clicks ≥ visits); unique converters ≤ conversions; cost ties
to the platform at the same scope; the latest day is complete, not still loading (rule 24).
**Calibrate every invariant on real data before trusting it.** One that fires on normal data
(platform quirks, null cost on non-spending rows) teaches everyone to ignore alarms. Mark each
check HARD (stop) or INFO (report only), and put the observed baseline in the file's header.

## Required tier by use (override in `workspace.md` → Verification)
| The number will… | Minimum |
|---|---|
| be a rough look while exploring | T0; stamp says "unverified" |
| be shown to the user in chat as a result | T0 + T1 |
| go into a canonical file, stakeholder report, or decision/experiment row | T0 + T1 + (T2 if the recipe is `verified`, else T3) |
| be the basis for a live change (budget, bid, targeting, pause) | T0 + T1 + T2 on a `verified` unchanged recipe, else T3 |

A recipe is trusted only if its status is **verified** (independent origin) and
`scripts/recipe-check.sh` says its hash still matches. `replayed` (self-origin) never replaces T3.

Say the required level in one line, with ALL its parts, before running anything (e.g. "report → T0 + T1 + T2, or T3 if the method
is new"). Never shorten it to "lint + freshness".

## The stamp — end of every number the user will act on
```text
Verified: T0 lint clean · T1 pass (30/30 days, 0 invariant breaks) · T2 R-004 replay ok · T3 pending
Source: <table>, as of <MAX(date)> · query: <path or inline>
Allowed: <only if a lint-allow was used: rule ID + the reason, user-approved>
Contested: <only if T3 disagreed: both numbers, the gap, the open question. Neither is called wrong yet>
Not checked: <what this stamp does NOT cover, one line>
```
No stamp = unverified. A tier you did not run is written "not run", never left out.

## Asking the independent checker less, and never idling
- **Batch:** one message per session with every open claim, numbered.
- **Don't block:** send it, keep working, mark dependent numbers `T3 pending` in the stamp and the
  worklog's Open/Next; read the reply at session end and at the next session start.
- **Ask once, keep forever:** a match becomes a ledger row (closed-period golden + hash). The same
  recipe is not asked again until its hash or a definition changes.
- **Skip the ask** when a `verified` recipe covers the claim, its hash matches, and T1 passes.

## Every wrong number becomes structure
When a `C-` row is a wrong-number mistake, turn it into at least one of: a `scripts/sql-lint` rule
(with bad+good fixtures), a T1 invariant, a golden recipe, or a `fix-and-save-mistake` case. If none
fits, say why in the C- row.

## Honest limits
- `sql-lint` matches text; it misses traps written a new way and can flag deliberate patterns.
- Nothing here runs by itself. A gate that is only written down is not a gate (rule 30). If your
  tool supports hooks, a hook that runs `scripts/sql-lint.sh` before each query is the next step —
  with the user's approval and a test that it fires.
- `-- lint-allow:` is only as honest as whoever writes it: the reason prints next to the number and
  appears in the stamp, and it needs the user's OK.
- A golden from your own earlier number proves stability, not truth. Only an independent origin counts.
