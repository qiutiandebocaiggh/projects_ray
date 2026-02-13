-- Putian demo: staging layer (clean + standardize)

DROP TABLE IF EXISTS stg_customers;
DROP TABLE IF EXISTS stg_projects;
DROP TABLE IF EXISTS stg_payments;
DROP TABLE IF EXISTS stg_milestones;

CREATE TABLE stg_customers AS
SELECT
  customer_id,
  customer_name,
  LOWER(customer_type) AS customer_type,
  region
FROM raw_customers;

CREATE TABLE stg_projects AS
SELECT
  project_id,
  customer_id,
  sign_date,
  contract_value,
  LOWER(status) AS status
FROM raw_projects;

CREATE TABLE stg_payments AS
SELECT
  payment_id,
  project_id,
  pay_date,
  amount
FROM raw_payments;

CREATE TABLE stg_milestones AS
SELECT
  milestone_id,
  project_id,
  milestone_name,
  planned_date,
  actual_date
FROM raw_milestones;
