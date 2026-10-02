# kstack-ai-digital-media-workflow

KStack is a file-based workspace template for AI-assisted digital media work, covering paid search, paid social, tracking, reporting and experiments.

Campaign work depends on context: business goals, metric definitions, previous decisions and tests still in progress. When that context stays scattered across chats and documents, you have to reconstruct it before the agent can continue.

KStack gives that context a defined home. Projects hold objectives, decisions, experiments and session worklogs. A shared knowledge hub holds metric definitions and reusable lessons. Agent instructions define what to read first, which checks to run and when to ask for approval.

The template uses Markdown files and shell scripts, versioned with Git. It works with file-reading agents such as Claude Code, Codex, Cursor and Gemini CLI, without a separate server or database.

## Six ideas behind KStack

### 1. Projects organized around objectives

Each objective has a target, deadline and owner, with its own project folder. Decisions, open items, experiments and mistakes are organized by brand, market or client. This gives the agent a clear basis for connecting each task and recommendation to the goal it serves.

### 2. Shared knowledge, loaded when needed

Metric definitions, platform guidance and reusable lessons live in one knowledge hub. An index directs the agent to the pages relevant to its task, keeping shared knowledge available without loading the entire library into every session.

### 3. Memory that carries across sessions

Each session ends with a short worklog: what was done, what was found, what was decided and what comes next. The next session starts from that record. Context stays in the repository, where it can be reviewed, updated and carried between tools and machines.

### 4. Verify the inputs before analyzing them

Useful analysis starts with reliable numbers, accurate information and current context. The intended workflow checks each input against the source of truth for that claim: the agreed data source, metric definition, approved decision or current documentation.

Verification uses several layers. For numbers, this means checking definitions and scope, data freshness and completeness, calculations, saved verified methods and independent evidence where required. For information and context, it means tracing claims to their sources and checking whether they are current, approved or still assumptions.

The answer should show its sources, the checks completed and any unresolved gaps. Missing or conflicting evidence should remain visible rather than becoming a confident conclusion. Analysis and next steps should stay within what those checks support.

**Current scope:** KStack includes number-verification workflows. Extending this approach across factual information and context is planned.

### 5. Turn corrections into reusable checks

When a mistake is identified, the workflow calls for finding its cause, correcting the source and proposing a check that can catch it again. Weekly reviews propose lessons for approval before adding them to shared knowledge. Improvements become reviewable changes to the workspace.

### 6. Skills and approval rules for digital media

Reusable skills define the steps for recurring tasks. Approval rules set the boundaries for live actions. Before changing budgets, bids, targeting or tracking, the agent must present a live change card covering current settings, the proposed change, checks, risks and how to undo it. New campaigns start paused.

## A week with kstack

- **Monday** — you type "let's continue". The agent reads Friday's entry and picks up where you left off.
- **Wednesday** — you ask for a budget increase. The card shows the campaign is in a test until
  Friday, so the agent suggests waiting two days instead.
- **Thursday** — it gets a number wrong and you correct it. It finds the cause and saves a check.
- **Next Monday** — the weekly review proposes three lessons. You approve two. They're now
  knowledge every future session starts with.

## What it is

An operating system for AI agents that work on digital media: paid search, paid social,
tracking, reporting and experiments. Clone it, answer a 10-minute setup interview, and every new
session starts already knowing your business, your projects, what was decided last week, and
which mistakes not to repeat.

Works with any agent that can read files: Claude Code, Codex, Cursor, Gemini CLI and others.
No install, no server, no database — just Markdown files and shell scripts, synced with git.

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
| **Verification** | Four tiers (lint → invariants → replay a saved query → independent check), a stamp on every number, and a ledger of verified queries that expires when a query changes | `knowledge/verification.md`, `skills/verify-number/`, `scripts/sql-lint.sh`, `scripts/recipe-check.sh` |
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
skills/                verify-number, self-check, fix-and-save-mistake, verification tests, weekly review
scripts/               next-id.sh (unique IDs) · validate.sh (structure check) · sql-lint.sh · recipe-check.sh
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

```bash
scripts/sql-lint.sh query.sql        # known query traps from your own mistakes; --selftest proves each rule fires
scripts/recipe-check.sh              # is every verified query still the one that was verified?
```

## Principles

- **The repo is the memory.** Not the chat history, not a tool's built-in memory.
- **Business outcome over platform numbers.** Platform conversions are diagnostics.
- **Look before you dig.** Check past decisions, experiments and mistakes before new work.
- **A written rule isn't an enforced rule.** Skills and scripts do the enforcing.
- **Verify the method once, stamp every number.** Ask the data owner about new methods, not every figure.
- **The agent proposes; you approve.** Spending, tracking, publishing and messages need your yes.

## Inspiration

[gstack](https://github.com/garrytan/gstack) by Garry Tan and
[pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan — small always-on core,
everything else loaded by skills when needed; and her view that verification is the infrastructure
everything else rests on (the `verify-number` tiers, the lint and the trust ledger follow that idea).

## Contributing

Issues and pull requests are welcome, especially new skills and platform `channels/` templates.
Never include real company or client data — use clearly labeled synthetic examples (rule 36).

## License

MIT — see [LICENSE](LICENSE).
