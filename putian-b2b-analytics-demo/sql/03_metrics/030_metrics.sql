-- Putian demo: metrics (KPI output)
-- Provide a project-level & overall KPI view

DROP TABLE IF EXISTS kpi_putian_overall;
DROP TABLE IF EXISTS kpi_putian_by_customer;

-- Overall KPIs (exclude lost projects for pipeline metrics)
CREATE TABLE kpi_putian_overall AS
SELECT
  COUNT(*) FILTER (WHERE status <> 'lost') AS active_projects,
  SUM(contract_value) FILTER (WHERE status <> 'lost') AS total_contract_value,
  SUM(paid_amount) FILTER (WHERE status <> 'lost') AS total_collected_revenue,
  SUM(outstanding_amount) FILTER (WHERE status <> 'lost') AS total_outstanding_revenue,
  CASE
    WHEN SUM(contract_value) FILTER (WHERE status <> 'lost') = 0 THEN 0
    ELSE (
      SUM(paid_amount) FILTER (WHERE status <> 'lost')
      / SUM(contract_value) FILTER (WHERE status <> 'lost')
    )
  END AS overall_collection_rate
FROM fact_project_finance;

-- Customer KPIs
CREATE TABLE kpi_putian_by_customer AS
WITH delay_by_project AS (
  SELECT project_id, AVG(delay_days) AS avg_delay_days
  FROM fact_project_delay
  GROUP BY 1
)
SELECT
  c.customer_id,
  c.customer_name,
  c.customer_type,
  c.region,
  COUNT(*) FILTER (WHERE f.status <> 'lost') AS projects_cnt,
  SUM(f.contract_value) FILTER (WHERE f.status <> 'lost') AS contract_value,
  SUM(f.paid_amount) FILTER (WHERE f.status <> 'lost') AS collected_revenue,
  SUM(f.outstanding_amount) FILTER (WHERE f.status <> 'lost') AS outstanding_revenue,
  AVG(d.avg_delay_days) AS avg_delay_days
FROM fact_project_finance f
JOIN dim_customer c ON f.customer_id = c.customer_id
LEFT JOIN delay_by_project d ON f.project_id = d.project_id
GROUP BY 1,2,3,4
HAVING COUNT(*) FILTER (WHERE f.status <> 'lost') > 0
ORDER BY contract_value DESC NULLS LAST;

