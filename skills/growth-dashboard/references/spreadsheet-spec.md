# Spreadsheet spec — the Google Sheets / Excel version

Used by `skills/growth-dashboard/` step 7 when the user picks a spreadsheet. `assets/build_workbook.py`
builds exactly this from `dashboard-data.json`:

```bash
python3 assets/build_workbook.py dashboard-data.json growth-dashboard.xlsx
```

It needs Python 3 with `openpyxl` (`pip install openpyxl`; ask the user before installing). The file
opens in Excel 2019 or later, and in Google Sheets: upload it to Google Drive, then **Open with →
Google Sheets** (or in a sheet, **File → Import**). Without Python but with a Google Sheets connector,
build the same tabs by hand from this page.

Same content and order as the web page, same chart choices (`references/chart-guide.md`), same
colors and number formats (`references/ui-spec.md`), adapted to what a spreadsheet does well:
formulas instead of code, dropdowns instead of buttons.

## Tabs

| Tab | What it holds | Who edits it |
|---|---|---|
| **Dashboard** | Title, takeaway sentence, Segment and Period dropdowns, metric tiles with change, the contribution chart (stacked columns), the efficiency chart (lines), the funnel (bars), the status of each source | Nobody: all formulas. The user only changes the two dropdowns |
| **Detail** | Every segment × source for the chosen period, every metric | Nobody: formulas |
| **Notes** | "How to read this": definitions and every caveat | You, when the data changes |
| **Data** | The numbers in one long table: `period, segment, source, days, metric, value` | Replaced on every refresh |
| **Setup** | Lists the formulas read: segments, periods (with labels), sources (name, group, color), metrics (name, format, which way is good), settings (threshold, currency) | Rarely: when a source, metric or period is added |
| **Calc** | Helper tables the charts and tiles read from | Nobody |

Everything on **Dashboard** and **Detail** is a formula over **Data**, filtered by the two dropdowns
(`SUMIFS`/`COUNTIFS` on period, segment, source and metric). Empty in Data shows as "—"-style blank,
never 0. Missing values are skipped by the line chart (gaps, not drops to zero).

## Layout of the Dashboard tab
1. Row 1 title (serif, large), row 2 the takeaway sentence (a formula), a "Sample — not your data"
   note when the data is the sample.
2. Row 4: **Segment** dropdown, **Period** dropdown (partial periods labelled), "Data to <date>".
3. Tile rows, grouped under small uppercase labels (Volume, Efficiency): per tile a name line (small,
   grey), the value (large serif) and the change vs the period before (green if good, red if bad,
   grey for spend). Totals in a partial period compare per day; rates change in points.
4. The contribution chart and the efficiency chart side by side, the funnel under them.
5. The status table: source, group, value, share of total, change, status (Growing / Flat /
   Declining / New / No data, colored as in the UI spec), and the source's unit cost.

Gridlines off on Dashboard. Fonts: Georgia for the title and big numbers, Arial for everything else
(both exist in Excel and Google Sheets; in Google Sheets you may switch to Source Serif 4 and
IBM Plex Sans under **More fonts** to match the web page exactly).

## Refreshing
- **Simple:** get the new numbers into `dashboard-data.json` and run the script again.
- **Live in Google Sheets:** keep the same long format in the **Data** tab but fill it from a
  connected source (Connected Sheets for BigQuery, a data connector add-on, or `IMPORTRANGE` from a
  sheet that is updated for you). Everything else recalculates. When a new period starts, add it to
  the periods list in **Setup** (the period dropdown and the charts read that list).

## Checks before handing over
Recalculate (open it, or convert with LibreOffice) and look: tiles show numbers (no `#N/A`,
`#VALUE!`, `#DIV/0!`), the charts have bars and lines, the dropdowns change the numbers, and the
Detail totals match the web page or the data for one period you check by hand.
