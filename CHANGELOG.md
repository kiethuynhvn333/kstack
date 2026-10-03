# Changelog

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
