<!-- HOW TO USE THIS TEMPLATE (setup does this; delete this comment block in the copy)
1. Copy `projects/_template/` to `projects/<project-folder>/` (folder name from workspace.md → Objectives).
2. Copy `_segment/` once per segment in workspace.md → Segments, renamed to the segment
   (e.g. `sofas/`, `beds/`), plus one `cross-segment/` for work that spans segments.
3. Delete `_segment/` from the copy, fill in the brief below. Leave `projects/_template/` itself untouched.
Every table row gets its ID from `scripts/next-id.sh <D|O|E|C>` — one sequence for the whole repo,
never "the next number" in one file (rule 43). Fill every column; write `unknown` rather than blank.
-->
# <Project name> — brief and map

**Owner:** <name> · **Objective:** <copied from workspace.md → Objectives> · **Last reviewed:** <YYYY-MM-DD>

## What this project is
<Two or three plain sentences: the objective, the key results and targets, the deadline, who it is for.>

## Where things are
```text
projects/<project>/
├── README.md               this file: the brief, the map, the read order
├── worklog.md              one entry per session: Did / Next / Fixed knowledge / Unproven knowledge (rules 37–38)
├── deliverables/           finished outputs people use (reports, dashboards, exports)
└── <segment>/              one per segment, plus cross-segment/
    ├── open-items.md       unfinished work (rule 40)
    ├── decisions.md        standing rules we chose, with evidence (rule 39)
    ├── experiments.md      tests, and hypotheses still to verify (rules 28, 42)
    └── knowledge.md        fixed knowledge for this segment: Depends on, facts, Traps (rules 41–42)
```

## Read order for a task (after AGENTS.md, profile.md, workspace.md)
1. this file
2. the newest `worklog.md` entry for the segment
3. the segment's `open-items.md` → `decisions.md` → `experiments.md`
4. the segment's `knowledge.md` — its **Depends on** table names the shared `knowledge/` files to load,
   and its **Traps** table lists past mistakes to check before analysis or a live change
5. `knowledge/INDEX.md` only if something is still missing

## Knowledge in this project
- **Fixed knowledge** (verified, unlikely to change, shapes what you do next time) → the segment's
  `knowledge.md`. A mistake becomes a **Traps** row.
- **Unproven knowledge** (looks true, needs time to verify) → `experiments.md`: the running test's
  Result, or a new row with Status `Hypothesis`. Never into `knowledge.md`.
- **Moving up:** a fixed item that would hold outside this project, or shows up in 2+ segments, is
  marked ↑. The weekly review moves it to the shared `knowledge/` on your yes; this project keeps a pointer.
