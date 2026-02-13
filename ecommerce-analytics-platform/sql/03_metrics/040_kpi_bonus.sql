-- Bonus KPIs for interview: monthly repeat rate + delivery on-time

DROP TABLE IF EXISTS kpi_ecom_monthly_repeat;
DROP TABLE IF EXISTS kpi_ecom_delivery_daily;

-- 1) Monthly repeat purchase rate
-- Definition:
-- - active_customers: distinct customers with >=1 order in month
-- - repeat_customers: customers with >=2 orders in month
-- - repeat_rate = repeat_customers / active_customers
CREATE TABLE kpi_ecom_monthly_repeat AS
WITH orders_monthly AS (
  SELECT
    date_trunc('month', date_id::timestamp)::date AS month_id,
    customer_unique_id,
    COUNT(*) AS orders_cnt
  FROM fact_orders
  GROUP BY 1,2
)
SELECT
  month_id,
  COUNT(*) AS active_customers,
  COUNT(*) FILTER (WHERE orders_cnt >= 2) AS repeat_customers,
  CASE
    WHEN COUNT(*) = 0 THEN 0
    ELSE COUNT(*) FILTER (WHERE orders_cnt >= 2)::numeric / COUNT(*)
  END AS repeat_rate
FROM orders_monthly
GROUP BY 1
ORDER BY 1;

-- 2) Delivery on-time metrics (daily)
-- Definition:
-- - on_time: delivered_customer_ts::date <= estimated_delivery_ts::date
-- - only consider orders with both delivered and estimated timestamps present
CREATE TABLE kpi_ecom_delivery_daily AS
WITH delivered AS (
  SELECT
    order_purchase_ts::date AS date_id,
    CASE
      WHEN delivered_customer_ts IS NULL OR estimated_delivery_ts IS NULL THEN NULL
      WHEN delivered_customer_ts::date <= estimated_delivery_ts::date THEN 1
      ELSE 0
    END AS is_on_time,
    CASE
      WHEN delivered_customer_ts IS NULL OR estimated_delivery_ts IS NULL THEN NULL
      ELSE (delivered_customer_ts::date - estimated_delivery_ts::date)
    END AS delay_days
  FROM stg_orders
)
SELECT
  date_id,
  COUNT(*) FILTER (WHERE is_on_time IS NOT NULL) AS delivered_orders_with_eta,
  AVG(is_on_time::numeric) AS on_time_rate,
  AVG(delay_days::numeric) AS avg_delay_days
FROM delivered
GROUP BY 1
ORDER BY 1;
