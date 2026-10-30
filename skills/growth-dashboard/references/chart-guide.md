# Chart guide — which chart for which question

Used by `skills/growth-dashboard/` steps 5 and 8. Pick the chart by **the question the reader has**,
not by the data. One chart answers one question; its title says the question's answer in plain words.
Charts marked ★ are built into `assets/dashboard-template.html`; the rest you draw by hand following
`references/ui-spec.md`.

| # | The reader asks… | Chart | Example | Rules |
|---|---|---|---|---|
| 1 | "Where are we now, and is it better than before?" | ★ **Metric tile** (big number + change vs the period before) | DAU 41,200, +6.2% vs Aug | Change colored by whether up is good for that metric; spend is neutral (grey) |
| 2 | "How has this metric moved over time?" | ★ **Line chart** | Monthly active users, last 6 months | Counts per period with ≤ 8 periods may use bars instead. Start the y-axis at 0 for counts |
| 3 | "Which source brings how much of the total, over time?" | ★ **Stacked bar chart** (one bar per period, one segment per source) | Leads per month split by Google / Meta / Email / Not linked | "Not linked" last and grey. Label each bar with the share that matters (e.g. paid share of all) |
| 4 | "Where do people drop off?" | ★ **Funnel bars** (horizontal, all from one left edge, step-to-step loss shown) | Visit → active → viewed listing → contacted | Biggest loss in the danger color. Only for stages of the same people, in order |
| 5 | "Which source is most / least efficient?" (over time) | ★ **Multi-line chart** with end labels | Cost per lead by source, monthly | Leave out tiny sources whose unit cost swings wildly, and say so in the note |
| 6 | "How do sources or segments compare right now?" | ★ **Horizontal bar chart**, sorted | Leads by source this month | Sorted largest first; one color unless a bar needs to stand out |
| 7 | "Is each source growing, flat or shrinking?" | ★ **Status table** with pills | Google: Growing +12% · Email: Declining −9% | Thresholds on the page (default ±5%); "New" when there was nothing before |
| 8 | "Show me every number" | ★ **Detail table** (sticky header, numbers right-aligned, total rows bold) | Segment × source × all metrics for one month | Same column order as the tiles |
| 9 | "What is the mix right now?" | **100% stacked bar** (one bar) or a sorted horizontal bar | Share of new users by source this month | A pie only with ≤ 4 parts; never a donut of 8 slices |
| 10 | "Are we on track for the target?" | **Bullet bar** (actual bar, target tick, expected-to-date tick) | Leads month-to-date vs target | Show the pace: expected so far = target × days passed ÷ days in period |
| 11 | "Does spending more bring more?" | **Scatter** (one dot per source or campaign; spend vs result) | Spend vs leads by campaign | Dots labelled; both axes from 0; no trend line unless asked |
| 12 | "Do people we bring in stay?" | **Cohort heatmap** (start month × months since) | Retention by sign-up month | One color ramp; cells show the %; newest cohorts are shorter |
| 13 | "What explains the change from last month?" | **Waterfall / bridge** | Leads Aug → Sep: +Google, −Meta, −Email… | Starts and ends with the totals; ups and downs in good/bad colors |
| 14 | "Is today unusual?" (daily data) | **Line with a 7-day average** over faint daily dots | Daily leads | Mark weekends or known events if the user gives them |
| 15 | "Same metric for each segment" | **Small multiples** (one small line or bar chart per segment) | Leads by city, 6 cities | Same scale on every small chart |

## Rules for every chart
- **No dual y-axes.** Two metrics with different units → two charts.
- **Don't mix daily averages and totals** on one axis.
- **No spend data, no efficiency chart.** Cost and unit-cost charts need real spend.
- **A funnel only for the same people, same unit, same period** (no totals mixed with daily averages,
  no sources mixed). **A rate above 100% is a bug**: fix the definition or drop the chart.
- **Don't stack people counts as if they were unique** unless the total is computed separately;
  the stacked total then may exceed the real total, and the note must say so.
- **Partial periods** are labelled (e.g. "Oct 2026 (1–26)"); compare totals per day, not raw.
- Every chart has a title (the answer) and a one-line note (what is measured, units, what is left out).
- Use the source colors from `references/ui-spec.md` in the same order on every chart, so Google is
  the same color everywhere on the page.
