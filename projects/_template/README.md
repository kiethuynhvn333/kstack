# Project template

Setup (`rules/setup.md`) copies this folder once per objective in `workspace.md`:

1. Copy `projects/_template/` to `projects/<project-folder>/` (the folder name from `workspace.md` → Objectives).
2. Copy `_segment/` once per segment in `workspace.md` → Segments, renamed to the segment
   (e.g. `sofas/`, `beds/`), plus one `cross-segment/` for work that spans segments.
3. Delete `_segment/` and this README from the copy. Leave `projects/_template/` itself untouched.

```text
projects/<project>/
├── worklog.md              one dated entry per session (rules 37–38)
├── deliverables/           finished outputs people use (reports, dashboards, exports)
└── <segment>/              one per segment, plus cross-segment/
    ├── decisions.md        approved decisions (rule 39)
    ├── open-items.md       unfinished work (rule 40)
    ├── experiments.md      tests, registered before launch (rule 28)
    └── mistakes-and-learnings.md   mistakes and conflicting sources (rules 15, 41)
```

Every table row gets its ID from `scripts/next-id.sh <D|O|E|C>` — IDs are one sequence for the
whole repo, never "the next number" in one file (rule 43). Fill every column; write `unknown`
rather than leaving a cell blank.
