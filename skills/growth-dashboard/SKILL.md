---
name: growth-dashboard
description: Build a growth overview dashboard for someone who has never made one. It asks a few plain questions (what industry, which metrics you grow, where the data is, which sources bring growth), checks the numbers, and builds the dashboard as an HTML page or a Google Sheets / Excel workbook, showing the key metrics, how much each source of growth contributes, and whether each source is growing, flat or declining. Uses a standard chart guide and one UI spec, so every dashboard looks and reads the same. Use when the user says "growth dashboard", "growth overview", "see all my growth sources", "which channel brings growth", "track my key metrics", "build me a dashboard of my growth", or "refresh my growth dashboard".
---

# Growth dashboard — one page that shows what grows and what drives it

> **Step 0 — read first (only inside a kstack workspace):** `rules/analysis.md` (rules 22–29).
> Outside kstack, skip it: this skill works in any AI tool that can read files.

## Hard stop — the order is fixed
**Questions → plan → yes → Checks → yes → build → deliver.** One stage per reply.
- **Do NOT build anything** (no `dashboard-data.json`, no `build_workbook.py`, no HTML) until the
  user has answered the step 1–4 questions **in this conversation**.
- **An attached data file does NOT answer steps 1–4 and does NOT skip them.** Read it, then still ask,
  and use it to *suggest* answers ("your file has Google, Meta, Email — right?").
- Ask steps 1–4 **in one message**, then **stop and wait**.
- **Never send the Checks (step 7) in the same message as the built file.** Checks first, wait for
  the yes, then build.
- Only exception: "refresh" with an existing spec file (see below).
- Reply in the language the user writes in.

**Who it is for:** a growth or marketing person who wants one view of (1) the few metrics they are
trying to grow, (2) which sources of growth bring them (paid ads, email, push, SEO…), and (3) the
status of each source. Assume they have never built a dashboard and don't know the words.

**How to talk:** plain words, short. Steps 1–4 go in one message; after that, one step per reply.
Every question offers numbered choices plus "something else" and "not sure — pick for me". Never ask for passwords or API keys in
chat; connecting a tool is done in the tool's own settings.

**What you produce:**
1. A dashboard plan the user approves (step 5), then a Checks message the user approves (step 7) —
   both before you build anything.
2. `dashboard-data.json`: the checked numbers in one format (described at the top of
   `assets/dashboard-template.html`). Both versions of the dashboard are built from this one file.
3. The dashboard (step 8), in the version the user picks (step 5):
   - **Web page (HTML):** `assets/dashboard-template.html` with the data dropped in. Opens in any
     browser; nicest to look at. In a tool with live dashboards (e.g. Claude artifacts), you may build
     it there with the same layout and live queries instead.
   - **Spreadsheet (Google Sheets or Excel):** an `.xlsx` workbook built by
     `assets/build_workbook.py`, laid out as in `references/spreadsheet-spec.md`. Opens in Excel, and in
     Google Sheets by importing it. Familiar, easy to share, and can refresh from a connected sheet.
   Both follow the same chart guide and the same look (`references/ui-spec.md`).
4. `growth-dashboard-spec.md`: the answers, metric definitions, data source, queries and the chosen
   version, so the next refresh is one sentence ("refresh my growth dashboard"). In kstack, save all
   files in `projects/<project>/deliverables/growth-dashboard/`; elsewhere, together in a folder the
   user names.

If a spec file already exists and the user says "refresh", skip to step 6 with the same spec
(steps 7 and 8 still apply: Checks, a yes, then build).

## Step 1 — Industry
Ask: "What kind of business do you grow?" Show the list in `references/industries.md` (short
names, numbered). If they answer in their own words, map it to the closest one and say which. The
industry only picks good **suggestions** for the next steps; it never limits them.

## Step 2 — Metrics you grow
1. Show the industry's **north-star** metric and 5–8 typical metrics from `references/industries.md`,
   each with a one-line meaning. Ask them to pick (e.g. "1, 3, 4") and to add any of their own.
