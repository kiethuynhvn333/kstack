# UI spec — how every growth dashboard looks

Used by `skills/growth-dashboard/` step 8. `assets/dashboard-template.html` already follows this
spec; read it when you add or change anything by hand, or build the page in another tool (a live
dashboard, a BI tool), so it still looks and reads the same.

**The feel:** a quiet working page. Ink on a soft neutral background, white cards with hairline
borders, big numbers in a serif, everything else in a plain sans. Color is used for meaning only:
one color per source of growth, green/red for good/bad change. No gradients, no shadows on cards,
no icons or emoji as decoration.

## Page order (top to bottom)

1. **Header.** Page title (serif, regular weight) and one takeaway sentence in muted text with the
   key numbers in bold: what happened in the chosen period, and which source drove it.
2. **Filter row.** Segment as a segmented button group (`All` first), period as a dropdown
   (newest first, partial periods labelled "Oct 2026 (1–26)"), and "Data to <date>" pushed right.
3. **Metric tiles**, grouped under small uppercase labels ("Volume", "Efficiency"), max 4 per group.
4. **Two chart cards side by side** (stack on narrow screens): contribution (stacked bars) and
   efficiency (lines by source). A funnel card follows when the metrics are stages.
5. **Sources of growth** status card: one row per source with its value, share, change and a pill.
6. **Detail table** card: every segment × source for the chosen period.
7. **How to read this** card: definitions and every caveat, as a short bullet list.

## Tokens

Define every color on `:root` and redefine it for dark mode (`prefers-color-scheme: dark`, plus
`[data-theme]` overrides). Components use tokens only, never literal colors.

| Token | Light | Dark | Used for |
|---|---|---|---|
| `--bg` | `#f6f6f3` | `#181817` | Page background |
| `--panel` | `#ffffff` | `#222220` | Cards, tiles, table header |
| `--line` | `#e3e2dd` | `#353532` | Card borders, table rules (1px) |
| `--fg` | `#1c1c1a` | `#ecebe6` | Text, selected segment button |
| `--muted` | `#6a6964` | `#a4a39d` | Notes, labels, axis text |
| `--ok` / `--bad` / `--warn` | `#1d7a4c` / `#b42318` / `#9a6700` | `#5cc48e` / `#f4776b` / `#e3b252` | Good / bad change, pills |
| `--grid` / `--axis` / `--ref` | `#ecebe6` / `#c8c7c1` / `#8c8b85` | `#2c2c2a` / `#4b4b47` / `#8c8b85` | Chart grid, axis, reference lines |
| `--series-muted` | `#bdbcb5` | `#5b5a55` | "Not linked" and de-emphasised series |
| `--s1`…`--s8` | `#2f6fd6 #d9822b #7a5bd6 #1f9e89 #c94f7c #8a9a2b #4aa3c9 #a0522d` | `#6f9ff2 #f2a65e #a68ef2 #4fcab3 #e883aa #b6c75d #80c7e8 #d48a64` | Sources of growth, in the order listed in the data |

**Type:** numbers and the page title in **Source Serif 4** (weight 400); everything else in
**IBM Plex Sans** (Google Fonts), each with a system fallback. Sizes: caption 12px, body 14px,
heading 16px (weight 500), title 28px. `font-variant-numeric: tabular-nums` wherever numbers line up.

**Space:** 4 / 8 / 12 / 16 / 24 px steps; card padding 16px; gap between cards 12px, between
sections 24px; corner radius 8px. Side gutter at least 16px; grids use
`repeat(auto-fit, minmax(min(100%, 11rem), 1fr))` for tiles and `minmax(min(100%, 26rem), 1fr)` for
chart cards, so the page works at phone width without sideways scrolling.

## Components

- **Tile:** label line "Name · what it counts" (caption, muted); value (serif, title size); change
  line (caption): "+6.2% vs month before", green if the move is good, red if bad, grey for spend or
  when |change| < 0.5%. Rate metrics change in points ("+1.3 pts"). Totals in a partial period are
  compared per day ("per day vs month before").
- **Segmented buttons:** one bordered group, 1px dividers; the selected one is filled `--fg` with
  `--bg` text. Visible focus ring.
- **Card:** `--panel`, 1px `--line` border, radius 8px, padding 16px; a heading (16px, 500) that
  states the answer, then a one-line note (caption, muted) saying what is measured.
- **Legend:** small square swatches (0.6rem, radius 2px) + name, above the chart.
- **Tooltip:** small popover, period first in muted text, then one line per series with its swatch
  and formatted value. Stays inside the card.
- **Status pill:** rounded label: Growing (`--ok`), Flat (`--muted`), Declining (`--bad`),
  New (`--warn`), No data (`--muted`, outlined).
- **Table:** caption size, sticky header on `--panel`, numbers right-aligned, the first two columns
  left-aligned, total rows bold, sub-rows show their segment in muted text. Scrolls inside its card.
- **Notes:** a bullet list in caption size, muted, max ~90 characters wide.

## Charts

- Bars: max 32px wide, radius 2px, gap ~30% of the band. Lines: 2px, round caps and joins, a 2.5px
  dot per point, end labels "Name value" pushed apart so they never overlap (no legend needed then).
- Grid: 1px `--grid` lines, 3–5 ticks; tick labels caption size in `--muted`; left margin measured
  from the widest tick label. Y-axis from 0 for counts and costs.
- Stacked bars: sources stack in data order, "Not linked" on top in `--series-muted`; the label above
  each bar is the share that matters (e.g. paid share of all channels).
- Funnel: horizontal bars from one left edge, each labelled with its value and the % kept from the
  step before; the biggest drop in `--bad`.
- Draw with SVG sized from the card's width (`viewBox`, `width="100%"`), redraw on resize.

## Numbers and words

- Counts: `41,200`. Money: compact above a million (`$1.09M`, `₫1.09B`), full below
  (`$12,350`); unit costs always full, with cents below 100 (`$6.42`). Percent: one decimal (`6.6%`). Changes signed (`+6.2%`).
- Currency symbol and conversion rate are stated in the notes.
- Periods: "Sep 2026"; partial "Oct 2026 (1–26)"; dates "26 Oct 2026".
- Empty or not-applicable values show "—", never 0.
- Plain words, sentence case, no jargon without a definition in "How to read this".
- Sample data shows a visible "Sample — not your data" badge in the header.

## States

- Loading: grey rounded placeholder bars where values will be. No spinners.
- Failed: one centered line in the card: a small red dot + "Failed to load", same card height.
- Empty chart: one muted line under the heading saying why ("No cost data for this segment").
