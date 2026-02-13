-- Phoenix demo: marts (dim/fact)

DROP TABLE IF EXISTS dim_school;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS fact_orders_daily;
DROP TABLE IF EXISTS fact_attendance_daily;

CREATE TABLE dim_school AS
SELECT * FROM raw_schools;

CREATE TABLE dim_date AS
SELECT DISTINCT d::date AS date_id
FROM (
  SELECT order_date AS d FROM stg_orders
  UNION
  SELECT attend_date AS d FROM stg_attendance
) t;

CREATE TABLE fact_orders_daily AS
SELECT
  order_date AS date_id,
  school_id,
  COUNT(*) AS orders_cnt,
  SUM(CASE WHEN status='paid' THEN amount_cny ELSE 0 END) AS gmv_cny
FROM stg_orders
GROUP BY 1,2;

CREATE TABLE fact_attendance_daily AS
SELECT
  attend_date AS date_id,
  s.school_id,
  AVG(present)::numeric(20,18) AS attendance_rate
FROM stg_attendance a
JOIN raw_students s ON a.student_id = s.student_id
GROUP BY 1,2;
