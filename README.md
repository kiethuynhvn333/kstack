# kstack

**Memory with skills for growth and paid media.**

kstack gives your AI agent saved project context and ready-made steps for your work:

- **Memory:** files that keep your goals, decisions, experiments and lessons, so your agent can pick up where you left off.
- **Skills:** steps for tasks like building a growth dashboard or checking your numbers.
- **Instructions:** rules for how your agent works and when it needs your approval.

Your memory stays in files you own. Use it with an AI agent that can read and write local files, such as Claude Code, Codex, Cursor or Gemini CLI.

> **New in v0.5:** say "build me a growth dashboard" and your agent walks you through one view of the
> metrics you grow and which sources of growth drive them, as a web page or a Google Sheets / Excel file
> (`skills/growth-dashboard/`). See [CHANGELOG.md](CHANGELOG.md). Set up kstack before v0.4? See
> "Upgrading from v0.3" below.

The template uses Markdown files and shell scripts, versioned with Git. It works with file-reading agents such as Claude Code, Codex, Cursor and Gemini CLI, without a separate server or database.

## Six ideas behind kstack

### 1. Projects organized around OKRs

Each project connects an objective to measurable key results, with clear targets, deadlines and owners. Decisions, open items, experiments and what the project has learned stay in the same project folder, organized by brand, market or client, with a short `README.md` that tells the agent what the project is and what to read first. This gives the agent a clear basis for explaining which goal a recommendation serves and how progress will be measured.

### 2. Two layers of knowledge, loaded when needed

Knowledge about one project lives inside that project: each segment has a `knowledge.md` with its facts, its traps (past mistakes turned into rules) and a **Depends on** table that points to the shared pages it needs. Knowledge that holds for every project (metric definitions, verification, platform guidance) lives in the shared `knowledge/` hub. The agent reads the project first and follows its links, so it loads only what the task needs. When a project lesson turns out to hold everywhere, the weekly review moves it up to the shared hub, with your yes.

### 3. Memory that carries across sessions, captured while it is fresh

Each session ends with `session-close`, which answers four questions: what did we do, what are the next steps, did we learn anything **fixed** (verified, unlikely to change, worth acting on next time), and anything **unproven** (looks true, needs time to check). The worklog records all four. Next steps become open items, fixed knowledge goes into the project's `knowledge.md`, and unproven knowledge goes into `experiments.md` as a hypothesis — each only after you say yes, while you still remember the session. The next session starts from that record.

### 4. Verify the inputs before analyzing them

Useful analysis starts with reliable numbers, accurate information and current context. The intended workflow checks each input against the source of truth for that claim: the agreed data source, metric definition, approved decision or current documentation.

Verification uses several layers. For numbers, this means checking definitions and scope, data freshness and completeness, calculations, saved verified methods and independent evidence where required. For information and context, it means tracing claims to their sources and checking whether they are current, approved or still assumptions.

The answer should show its sources, the checks completed and any unresolved gaps. Missing or conflicting evidence should remain visible rather than becoming a confident conclusion. Analysis and next steps should stay within what those checks support.

**Current scope:** kstack includes number-verification workflows. Extending this approach across factual information and context is planned.

### 5. Reflect, Mistakes and Learnings

When a mistake is identified, the workflow calls for finding its cause, correcting the source and proposing a check that can catch it again; the lesson becomes a trap in the project's knowledge. A short weekly review moves lessons that hold everywhere up to the shared hub, flags sessions that skipped the close, and checks which tests are overdue. Improvements become reviewable changes to the workspace.

### 6. Skills and approval rules for digital media

Reusable skills define the steps for recurring tasks. Approval rules set the boundaries for live actions. Before changing budgets, bids, targeting or tracking, the agent must present a live change card covering current settings, the proposed change, checks, risks and how to undo it. New campaigns start paused.

## A week with kstack

- **Monday** — you type "let's continue". The agent reads Friday's entry and picks up where you left off.
- **Wednesday** — you ask for a budget increase. The card shows the campaign is in a test until
  Friday, so the agent suggests waiting two days instead.
- **Thursday** — it gets a number wrong and you correct it. It finds the cause and saves a check.
  At the end of the session it proposes the lesson as a trap in the project; you say yes.
- **Next Monday** — the weekly review asks whether two project lessons hold for every project.
  You approve one; it moves to the shared hub that every future session can use.

## What it is

Memory, skills and instructions for people working on growth and paid media with an AI agent.
Use it for paid search, paid social, tracking, reporting and experiments. Set it up once, then
save your work and lessons in files your agent can read in the next session.

