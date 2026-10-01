# Workspace — Example Co. (SYNTHETIC EXAMPLE — not a real company)

status: example
<!-- The setup interview (rules/setup.md) copies this file to workspace.md and fills it in.
     Any answer not given yet stays `unknown`. An unknown permission always means "ask first".
     Keep your real workspace.md in a PRIVATE repo — never push it to the public template (rule 36). -->
last updated: 2026-01-15 · confirmed by: the user

## Business
<!-- Rule 2–3. Used by rule 22: every recommendation ties back to this. -->
- What we sell: home furniture, online store with delivery in 2 cities
- Business model: e-commerce (online orders) + showroom visits booked online
- A "win" means: a paid order that isn't returned within 14 days — not a click, not a platform conversion
- Main constraint: delivery capacity is capped at ~400 orders/week per city

## My role and scope
<!-- Rule 2. What the user owns decides which projects and actions are theirs. -->
- Role: performance marketing lead, in-house
- I own: paid search, paid social, marketplace ads
- I don't own (read-only for me): SEO, CRM/email, website changes — owner: web team

## Segments
<!-- Rule 2. Each segment becomes a folder: projects/<project>/<segment>/.
     Split by whatever you actually manage day to day: brand, market, client, product line. -->
| Segment | What it covers |
|---|---|
| `sofas` | Sofas and armchairs |
| `beds` | Beds and mattresses |
| `cross-segment` | Anything not scoped to one segment |

## Objectives → projects
<!-- Rule 3. Each objective with its own target becomes a project folder. -->
| Project folder | Objective | Target | By | Constraints |
|---|---|---|---|---|
| `grow-online-orders` | More kept orders from paid media | 1,200 kept orders/month | 2026-06-30 | CPA ≤ $18; delivery cap |
| `showroom-bookings` | More booked showroom visits | 300 bookings/month | 2026-03-31 | unknown |

## Metrics
<!-- Rule 23. The agent checks these before using any number. Source of truth beats platform numbers (rule 22). -->
| Metric | Definition | Source of truth | Unit | Attribution window |
|---|---|---|---|---|
| Kept order | Paid order not returned within 14 days | Store back office export | order | 7-day click, last paid touch |
| CPA | Paid media spend ÷ kept orders | Ad platform spend + back office | USD per order | same as kept order |
| Booking | Showroom visit booked and confirmed by phone | Booking tool | booking | 7-day click |
| Platform conversions | What each ad platform reports | Ad platform | varies | platform default — diagnostic only |

## Channels and accounts
<!-- Rules 22, 32. The channel's role stops unfair comparisons (search captures demand, social creates it). -->
| Platform | Account | Role of the channel | Monthly budget |
|---|---|---|---|
| Google Ads | "Example Co – Search" | Capture people already searching | $15,000 |
| Meta Ads | "Example Co – Social" | Create new demand, retarget visitors | $9,000 |
| TikTok Ads | unknown | unknown | unknown |

## Tools and data sources
<!-- Rules 6, 30, 31. List what exists AND what it's trusted for. The agent still checks each one works. -->
| Tool / source | Used for | Access | Trusted for |
|---|---|---|---|
| Google Ads connector | Spend, clicks, campaign settings | read-only | spend, delivery |
| Meta Ads connector | Spend, delivery, audiences | read + write (see Permissions) | spend, delivery |
| Back office export (CSV, weekly) | Orders, returns | read-only | kept orders — source of truth |
| Analytics tool | Sessions, landing pages | read-only | on-site behavior only, not orders |
| Team chat | Sending updates | write — needs approval | — |

## Verification
<!-- Rules 6, 26. Who or what can independently confirm a number, and when it is required.
     The agent verifies a method once, saves it as a recipe, and asks this checker only when a
     method is new or changed (knowledge/verification.md). unknown = ask the user. -->
- Independent checker: the data team's analytics bot in Slack (#data-help) — reply usually in 30–60 min
- Trusted for: reproducing warehouse metrics and checking definitions. Not for: ad-platform screens
- May the agent message it without asking each time? no — the user approves each batch
- Raw ground-truth source (instant, no waiting): back office export
- Required tier by use: defaults in knowledge/verification.md (override here if needed)

## Permissions
<!-- Rules 5, 33, 34. Anything not listed here counts as "ask first". -->
| Action | Agent can do alone? | Who approves |
|---|---|---|
| Read accounts, pull reports, run analysis | yes | — |
| Draft recommendations, copy, reports | yes | — |
| Edit files in this repo | yes | — |
| Commit / push this repo | no | the user |
| Change budget, bids, targeting, or pause/resume | no | the user; a change above $1,000/month also the marketing manager |
| Create a campaign | no — always created paused | the user |
| Change conversion tracking or tags | no | the user + web team |
| Publish anything public, send any message | no | the user, each time |
| Create a recurring or scheduled task | no | the user |

## Defaults
<!-- Rules 6, 23, 44. -->
- Timezone: UTC · Currency: USD ($) · Week starts: Monday
- Reporting: weekly update to the marketing manager, Monday 10:00 UTC
- Knowledge review cadence: every Monday, or when the inbox reaches 20 items

## House rules
<!-- Your own extra rules. They add to AGENTS.md; they never remove its safety rules. -->
- Never compare Search and Social on CPA alone — they do different jobs.
- During the delivery cap, don't scale any campaign above +20% budget per week.

## Still unknown
<!-- Setup keeps this list so the next session knows what to ask when it matters (rule 9). -->
- Showroom bookings: constraints on the objective
- TikTok Ads: account, role, budget