2. For each picked metric, confirm in one line: what is counted (people, actions, money), over what
   time (per day, per month), and whether up is good. Write it down exactly; it goes in the spec.
3. Ask whether they have **targets** for any of them (optional; shown as a target line).
4. Keep it to **8 metrics at most** on the page. More go in the table only.

Say it plainly when two metrics cannot be added up: people counted per source overlap (one person
can come from Google and email on the same day), so a total of people is never the sum of sources.

## Step 3 — Where the data is
Offer the options in `references/data-sources.md`, easiest first for them:
- **A. A live connection** their AI tool already has (BigQuery, Google Sheets, GA4, a CRM, Shopify,
  an ads platform…). Best: the dashboard can refresh by itself.
- **B. A file**: export a CSV or Excel and attach it. Fine to start; refresh means a new file.
- **C. Paste a small table** into the chat. For a first try only.
- **D. Not sure / no data yet**: show the made-up sample (`assets/dashboard-template.html` as it
  ships), clearly labelled "Sample — not your data", then come back with real data. The sample is a
  **marketplace**: if their industry is different, say so in one line. Picking D does **not** skip
  the rest: still ask step 4 (sources) and show the step 5 plan, and open or copy the sample only
  after their yes.

Then check the connection works (rule 30 in kstack: never assume it does): read a few rows, show the
column names and the date range found, and ask "is this the right data?" If a connector needs a
sign-in, tell them where to do it, then wait. If a file is already attached, read it first and put
what you found (columns, date range, guessed sources and metrics) at the top of your steps 1–4
message as suggestions to confirm.

## Step 4 — Sources of growth
1. Ask which sources bring growth today. Suggest the usual ones for their industry
   (`references/industries.md`) grouped as **Paid** (search, social, video, app ads…), **Owned**
   (email, push, in-app, SMS/chat apps, CRM), **Organic** (SEO, direct, referral, social posts,
   app store) and **Other** (partners, sales team, offline).
2. Find how the data tells sources apart (a `source`/`channel`/`utm_source` column, campaign names,
   separate files per source). Show the mapping as a short table and ask them to confirm it.
3. Anything that matches no source stays visible as **"Not linked"**. Never hide it or spread it
   over the other sources. Its size is itself a finding: big "Not linked" = tracking gap.
4. Cost: only sources with spend get unit costs (cost per user, per lead…). Ask where spend lives
   if it is in another file or table.

## Step 5 — Show the plan, get a yes
In chat, at most ~15 lines: the metrics (with definitions), the sources, the data source, the time
grain and window (default: monthly, last 6 months; weekly for a young business), which chart
shows what (from `references/chart-guide.md`), and **the version**: "1. a web page you open in your
browser, or 2. a Google Sheets / Excel file". If they are not sure: a spreadsheet when they will
share it with a team or edit it, a web page when it is just for them. Add **one line of pushback** if you see a problem
(e.g. "paid is only ~8% of your users, so the total will barely move even if paid doubles").
Ask what to add or remove, then **stop and wait. Build nothing before the user says yes.**

## Step 6 — Pull the numbers
1. Aggregate at the source (SQL `GROUP BY`, a pivot) into one table: `period × segment × source`,
   one column per metric, plus a total row per period and segment computed **from raw data**. Save
   the query or steps in the spec.
2. **People totals.** When the data has one row per source, the same person can appear in more than
   one source, so there is **NO de-duplicated total**. Leave people totals (signups, sellers, buyers,
   users…) **empty** (no value in the total row; the tile shows "—") and add a note: "No total:
   people overlap across sources." **Never sum people across sources.** Only exceptions: the user
   gives a de-duplicated total, or you count distinct people from user-level rows. Money and action
   counts (orders, GMV, spend, leads) do add up. Mark people metrics `"people": true` in the data file.
3. **Self-check:** if a people total equals the exact sum of its per-source values, that is an error.
   Fix it and do not build. (`build_workbook.py` refuses to build it.)

