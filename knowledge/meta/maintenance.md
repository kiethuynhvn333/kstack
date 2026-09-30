# Knowledge maintenance

**Owner:** <name> · **Cadence:** from `workspace.md` → Defaults (default: weekly, or at 20 inbox items)
**Skill:** `skills/weekly-knowledge-review/`

## Memory states
1. **Working:** the newest worklog entries.
2. **Candidate:** a row in `meta/inbox.md` — never treated as fact.
3. **Canonical:** a reviewed `knowledge/` topic, plus a decision row where one applies.
4. **Historical:** `archive/` — kept, never default-loaded.

## Promotion gate (rule 42)
Promote only with owner confirmation, a primary source, or an accepted analysis or experiment.
Strategy, metric definitions, customer claims, legal claims and commitments always need the
owner's explicit approval — however strong the evidence.

## Review actions
- **Promote:** write it into its one canonical home and record who approved.
- **Supersede:** replace the old claim and note what changed and why.
- **Deduplicate:** keep one home; replace copies with links (rule 43).
- **Defer:** say what evidence is missing; keep the candidate.
- **Drop:** say why it was rejected.

Silence is not approval (rule 44). Every completed review appends a row to `meta/review-log.md`.
