-- E-commerce (Olist) demo: metrics layer (KPI output)
-- IMPORTANT: avoid double counting by aggregating at consistent grain before joining.

DROP TABLE IF EXISTS kpi_ecom_daily;

CREATE TABLE kpi_ecom_daily AS
WITH
-- daily orders (order grain)
daily_orders AS (
  SELECT
    date_id,
    COUNT(*) AS orders_cnt,
    COUNT(*) FILTER (WHERE paid_value > 0) AS paid_orders_cnt
  FROM fact_orders
  GROUP BY 1
),
-- daily gmv (item grain -> aggregated to date)
daily_gmv AS (
  SELECT
    date_id,
    SUM(item_gmv) AS gmv
  FROM fact_order_items
  GROUP BY 1
),
-- new vs returning customers (customer_unique_id first purchase date)
first_purchase AS (
  SELECT
    customer_unique_id,
    MIN(date_id) AS first_date
  FROM fact_orders
  GROUP BY 1
),
daily_customers AS (
  SELECT
    f.date_id,
    COUNT(DISTINCT f.customer_unique_id) FILTER (WHERE fp.first_date = f.date_id) AS new_customers,
    COUNT(DISTINCT f.customer_unique_id) FILTER (WHERE fp.first_date < f.date_id) AS returning_customers
  FROM fact_orders f
  JOIN first_purchase fp ON f.customer_unique_id = fp.customer_unique_id
  GROUP BY 1
)
SELECT
  d.date_id,
  COALESCE(o.orders_cnt,0) AS orders_cnt,
  COALESCE(o.paid_orders_cnt,0) AS paid_orders_cnt,
  COALESCE(g.gmv,0) AS gmv,
  CASE
    WHEN COALESCE(o.paid_orders_cnt,0) = 0 THEN 0
    ELSE (g.gmv / o.paid_orders_cnt)
  END AS aov,
  COALESCE(c.new_customers,0) AS new_customers,
  COALESCE(c.returning_customers,0) AS returning_customers
FROM dim_date d
LEFT JOIN daily_orders o ON d.date_id = o.date_id
LEFT JOIN daily_gmv g ON d.date_id = g.date_id
LEFT JOIN daily_customers c ON d.date_id = c.date_id
ORDER BY 1;
