# T1 check queries

One file per source table, named `t1-<table>.sql`. Each is a single query that returns one row of
counts for a date range: days present vs expected, rows vs distinct grain, invariant breaks.
See `../verification.md` (T1) and the template below.

**Rules for a check file**
- Header states the observed baseline ("calibrated on live data <date>: N rows, all HARD = 0").
- HARD columns: any non-zero stops reporting. INFO columns: report, never stop.
- Explicit column names (no `SELECT *`), `{{START}}` / `{{END}}` placeholders, no real names in the public template.
- Run it on live data once before relying on it. Untested checks are drafts.

**Template (synthetic, untested — adapt to your table and calibrate)**
```sql
-- T1 for example_co.orders_daily. Replace {{START}} / {{END}}.
-- HARD: days_present != days_expected, n_rows != n_distinct_grain, bad_refund_gt_gross
-- INFO: null_discount (normal for non-promo rows)
WITH d AS (
  SELECT order_date, store_id, gross_amount, refund_amount, discount_amount
  FROM `example_co.orders_daily`
  WHERE order_date BETWEEN DATE '{{START}}' AND DATE '{{END}}'
)
SELECT
  (SELECT MAX(order_date) FROM `example_co.orders_daily`) AS table_max_date,
  COUNT(DISTINCT order_date) AS days_present,
  DATE_DIFF(DATE '{{END}}', DATE '{{START}}', DAY) + 1 AS days_expected,
  COUNT(*) AS n_rows,
  COUNT(DISTINCT CONCAT(CAST(order_date AS STRING), '|', store_id)) AS n_distinct_grain,
  COUNTIF(refund_amount > gross_amount) AS bad_refund_gt_gross,
  COUNTIF(discount_amount IS NULL) AS info_null_discount
FROM d
```
