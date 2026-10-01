# kstack-ai-digital-media-workflow

**Your AI agent forgets everything when the chat ends. Your campaigns don't.**

---

It's Monday morning. You open a new chat and start explaining again: which campaigns matter this
quarter, what "a lead" means in your business, which test is still running. Twenty minutes later
the agent is finally up to speed — and it suggests raising the budget on the campaign you're
testing. The same change that ruined a test three weeks ago.

It's not the agent's fault. It wasn't there three weeks ago.

Digital media work is long. Tests run for weeks, every metric has fine print, and one careless
change can wreck a month of learning. Chat agents are short: every session starts from zero.
**kstack closes that gap.** It's a folder of plain files your agent reads before it does anything —
so it starts every session already knowing your goals, your numbers, your history and your rules.

## Five ideas behind kstack

### 1. Projects run like OKRs
Every objective has a target, a deadline and an owner, and becomes its own project folder —
decisions, open items, experiments and mistakes, split by brand, market or client. The agent
always knows which goal a task serves. Ask it "why this change?" and it points to the objective.

### 2. One knowledge hub, loaded smart
Metric definitions, platform lessons and hard-won learnings live in one place, with an index.
The agent opens only the page the task needs — not the whole library — so it stays fast and focused.

### 3. Memory that outlives the chat
Every session ends with a short worklog entry: done, found, decided, next. The next session starts
from it. Switch tools, laptops or models — the memory is in your git repo, not in someone's app.

### 4. Reflect, catch mistakes, evolve
When you correct the agent, it finds the real cause, fixes it, and saves a check so the same
mistake gets caught next time. Once a week you run the review: it looks back at what it learned and
proposes updates — you approve. The agent gets better every week, and never grades its own homework.

### 5. Skills and guardrails made for digital media
It checks a number before it shows you one — lint, sanity checks, a replay of a saved query, and a
stamp saying what was and wasn't verified, so you aren't left waiting on a data team for every figure.
It trusts your own business data over platform-reported conversions. Before any budget, bid or targeting change it shows a **live change card** — current
settings, before → after, what it checked, the risk, how to undo — and waits for your yes. New
campaigns start paused.

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