It is open source: Markdown files and shell scripts, with Git for version history.

> Built from ~4 months of daily use by an in-house performance marketer. The public version is a
> neutral template: every example uses a made-up company.

## What's inside

| Piece | What it does | Where |
|---|---|---|
| **Agent instructions** | 45 numbered rules: always-on core, the rest loaded only when needed | `AGENTS.md`, `rules/` |
| **Objective-based project management** | One folder per objective, split by segment, same shape everywhere | `projects/` |
| **Knowledge, two layers** | Project knowledge (facts, traps, links to shared pages) inside each project; shared knowledge for every project in a hub with a router | `projects/<p>/<segment>/knowledge.md`, `knowledge/` |
| **Memory** | Worklog, decisions, open items, experiments — captured at the end of each session with your approval; the repo *is* the memory, across tools and machines | `projects/`, `skills/session-close/` |
| **Reflect, mistakes, learnings** | Mistakes become traps and regression checks; a short weekly review moves lessons that hold everywhere to the shared hub | `skills/fix-and-save-mistake/`, `skills/weekly-knowledge-review/` |
| **Verification** | Four tiers (lint → invariants → replay a saved query → independent check), a stamp on every number, and a ledger of verified queries that expires when a query changes | `knowledge/measurement/verification.md`, `skills/verify-number/`, `scripts/sql-lint.sh`, `scripts/recipe-check.sh` |
| **Skills** | Repeatable workflows that load the rules they need as Step 0 | `skills/` |
| **Growth dashboard** | Asks a few plain questions (industry, metrics, data, sources of growth) and builds a web page or a Google Sheets / Excel workbook: key metrics, what each source contributes, and whether each source is growing | `skills/growth-dashboard/` |
| **Tools and permissions** | What each tool is trusted for, and what the agent may do alone vs with approval | `workspace.md`, `rules/actions.md` |

## Quick start — let your AI tool do it

