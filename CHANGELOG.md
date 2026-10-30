# Changelog

## v0.5.1 — growth-dashboard follows its own order (2026-10-30)
A test in Gemini showed the skill was only followed when the user forced the order. Now the skill
enforces it: a hard-stop block at the top (an attached file does not answer the step 1–4 questions;
ask them in one message and wait), Checks as their own step that is never sent with the built file,
no summed people totals (left empty, shown as "—", with a note), and rules against an efficiency chart
without spend, a mixed-unit funnel and a rate above 100%. `build_workbook.py` now refuses data that
breaks these rules. Steps after 5 moved: Checks is step 7, Build is 8, Hand over is 9.
A second Gemini test showed plan and Checks still merged and the sample used despite an attached CSV, so the
plan and Checks now end with a fixed "Reply yes" line, "use your suggestions" never approves them, and the
sample is never used when a data file is attached.

## v0.5.0 — See what grows, and what drives it (2026-10-28)

**In one line:** say "build me a growth dashboard" and your agent walks you through it, even if you have
never built one, and gives you one view of the metrics you grow, which sources of growth drive them, and
whether each source is growing or shrinking.

### The problem
Growth teams do a lot every week (new campaigns, emails, pushes, SEO pages) and the numbers often don't
move. Usually nobody can see the whole picture: the data sits in ad platforms, a warehouse and a few
spreadsheets, and no single page shows how much each source actually contributes. You can't manage what
you can't see.

### What you get
- **A new skill, `skills/growth-dashboard/`, built for first-timers.** It asks one thing at a time, with
  numbered choices and a "not sure — pick for me" option:
  1. **Your industry** — 17 types (marketplace, e-commerce, subscription app, SaaS, lead generation,
     fintech, games, media, travel and more), each with a suggested north-star metric, typical metrics,
     funnel and sources of growth.
  2. **The metrics you grow** — pick from the suggestions or add your own; each gets a one-line definition.
  3. **Where your data is** — a live connection (BigQuery, Google Sheets, GA4, a CRM, Shopify…), a CSV or
     Excel file, a pasted table, or the built-in sample if you have no data yet.
  4. **Your sources of growth** — paid, owned (email, push, CRM) and organic. Anything that can't be matched
     to a source stays visible as "Not linked", because a big gap there is a tracking problem.
- **A plan before anything is built.** The agent shows the metrics, sources, data and charts in a few lines,
  adds one line of pushback if something looks off, and builds nothing until you say yes.
- **Numbers checked before they are shown.** Freshness, parts vs total, impossible values and unit-cost
  math, posted in chat as a short "Checks" message. People are never added up across sources as if they
  were unique.
- **Two versions, same content.** A web page you open in any browser, or a Google Sheets / Excel workbook
  whose Segment and Period dropdowns drive every number and chart. Both are built from one data file, so
  they always agree.
- **Always the same shape:** metric tiles with the change vs the period before, a stacked chart of what each
  source contributes, cost per result by source, a funnel, a status table (growing / flat / declining /
  new), a detail table and every caveat written on the page.
- **A chart guide and a UI spec.** 15 everyday questions mapped to the right chart (trend → line,
  contribution → stacked bars, drop-off → funnel…), plus one look for every dashboard: colors, type,
  components, light and dark, number formats.

### Try it
Open `skills/growth-dashboard/assets/dashboard-template.html` in a browser to see the result with made-up
sample data, or tell your agent "build me a growth dashboard".

### Tested
Four QC runs before release: a brand-new user with no data, a CSV with a partial month and unmatched rows,
the web page at desktop and phone width in light and dark, and the workbook. All pass. Fixed after QC: the
sample path no longer skips the plan, people totals are never a sum of sources, tooltips stay inside their
cards, missing values show "—", and a dashboard without spend data no longer crashes (the cost chart is
simply left out).

### Known limits
- The workbook was checked in LibreOffice; Excel and Google Sheets are expected to show it the same way but
  were not tested directly.
- The sample data is a marketplace; other industries see their own metrics only once they bring their data.

## v0.4.0 — Your agent learns while the session is still fresh (2026-10-12)

**In one line:** kstack now captures what you learned at the end of every session, asks you to approve
it while you still remember it, and keeps each project's knowledge inside that project — so the next
session (and the next agent) starts from what the project actually learned.

