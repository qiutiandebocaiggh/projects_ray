-- Putian demo: marts (dim/fact)

DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS fact_project_finance;
DROP TABLE IF EXISTS fact_project_delay;

CREATE TABLE dim_customer AS
SELECT * FROM stg_customers;

-- Dates from sign/pay/milestone
CREATE TABLE dim_date AS
SELECT DISTINCT d::date AS date_id
FROM (
  SELECT sign_date AS d FROM stg_projects
  UNION
  SELECT pay_date AS d FROM stg_payments
  UNION
  SELECT planned_date AS d FROM stg_milestones
  UNION
  SELECT actual_date AS d FROM stg_milestones WHERE actual_date IS NOT NULL
) t;

-- Finance fact per project (contract vs collected)
CREATE TABLE fact_project_finance AS
WITH paid AS (
  SELECT project_id, SUM(amount) AS paid_amount
  FROM stg_payments
  GROUP BY 1
)
SELECT
  p.project_id,
  p.customer_id,
  p.sign_date,
  p.status,
  p.contract_value,
  COALESCE(x.paid_amount,0) AS paid_amount,
  (p.contract_value - COALESCE(x.paid_amount,0)) AS outstanding_amount,
  CASE
    WHEN p.contract_value = 0 THEN 0
    ELSE (COALESCE(x.paid_amount,0) / p.contract_value)
  END AS collection_rate
FROM stg_projects p
LEFT JOIN paid x ON p.project_id = x.project_id;

-- Delay fact per milestone (planned vs actual)
CREATE TABLE fact_project_delay AS
SELECT
  project_id,
  milestone_id,
  milestone_name,
  planned_date,
  actual_date,
  CASE
    WHEN actual_date IS NULL THEN NULL
    ELSE (actual_date - planned_date)
  END AS delay_days
FROM stg_milestones;
