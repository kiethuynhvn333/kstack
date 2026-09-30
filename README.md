# kstack-ai-digital-media-workflow

An operating system for AI agents that work on digital media: paid search, paid social,
tracking, reporting and experiments. Clone it, answer a 10-minute setup interview, and every new
session starts already knowing your business, your projects, what was decided last week, and
which mistakes not to repeat.

Works with any agent that can read files: Claude Code, Codex, Cursor, Gemini CLI and others.
No install, no server, no database — just Markdown files and two shell scripts, synced with git.

> Built from ~4 months of daily use by an in-house performance marketer. The public version is a
> neutral template: every example uses a made-up company.

## What's inside

| Piece | What it does | Where |
|---|---|---|
| **Agent instructions** | 45 numbered rules: always-on core, the rest loaded only when needed | `AGENTS.md`, `rules/` |
| **Objective-based project management** | One folder per objective, split by segment, same shape everywhere | `projects/` |
| **Knowledge hub** | Stable how-it-works knowledge with a router, so agents load only what the task needs | `knowledge/` |
| **Memory** | Worklog, decisions, open items, experiments — the repo *is* the memory, across tools and machines | `projects/`, `knowledge/` |
| **Reflect, mistakes, learnings** | Mistakes become regression checks; a weekly review promotes lessons with owner approval | `skills/fix-and-save-mistake/`, `skills/weekly-knowledge-review/` |
| **Skills** | Repeatable workflows that load the rules they need as Step 0 | `skills/` |
| **Tools and permissions** | What each tool is trusted for, and what the agent may do alone vs with approval | `workspace.md`, `rules/actions.md` |

## Quick start

1. Click **Use this template** → create a **private** repository. Your `workspace.md` will hold
   real business details — never put it in a public repo.
2. Clone it and open the folder in your AI agent.
3. Say **"set up"**. The agent interviews you (`rules/setup.md`), shows what it will write, and
   creates `profile.md`, `workspace.md` and your project folders.
4. Work as usual. At the end of each session the agent writes a worklog entry; next session it
   reads it first.
5. Once a week, say **"run the weekly knowledge review"**.

## How a session works

```text
AGENTS.md ─► profile.md + workspace.md ─► active project's worklog ─► decisions + open items
          ─► knowledge/INDEX.md ─► only the topic this task needs
```

Before analysis or a live change the agent loads `rules/analysis.md` or `rules/actions.md`.
Before any budget, bid, targeting or tracking change it shows a **live change card** — current
settings, before → after, history checked, risk, how to undo — and waits for your approval.

## Folder map

```text
AGENTS.md              always-on rules (≤60 lines)
rules/                 setup · analysis · actions · memory — loaded when needed
profile.example.md     how you like to work        → copied to profile.md at setup
workspace.example.md   business, metrics, tools, permissions → copied to workspace.md
projects/_template/    worklog + 4 tracking files per segment
knowledge/             INDEX router, metrics, channels, universal learnings, inbox
skills/                self-check, fix-and-save-mistake, verification tests, weekly review
scripts/               next-id.sh (unique IDs) · validate.sh (structure check)
archive/               superseded records — kept, never default-loaded
```

## Scripts

```bash
scripts/next-id.sh D
```
Prints the next free decision ID for the whole repo (also `O`, `E`, `C`, `K`).

```bash
scripts/validate.sh
```
Checks required files, size limits, duplicate IDs and skill Step 0 lines. Run it before each commit.

## Principles

- **The repo is the memory.** Not the chat history, not a tool's built-in memory.
- **Business outcome over platform numbers.** Platform conversions are diagnostics.
- **Look before you dig.** Check past decisions, experiments and mistakes before new work.
- **A written rule isn't an enforced rule.** Skills and scripts do the enforcing.
- **The agent proposes; you approve.** Spending, tracking, publishing and messages need your yes.

## Inspiration

[gstack](https://github.com/garrytan/gstack) by Garry Tan and
[pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan — small always-on core,
everything else loaded by skills when needed.

## Contributing

Issues and pull requests are welcome, especially new skills and platform `channels/` templates.
Never include real company or client data — use clearly labeled synthetic examples (rule 36).

## License

MIT — see [LICENSE](LICENSE).
