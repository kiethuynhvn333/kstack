# Knowledge maintenance

**Owner:** <name> · **Capture:** every session, `skills/session-close/` · **Weekly check:** cadence from
`workspace.md` → Defaults (default: weekly), `skills/weekly-knowledge-review/`

## Why capture happens at session end
A weekly batch asks the owner to approve work they no longer remember, so proposals either get waved
through or pile up. Deciding at the end of each session, while it is fresh, keeps the files honest.

## Memory states
1. **Session:** the worklog entry — Did / Next / Fixed knowledge / Unproven knowledge / Decided.
2. **Unproven:** a test Result or a `Hypothesis` row in the segment's `experiments.md` — never treated as fact.
3. **Fixed, project:** the segment's `knowledge.md` (Facts, Traps), plus a `decisions.md` row for a standing rule.
4. **Fixed, shared:** `knowledge/` — reached only by moving a project item up (↑) on the owner's yes.
5. **Historical:** `archive/` — kept, never default-loaded.

## Promotion gates (rule 42)
- **Unproven → fixed:** only with a trusted source, a checked analysis, an accepted experiment read, or
  the owner's direct confirmation. Keep the source's confidence words.
- **Project → shared:** the item holds outside the project, or recurs in 2+ segments, and the owner says
  yes in the weekly review. The project keeps a pointer.
- Strategy, metric definitions, customer claims, legal claims and commitments always need the owner's
  explicit approval — however strong the evidence.

Silence is not approval (rule 44). Every completed weekly review appends a row to `meta/review-log.md`.
