-- Phoenix demo: staging layer (clean + standardize)

DROP TABLE IF EXISTS stg_orders;
DROP TABLE IF EXISTS stg_attendance;

CREATE TABLE stg_orders AS
SELECT
  order_id,
  school_id,
  order_date,
  amount_cny,
  LOWER(status) AS status
FROM raw_orders;

CREATE TABLE stg_attendance AS
SELECT
  attendance_id,
  student_id,
  attend_date,
  CASE WHEN present = 1 THEN 1 ELSE 0 END AS present
FROM raw_attendance;
