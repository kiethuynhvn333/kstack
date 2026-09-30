# kstack-ai-digital-media-workflow — AGENTS.md

Always-on rules for any AI agent that can read files. Tool entry files (`CLAUDE.md`, `GEMINI.md`,
`.cursor/rules/`) only point here. Rule numbers are fixed; the full text of rules not written out
here lives in `rules/`, and that text is the authoritative version.
Your own setup lives in `profile.md` and `workspace.md` — never add personal rules to this file.

## Setup
If `profile.md` or `workspace.md` is missing, or a task needs an answer they mark unknown, follow
`rules/setup.md` (rules 1–8). Don't block useful work while setup is incomplete.

## Start of every session
9. Read `profile.md` and `workspace.md`. If a task depends on something still marked unknown, ask.
10. Find the active project. If unclear, ask — or scan `open-items.md` across candidate projects.
11. Read the newest entry in `projects/<project>/worklog.md`, then that project's
    `<segment>/decisions.md` and `<segment>/open-items.md`. Only then open `knowledge/INDEX.md`
    and load just the topic(s) this task needs.
12. Stop loading once you have enough. Never read everything "to be safe".

## What to trust
13. Highest first: the user's latest explicit instruction; canonical files (`knowledge/`,
    `decisions.md`); recent worklog entries; skill outputs (`skills/*/runs/`) and references.
14. Never treated as fact: `archive/`, `knowledge/meta/inbox.md`, drafts, hypotheses.
15. If two canonical files disagree: stop, log it in `mistakes-and-learnings.md`, and ask the user.

## How we work
16. This repo is the memory. Save project facts as files here, not in an AI tool's built-in memory.
17. Look before you dig: before hard analysis or recommending a live change, search the project's
    decisions, experiments, mistakes-and-learnings, and `knowledge/channels/<platform>.md`.
18. Say what you checked: every recommendation names the files and rules you checked and what they said.
19. Label every claim as fact (with source), estimate, or guess. A retry or "looks right" is not evidence.
20. When the user corrects you, find the real cause, fix the source, and offer to save a regression
    check (`skills/fix-and-save-mistake/`).
21. Follow the working style in `profile.md`. Default: plain words, short, real numbers.

## Never skip (short form — full text in `rules/`)
- 30. Don't assume a connector, login, hook, or scheduled check works — confirm it.
- 33. No change to spend, bids, targeting, campaign status, tracking, or public content without
  explicit authorization for that action and scope. New campaigns start paused.
- 35. Read-only means read-only. No commit, push, publish, message, or recurring task without authorization.
- 36. No credentials in project files. No real business data in public material.
- 37–38. When writing is allowed, end every substantive session with a worklog entry, including
  every external action and whether it was verified.

## Load when needed
| When you are about to… | Read first |
|---|---|
| Set up, or fill a gap in `profile.md` / `workspace.md` | `rules/setup.md` (1–8) |
| Analyze performance, compare periods, diagnose, plan or read a test | `rules/analysis.md` (22–29) |
| Use a new tool, hit blocked access, or make any live change | `rules/actions.md` (30–36) |
| Write to memory, end a session, or run a knowledge review | `rules/memory.md` (37–45) |
| Share a fresh number | `skills/quick-metric-self-check/` |
| Log a mistake as a regression test / rerun saved tests | `skills/fix-and-save-mistake/`, `skills/run-verification-tests/` |
| Weekly knowledge review | `skills/weekly-knowledge-review/` |

If your tool can't run skills, open the `SKILL.md` and follow it. Size limits (checked by
`scripts/validate.sh`): this file ≤60 lines; each `rules/` file ≤60; `knowledge/INDEX.md` ≤100.
