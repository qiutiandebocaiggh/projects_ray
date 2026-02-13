-- Phoenix demo: metrics layer (KPI output)
-- IMPORTANT: aggregate each fact table first to avoid double counting.

DROP TABLE IF EXISTS kpi_phoenix_daily_v2;

CREATE TABLE kpi_phoenix_daily_v2 AS
WITH orders_daily AS (
  SELECT
    date_id,
    SUM(orders_cnt) AS total_orders,
    SUM(gmv_cny) AS total_gmv_cny,
    COUNT(DISTINCT school_id) AS active_schools
  FROM fact_orders_daily
  GROUP BY 1
),
att_daily AS (
  SELECT
    date_id,
    AVG(attendance_rate) AS avg_attendance_rate
  FROM fact_attendance_daily
  GROUP BY 1
)
SELECT
  d.date_id,
  COALESCE(o.total_orders,0) AS total_orders,
  COALESCE(o.total_gmv_cny,0) AS total_gmv_cny,
  a.avg_attendance_rate,
  COALESCE(o.active_schools,0) AS active_schools
FROM dim_date d
LEFT JOIN orders_daily o ON d.date_id = o.date_id
LEFT JOIN att_daily a ON d.date_id = a.date_id
ORDER BY 1;