About 10 minutes. You need a computer and an **AI desktop app that can read and write files and run
commands on your computer** (for example the Claude desktop app's Code tab, Codex, Cursor or Gemini CLI).
A plain chat window that cannot touch your files will not work, because kstack's memory *is* files.

### 1. Create a free GitHub account (recommended)
Go to **https://github.com/signup**, follow the prompts (or choose **Continue with Google**) and
**verify your email** when GitHub asks. GitHub is where your private copy of kstack lives and is backed
up. You can start without it (see the prompt below), but you will want it for backups and updates.

### 2. Open your AI app
Open your AI desktop app. You can start with any folder, or none: the agent creates your kstack on
your Desktop, a permanent place, in the next step.

### 3. Paste this to your agent
```text
I want to start using kstack: https://github.com/kiethuynhvn333/kstack
It is a template of plain files that gives you a memory for my digital-media work.
Please set it up for me:

1. Check that git is installed. If it is not, tell me how to install it, then stop and wait.
2. Choose a permanent home first: a new folder on my Desktop (or another folder I name). Do all the
   work from there, so my kstack lives at <Desktop>/<name>. Never leave it in a temporary or
   session folder.
3. Check whether the GitHub CLI (gh) is installed and I am signed in (gh auth status).
   - If yes: ask me what to name my private copy, then, from my Desktop, create it as a PRIVATE
     repository from the template and clone it:
       gh repo create <name> --template kiethuynhvn333/kstack --private --clone
   - If not: do not install anything without asking me. Offer two choices:
     (a) help me install gh and sign in with "gh auth login --web" (I finish the sign-in in my browser), or
     (b) work on my computer only: from my Desktop, git clone https://github.com/kiethuynhvn333/kstack.git <name>
         then run "git remote remove origin" inside it, so nothing can be sent to the public
         repository. I can create a private GitHub copy later.
4. Open the new folder, read AGENTS.md and follow it, and start the "set up" interview.
5. At the end, tell me the full path of my folder and remind me to open that folder as my
   project folder next time. Then, in one bold line, remind me that nothing is backed up yet and
   that I should type "commit and push".

Ask me before you create anything on GitHub. Never put my passwords or tokens in any file, and never
ask me to paste them into this chat. I sign in through the browser myself.
```

### 4. Answer its questions
It asks what to name your private copy, may ask you to sign in to GitHub in your browser, and then
starts the setup interview in small batches (`rules/setup.md`): who you are, your objectives and
targets, how you like to work, what it may do alone and what needs your approval, and which tools and
numbers you trust. It shows what it will write; say yes. It creates `profile.md`, `workspace.md` and
one project folder per objective. You can skip any question; unanswered items are saved as `unknown`.

**Next time, open the kstack folder it created on your Desktop (named after your private copy, and
containing `AGENTS.md`) as the project folder.**

### 5. Work as usual, and close each session
Talk about your work. You do not need to say "save this". When you are done, say **"wrap up"**: the
agent writes the worklog entry and shows a short list — next steps, what it learned that is fixed,
what is still unproven. Reply with the numbers you want saved (e.g. "1, 3 yes"); nothing else is
written. In a **new** chat, say **"let's continue"**: it reads the project's README, the last entry,
your open items and decisions, and the project's knowledge first.

### 6. Once a week
Say **"run the weekly knowledge review"**. It takes a few minutes: it asks whether lessons marked as
holding everywhere should move to the shared hub, points out sessions that were not closed, and lists
tests that are overdue. Nothing changes until you approve.

### Back up your work
Your agent saves files on your computer as you work, but it **never commits or pushes on its own**.
So at the end of each session it reminds you with a bold line. When you see it, type:

> **commit and push**

and the agent saves a copy to your private GitHub (it confirms first). If you started computer-only,
type **commit** to keep a history on your computer, and later ask it to *"create a **private** GitHub
repository for this folder and push it"* once you have a GitHub account.

### Prefer to do it yourself?
1. Create the GitHub account (step 1), then open **https://github.com/kiethuynhvn333/kstack**.
2. Click the green **Use this template** button, then **Create a new repository**.
3. **Owner:** your account. **Repository name:** anything (letters, numbers, `.`, `-`, `_`; no spaces).
   **Choose Private.** Your `workspace.md` will hold real business details. Click
   **Create repository from template**.
4. Put it on your computer: install **GitHub Desktop** (**https://desktop.github.com**), sign in, open your
   new repository's page on GitHub, click **Code → Open with GitHub Desktop → Choose... → Clone**. Or run
   `git clone <the HTTPS address under Code>` in a terminal (needs [Git](https://git-scm.com/downloads)).
5. Open that folder in your AI app and say **"set up"**.

Do not use **Fork** or **Download ZIP**. A fork of a public repository stays public, and a ZIP has no
Git history, which the checks and the update script need.

### If something goes wrong
- **The agent ignores the rules:** tell it *"Read AGENTS.md first and follow it."*
- **The agent cannot run `scripts/validate.sh`:** it should say so. Memory still works; only the
  automatic structure check is skipped. The scripts are tested on macOS. On Windows, install
  **Git for Windows** (it includes Git Bash) so the agent can run them.
- **It asks you to sign in:** your copy is private, so GitHub needs to know it is you. Sign in in the
  browser when asked.
- **A new kstack release came out:** see "Keep your workspace up to date" below.
- **You set up kstack before v0.4:** run the update script. It upgrades the layout once (asks first,
  deletes none of your content) — see "Upgrading from v0.3" below.

## Keep your workspace up to date

kstack is open source under the MIT license. Follow changes in this repository; tagged releases
are version snapshots, while `main` may contain newer changes. Updates to kstack do not
automatically update your working folder. A small script (below) applies an update when you run it;
nothing changes by itself.

Keep your working repository **private**. A fork of this public repository stays public, so use
**Use this template** for real work. Template-created repositories have separate Git histories;
do not treat them as forks or blindly merge this repository into your workspace.

### Quick update

Your repository was made from the template, so it has no link back to this one and GitHub's
"Sync" button will not work. `scripts/update.sh` does the job. Run it inside your private repo,
with your work committed:

```bash
curl -fsSL https://raw.githubusercontent.com/kiethuynhvn333/kstack/main/scripts/update.sh -o /tmp/kstack-update.sh
sh /tmp/kstack-update.sh
```

It shows what will change and asks before touching anything. After the first run you can use
`sh scripts/update.sh` instead. Add a tag such as `v0.4.0` to pin a release, or `--yes` to skip
the question.

- **It updates** the files kstack ships: `AGENTS.md`, the tool entry files, `CHANGELOG.md`, `rules/`,
  `skills/`, `scripts/` and `projects/_template/`. It overwrites those files, so keep your own
  preferences in `profile.md` and `workspace.md`, not in them. Your own extra skills are left alone.
- **It adds** new files under `knowledge/` and new `*.example.md` files.
- **It never touches** `profile.md`, `workspace.md`, your project folders, your worklogs or your
  learned knowledge.
- **It lists, but does not change,** files that exist in both versions and may hold your edits
  (for example `knowledge/INDEX.md`). Ask your agent to merge the new parts into yours and keep
  your content.
- **It runs `scripts/validate.sh` and does not commit.** Read `CHANGELOG.md` for what changed,
  check `git status`, then commit. To undo before committing: `git reset --hard HEAD`.

### Upgrading from v0.3

v0.4 changes how knowledge is stored (see `CHANGELOG.md`). The update script upgrades your workspace
once, after showing the plan and asking:
- `knowledge/metrics.md`, `verification.md`, `verified-recipes.md` and `checks/` move into
  `knowledge/measurement/`, with your edits.
- Each segment's `mistakes-and-learnings.md` rows move into the segment's new `knowledge.md` →
  Traps table (same columns). The old file goes to `archive/v0.3-retired/`.
- `knowledge/meta/inbox.md` goes to `archive/v0.3-retired/`. If it had rows, ask your agent to file
  each one: fixed → the segment's `knowledge.md`, unproven → `experiments.md` as a Hypothesis row.
- Projects without a `README.md` get the template one. Ask your agent to fill in the brief.

Then review `git status` and commit, as for any update.

### Manual review (full control)

Prefer to review every change yourself, or want to see what a release changes before you apply it?

1. Commit your current work in your private repository, or make a complete backup, before updating.
2. Keep a separate, unchanged reference copy of kstack. Do not put your business context in it:

   ```bash
   git clone --branch main https://github.com/kiethuynhvn333/kstack.git kstack-upstream
   ```

   To refresh that reference copy later, run this **inside `kstack-upstream` only**:

   ```bash
   git pull --ff-only
   git rev-parse HEAD
   ```

3. Ask your agent to compare the reference copy with your private workspace and explain the
   changes. Review instructions, rules, skills, scripts, tool entry files and project templates.
   Keep your own permissions and custom rules unless you explicitly approve a change.
4. Apply only the changes you approve. Do not replace `profile.md`, `workspace.md`, real project
   folders, worklogs or your learned knowledge with template defaults. If a knowledge file has
   upstream changes, review and combine the relevant parts instead of copying over your version.
5. Run `scripts/validate.sh` and the checks relevant to the changed workflows. Structural
   validation does not prove that an agent follows the rules or that a live number is correct.
6. Record the source commit from `git rev-parse HEAD`, the changes applied and the checks in your
   private worklog. Commit the reviewed update so the previous version remains recoverable.

You can use this request with a file-reading agent:

> Compare my private workspace with the separate kstack reference folder. Show the proposed
> updates and any conflicts before changing files. Preserve my business context, permissions,
> project history and learned knowledge. Apply only the updates I approve, run the relevant
> checks, and record the source commit and result in my worklog. Do not publish my private files.

GitHub references: [template repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template),
[fork visibility](https://docs.github.com/en/pull-requests/reference/forks), and
[versioned releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases).

## How a session works

```text
AGENTS.md ─► profile.md + workspace.md ─► project README ─► newest worklog entry
          ─► segment open items + decisions + experiments ─► segment knowledge.md (Depends on, Traps)
          ─► knowledge/INDEX.md only if something is still missing
...work...
session-close ─► worklog (Did / Next / Fixed / Unproven) ─► you approve ─► open items, knowledge.md, experiments
weekly review ─► move ↑ lessons to the shared hub · flag unclosed sessions · overdue tests · archive old worklog
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
projects/_template/    README (brief + read order) + worklog + per segment: open items, decisions, experiments, knowledge
knowledge/             shared hub: INDEX router, measurement/ (metrics, verification), channels/, universal learnings, meta/
skills/                session-close, weekly review, verify-number, self-check, fix-and-save-mistake, verification tests, growth-dashboard
scripts/               next-id.sh (unique IDs) · validate.sh (structure check) · sql-lint.sh · recipe-check.sh · update.sh
archive/               superseded records — kept, never default-loaded
```

## Scripts

```bash
scripts/next-id.sh D
```
Prints the next free decision ID for the whole repo (also `O` open item, `E` experiment or hypothesis, `C` trap).

```bash
scripts/validate.sh
```
Checks required files, size limits, duplicate IDs and skill Step 0 lines. Run it before each commit.

```bash
scripts/update.sh                    # bring the shipped kstack files up to the latest release (see "Keep your workspace up to date")
```

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