## Step 7 — Checks: send them, wait for the yes
Its own step. **Never in the same message as the built file.**
1. Run these checks and fix anything that fails (in kstack, also run `skills/verify-number/`):
   - **Freshness:** the latest date in the data; the current period is labelled partial.
   - **Parts vs total:** money and action counts across sources add up to the total (± rounding);
     people counts have no total (step 6) or one from raw data.
   - **No summed people:** no people total equals the sum of its sources.
   - **Impossible values:** people with a lead ≤ active people; leads ≥ people with a lead;
     cost ≥ 0; rates between 0 and 100% (**a rate above 100% is a bug**: fix its definition or drop
     the chart).
   - **Unit costs:** a cost per *daily-average* person uses daily cost (cost ÷ days ÷ people);
     a cost per action uses the period total (cost ÷ actions).
   - **Two raw examples:** look at one normal and one extreme row yourself.
2. Post a short "Checks" message in chat: each check above with pass / fail / not run, the latest
   date found, and what was not checked. Writing the checks only in the spec file does not count.
3. **Stop and wait for the user's yes.** Then go to step 8.

## Step 8 — Build the dashboard
1. Pick each chart from `references/chart-guide.md`. Default content, in this order: header with a
   one-sentence takeaway → filters (segment, period) → metric tiles with change vs the period before
   → contribution chart (stacked bars) → efficiency chart (lines by source; **only with spend data**)
   → funnel (**only** when the steps are the same people) → **status of each source** → detail table
   → "How to read this" notes. Rules:
   - **Efficiency / cost chart only when spend data exists.** No spend, no efficiency chart: leave
     `efficiency` out of the data file.
   - **Funnel only when every step counts the same people, in the same unit and period.** No mixing
     monthly totals with daily averages, no mixing sources. If unsure, leave the funnel out.
   - **A rate above 100% is a bug.** Don't show it: fix the definition or drop the chart.
   - Don't add charts this skill doesn't define.
2. Write `dashboard-data.json` (format at the top of `assets/dashboard-template.html`). Every caveat
   goes in its `notes`: definitions, what "Not linked" is, partial periods, overlaps and why people
   totals are empty, anything missing. Empty or not-available values show "—", never blank.
3. Build the version the user picked:
   - **Web page:** copy `assets/dashboard-template.html` and replace the JSON inside its
     `dashboard-data` block. Follow `references/ui-spec.md` for anything you add by hand.
   - **Spreadsheet:** run `python3 assets/build_workbook.py dashboard-data.json growth-dashboard.xlsx`
     (needs Python with `openpyxl`; ask before installing it). No Python but a Google Sheets
     connector: build the tabs by hand as in `references/spreadsheet-spec.md`. Neither: say so and
     offer the web page. For Google Sheets, tell the user: upload the file to Google Drive, then
     open it with Google Sheets.
4. Open it once to check it works (a screenshot if your tool can; for a workbook, recalculate it and
   check the tiles show numbers or "—", not errors); fix what is visibly broken.

## Step 9 — Hand over
Tell the user, in a few lines: where the file is, what the page shows, the 2–3 things the numbers
already say (facts with their source, not advice), what is not covered, and how to refresh
("say 'refresh my growth dashboard'", or automatic when the data is a live connection; in Google
Sheets, the `Data` tab can be fed by a connected source and everything else recalculates, see
`references/spreadsheet-spec.md`). Offer a
daily refresh only if their tool can schedule tasks, and set one up only on their yes (rule 35).
In kstack: end with `skills/session-close/`.

## Don'ts
- Don't build before steps 1–4 are answered, the plan is approved and the Checks are approved, and
  don't invent data. Sample data is always labelled. An attached file is not an answer.
- Don't send the Checks together with the built file.
- Don't add up people across sources or segments as if they were unique.
- Don't show an efficiency chart without spend, a funnel that mixes units, or a rate above 100%.
- Don't trust an ad platform's own "conversions" as the business result when the user's own data
  has the real outcome; show the platform number only as a hint.
- Don't hide "Not linked", partial periods or missing sources.
- No real company data in anything you publish or share outside the user's own workspace.
