-- Putian demo: raw tables (B2B projects as orders)

DROP TABLE IF EXISTS raw_customers;
DROP TABLE IF EXISTS raw_projects;
DROP TABLE IF EXISTS raw_payments;
DROP TABLE IF EXISTS raw_milestones;

CREATE TABLE raw_customers (
  customer_id    TEXT PRIMARY KEY,
  customer_name  TEXT,
  customer_type  TEXT,   -- gov / edu / enterprise
  region         TEXT
);

CREATE TABLE raw_projects (
  project_id     TEXT PRIMARY KEY,
  customer_id    TEXT,
  sign_date      DATE,
  contract_value NUMERIC(12,2),
  status         TEXT    -- won / in_progress / delivered / lost
);

CREATE TABLE raw_payments (
  payment_id     TEXT PRIMARY KEY,
  project_id     TEXT,
  pay_date       DATE,
  amount         NUMERIC(12,2)
);

CREATE TABLE raw_milestones (
  milestone_id   TEXT PRIMARY KEY,
  project_id     TEXT,
  milestone_name TEXT,
  planned_date   DATE,
  actual_date    DATE
);
