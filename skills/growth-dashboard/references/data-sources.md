# Data sources — how to get the numbers in

Used by `skills/growth-dashboard/` steps 3, 4 and 6. Offer the options easiest-first for the user.
Never ask for a password, API key or token in chat: connecting happens in the AI tool's own
settings (connectors, MCP servers, integrations), with the user signing in themselves.

## The options

| Option | Good for | Refresh | What the user does |
|---|---|---|---|
| **A. Live connection** (a connector or MCP server their AI tool already has) | Daily use | Automatic, or "refresh my growth dashboard" | Turn on the connector in the tool's settings and sign in. You check it with a small read. |
| **B. File** (CSV, Excel, Google Sheets export) | A first version, or data with no connector | New file each time | Export the report, attach it to the chat |
| **C. Paste a table** | A quick try with a few rows | By hand | Copy-paste from a spreadsheet |
| **D. Sample data** (built into `assets/dashboard-template.html`, a made-up marketplace) | Seeing what they will get before finding data | None | Nothing; the page says "Sample — not your data" everywhere |

Common live connections: data warehouses (BigQuery, Snowflake, Redshift, Databricks), Google Sheets,
Google Analytics 4, ad platforms (Google Ads, Meta, TikTok, LinkedIn), CRMs (HubSpot, Salesforce),
shops (Shopify, WooCommerce), product analytics (Amplitude, Mixpanel), app attribution
(AppsFlyer, Adjust, Branch), email/push tools (Klaviyo, Braze, Mailchimp). Check which ones the
user's tool actually has; don't promise one that isn't there.

## The shape the dashboard needs

One table, one row per **period × segment × source**, one column per metric:

| period | segment | source | days | dau | leads | cost | … |
|---|---|---|---|---|---|---|---|
| 2026-09 | All | Total | 30 | 41,200 | 128,400 | 52,000 | |
| 2026-09 | All | Google Ads | 30 | 9,800 | 31,000 | 30,500 | |
| 2026-09 | All | Not linked | 30 | 1,100 | 3,900 | | |

- **period:** `YYYY-MM` for months, the Monday `YYYY-MM-DD` for weeks.
- **segment:** the slices the user wants to switch between (product line, city, vertical, app vs
  web). Always include an `All` segment.
- **source:** each source of growth, `Not linked`, and `Total`. **Total comes from raw data** for
  metrics that count people (it is less than the sum when people overlap). For money and action
  counts, Total = sum of sources.
- **days:** how many days of data the row covers (the current period is partial).
- Leave a cell empty when it doesn't apply (no cost for organic sources), never 0.

If the raw data comes per day, aggregate it to this shape (SQL `GROUP BY`, a pivot table, or code).
Daily-average metrics (people per day) are averaged over the days; totals (leads, cost) are summed.

## Finding the source of each row

Look in this order and confirm the mapping with the user:
1. A column that already names it: `source`, `channel`, `utm_source` + `utm_medium`, `channel_group`.
2. Campaign names matched to the ad platforms' cost data (a campaign found in Google's cost data is
   Google). Rows matching nothing go to **Not linked**.
3. Separate exports per source (one file from the email tool, one from the ad platform…). Then the
   people counts can't be de-duplicated across files; say so on the page.

## Cost

Cost usually lives apart from the outcome data (in each ad platform). Join it by period, segment
and source. Convert currencies to one currency at a rate the user gives you, and write the rate on
the page. Unit costs, using the same cost basis:
- per **daily-average** people (cost per daily user, per daily person with a lead):
  `(cost ÷ days) ÷ people per day`
- per **action** or per **period-total** people (cost per lead, per order, per new customer):
  `cost ÷ count`
Sanity check: cost per person with a lead ≥ cost per lead, because one person can make several leads.