### The problem
Working with an AI agent every day, two things kept going wrong:

1. **Lessons were approved too late.** The old weekly review asked you on Monday to approve lessons from
   Tuesday's session. By then the context was gone, so you either waved things through or let them pile
   up in an inbox. The knowledge base slowly filled with things nobody had really checked.
2. **A project's knowledge lived somewhere else.** Mistakes sat in separate log files and lessons in a
   shared inbox. An agent opening a project could not see what that project had already learned, and
   repeated old mistakes.

### What you get
- **A 1-minute close at the end of every session.** Say "wrap up". The new `session-close` skill answers
  four questions — *What did we do? What's next? What did we learn for sure? What do we still need to
  check?* — writes the worklog, and shows a short numbered list. Reply "1, 3 yes" and only those are saved.
- **Sure vs. not-sure knowledge, kept apart.** Things you verified ("broad match on this account always
  leaks to unrelated searches") go into the project's knowledge. Things that only *look* true ("the new
  creative may lower cost per lead") go into `experiments.md` as a **Hypothesis** with a verify-by date —
  never mixed in with facts.
- **Every project knows what it learned.** Each segment now has one `knowledge.md`: its facts, its
  **Traps** (past mistakes turned into rules the agent checks before analysis or a live change), and a
  **Depends on** list of the shared pages it needs. Each project has a `README.md` with the brief, the map
  and the order to read things in.
- **Lessons that hold everywhere move up — with your yes.** Mark a lesson ↑ at the end of a session; the
  weekly review asks once whether it belongs in the shared hub for every project.
- **A weekly review that takes minutes.** It no longer re-tells your week. It asks the ↑ questions,
  points out sessions you forgot to close, lists tests and hypotheses past their date, and archives old
  worklog entries.
- **A clear starting path for any agent.** Claude, Codex, Cursor or Gemini all read in the same order:
  rules → your profile → the project README → the last session → open items, decisions and tests → the
  project's knowledge → the shared hub only if something is still missing.

### Before and after
| | v0.3 | v0.4 |
|---|---|---|
| When lessons get approved | Weekly, days later | At the end of the session, while it is fresh |
| Where a project's lessons live | Shared inbox + separate mistakes file | The project's own `knowledge.md` |
| Unproven ideas | Mixed into the inbox with facts | `Hypothesis` rows with a verify-by date |
| Shared knowledge | Flat folder, lessons promoted from an inbox | Grouped hub; lessons move up only with your yes |
| Weekly review | Long scan of the whole week | A few yes/no questions |
| Worklog | Capped at 250 lines | No cap; entries older than 7 days are archived |

### How it was tested
The template passes its own checks (`scripts/validate.sh`). We built a sample v0.3 workspace — an edited
metrics page, one logged mistake, one inbox item — and upgraded it two ways (the new update script in one
go, and an older update script followed by `--migrate`). Both kept every edit and every row, and passed
the checks; running the upgrade twice changes nothing. A new project made from the v0.4 template passes
too. This is a structural test on sample data, not a study of real users.

### Upgrading from v0.3
Run the latest `update.sh` (see the README). It shows a one-time plan and asks first, then:
moves `metrics.md`, `verification.md`, `verified-recipes.md` and `checks/` into `knowledge/measurement/`
with your edits; carries every row of each `mistakes-and-learnings.md` into that segment's
`knowledge.md` → Traps (same columns); archives the old inbox and mistakes files in
`archive/v0.3-retired/` — none of your content is deleted; and adds a `README.md` to projects that lack
one. If an older `update.sh` already installed v0.4, `scripts/validate.sh` tells you to run
`sh scripts/update.sh --migrate`. Inbox rows are not filed automatically: ask your agent to file each one
(sure → the segment's `knowledge.md`, not sure → a Hypothesis row). Then check `git status` and commit.

### Changed or retired
- New: `skills/session-close/`, `projects/_template/README.md` (brief + read order),
  `projects/_template/_segment/knowledge.md`, `Hypothesis` status in `experiments.md`, `update.sh --migrate`.
- Moved: `knowledge/{metrics,verification,verified-recipes}.md` and `knowledge/checks/` → `knowledge/measurement/`.
- Retired: `knowledge/meta/inbox.md` and `K-` IDs (`scripts/next-id.sh K` explains where things go now),
  and `mistakes-and-learnings.md` in every segment (its rows live on as Traps).
- `decisions.md` now has a bar: only standing rules that would cause a repeatable mistake if ignored,
  backed by evidence. Facts go to `knowledge.md`; routine test verdicts stay in `experiments.md`.
- Rewritten: `rules/memory.md`, `skills/weekly-knowledge-review/`, the knowledge `INDEX.md` and
  `meta/maintenance.md`; `AGENTS.md`, `CLAUDE.md` and `GEMINI.md` spell out the read order.

## v0.3.0 — Memory that holds, and a way to update (2026-10-03)

### Why
The promise is that your agent starts every session knowing what happened in the last one. Before
shipping more, we tested that promise instead of assuming it. And a template has a second problem:
once you have set it up, how do you get the next release without losing your own data?

### How it was tested
Two AI agents (Grok and ChatGPT) each played the repo's agent for six made-up users: an e-commerce
marketer, an agency with three clients, a vague freelancer, a Vietnamese-speaking shop, a B2B team with
a 14-day sales lag, and a messy owner-operator. Each "session" was a fresh chat that could only know
what the files said. The user never asked the agent to save anything.

- **What held:** decisions, open items and tests were saved as they were mentioned; a fresh chat three
  days later recalled them correctly and refused a budget change that contradicted a saved decision;
  after ten sessions over three weeks the agents still answered 6 of 6 recall questions, kept superseded
  decisions instead of overwriting them, kept an unconfirmed rumour out of the facts, refused to store a
  token and a password, and the weekly review stopped for approval.
- **What broke, and is fixed below:** a worklog grew past its 250-line limit with nothing to stop it; one
  setup left a project without `deliverables/` and never ran validation; a URL was filed as a decision;
  a test stayed `Planned` for weeks after its start date.
- **Limits:** one run per scenario, two models, made-up users. The agents played both sides and could see
  the scripted user lines. Treat it as strong evidence, not proof.

### What shipped
- **`scripts/update.sh`** — update an existing workspace to a new release. It replaces only the files KStack
  ships (rules, skills, scripts, entry files, templates), adds new knowledge files, lists the ones you may have
  edited, runs the validator, and never touches `profile.md`, `workspace.md` or your projects. See the README.
- **Validation is part of the routine:** setup is not "done" until `scripts/validate.sh` passes and every
  project has `deliverables/`; every session that writes memory ends with it. A worklog over 250 lines now fails.
- **Filing hints:** a fact or link is not a decision; an unchecked hunch or hearsay goes to the inbox.
- **Date check:** at the start of a session the agent flags a Planned test past its start, a Running one past its
  end, and open items past their review date, without closing anything by inference.
- **README:** why to use the template and never fork it, and two ways to update.

### Known issue
"Don't change anything" about your ads is not the same as "read-only". One agent took it to mean "don't save
memory" and skipped the worklog for that session. Say "read-only" or "don't change any files" when you mean it.

## v0.2.0 — Verification: a number earns trust in tiers (2026-10-02)

### Why
If you work in digital media, you check numbers all day: spend, leads, what a campaign really
brought in. It is one of the most common jobs we do. Getting the number is easy. **Making sure it is
correct is the pain.**

- You get a number from the agent and can't tell if you can trust it.
- So you ask the data team (or their bot) to confirm it, and you wait, sometimes hours.
- Next week you ask again for a method they already checked.
- One forgotten filter makes a number twice as big, and nobody notices until it is in a report.
- The same mistake comes back, because nothing stopped it the first time.

The cost is time for you and for the data team. Worse, you start to doubt every number, or you stop
checking because checking is too slow.

The idea for fixing it comes from Lauren Tan's pstack posts: *verification is infrastructure; build
tools, not more prose; show evidence, not an explanation.* Our version: **verify the method once, then
check every number cheaply, and say what was checked.** Ask the data team only about something new.

### What shipped
**Four tiers, cheapest first** (`knowledge/verification.md`, run by `skills/verify-number/`):

| Tier | What | Catches | Misses |
|---|---|---|---|
| T0 | `scripts/sql-lint.sh` on the query text + the self-check | known traps from your own past mistakes | anything new |
| T1 | Freshness, grain and invariants on the source (`knowledge/checks/`) | missing days, duplicate rows, impossible values | wrong-but-possible numbers |
| T2 | Replay a saved query against a recorded closed-period answer (`knowledge/verified-recipes.md`) | the query or table drifting | a recipe wrong from the start (if its answer was self-made) |
| T3 | An independent source: a raw ground-truth join, or the checker named in `workspace.md` | wrong method, scope or definition | what the checker shares with you |

- **Required level by use:** rough look → T0; shown in chat → T0+T1; report or decision row → T0+T1+(T2, or T3 if the
  method is new); live change → T0+T1+T2 on a verified unchanged recipe, else T3. The agent must write the
  required level out in full before running anything.
- **The stamp:** every number ends with what ran, what is pending, what is contested, what was allowed, and
  what is **not** checked. A tier that did not run is written "not run", never left out.
- **Lint (`scripts/sql-lint.sh`):** rules in `scripts/sql-lint/rules.tsv`, each with a bad and a good test file;
  `--selftest` proves every rule fires on the bad one and stays silent on the good one. A deliberate exception is
  written in the query as `-- lint-allow: <ID> <reason>` (a reason is required, the user's OK is required,
  and it shows in the stamp).
- **Trust ledger (`scripts/recipe-check.sh`):** each saved query has a fingerprint (hash). Edit the query and its
  "verified" status goes stale automatically. A self-made answer is `replayed` (stable), only an independent
  one is `verified`.
- **Ask the checker less:** one batched message per session, never wait for the reply, write every answer back
  into the ledger so the same method is asked once. A disagreement is **contested**, not "wrong", until the
  definition is settled.
- **Setup and wiring:** a new setup question ("who or what can independently check a number, and how long
  does it take?") feeds a **Verification** section in `workspace.example.md`; `scripts/validate.sh` runs the lint
  selftest and the ledger check; `AGENTS.md` routes any "share / report / act on a fresh number" to the skill.

### How it was built (the journey, short)
- Started from a real incident: a table holding several "total" rows was summed and read about 2x too high.
  The lint rule written for it now stops that mistake before the query runs.
- **Checks were calibrated on live data, not guessed.** Two "obvious" invariants (cost never empty; clicks never
  above impressions) fired on normal data, so they became info-only. A check that cries wolf teaches people to
  ignore alarms.
- **The lint was run over every existing query** and tuned until false alarms were gone (one rule matched across
  a whole file, another ignored a safe filter pattern).
- **A real bug was found by asking "will this work on my other computer?":** a `.gitignore` allow-list would have
  silently dropped the new scripts.
- **A live run caught its own overclaim:** the agent called a count "not real" when the two counts probably used
  different definitions. That produced the *contested* rule. A later fresh-agent test produced the `lint-allow`
  marker and the "state the required level in full" and "self-check needs data" rules.

### Tested
- Scripts: lint selftest, lint-allow with and without a reason (and a deliberately broken check to prove the
  test would fail), stale-ledger detection, `validate.sh` negative tests (missing fixture, stale recipe).
- Three fresh-agent runs in a new conversation with only the repo as context: a bad query with the skill named,
  the same query with no skill named (it triggered anyway), and a clean query with no data (it refused to
  call the number verified and marked T1/T2/T3 "not run").

### Not tested yet — read before relying on it
- Only one agent/tool was used for the fresh-agent runs. Codex, Cursor and Gemini are untested.
- The T1 check file here is a **synthetic, untested template**. The tiers that need real data (T1 queries, recipe
  replay, an independent checker) were proven only in the author's private working repo, not in this template.
- Nothing runs automatically. A gate that is only written down is not a gate (rule 30). A hook that runs the lint
  before each query is the next step and needs the user's approval and a test that it fires.
- The lint matches text: it misses traps written a new way and can flag deliberate patterns.
- A saved answer made by your own earlier query proves stability, not truth.

### Next
- Two levels instead of four in the user-facing wording ("Check" for yourself, "Confirm" for reports), keeping T0-T3
  as the names of the individual checks.
- A "what the checker taught us" column in the ledger, plus a reminder for `T3 pending` items left open.
- Backfill the ledger from past independent-checker answers; add a hook; count checker round trips before vs after.

## v0.1.0 — Initial release
Objective-based projects, knowledge hub with a router, worklog memory, reflect-and-fix mistake skills,
weekly knowledge review, 45 rules (small always-on core, the rest loaded by skills).
