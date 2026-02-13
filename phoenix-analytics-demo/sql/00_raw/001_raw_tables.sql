-- Phoenix demo: raw tables
DROP TABLE IF EXISTS raw_schools;
DROP TABLE IF EXISTS raw_students;
DROP TABLE IF EXISTS raw_orders;
DROP TABLE IF EXISTS raw_attendance;

CREATE TABLE raw_schools (
  school_id      TEXT PRIMARY KEY,
  school_name    TEXT,
  city           TEXT
);

CREATE TABLE raw_students (
  student_id     TEXT PRIMARY KEY,
  school_id      TEXT,
  grade          INT,
  class_name     TEXT
);

CREATE TABLE raw_orders (
  order_id       TEXT PRIMARY KEY,
  school_id      TEXT,
  order_date     DATE,
  amount_cny     NUMERIC(12,2),
  status         TEXT
);

CREATE TABLE raw_attendance (
  attendance_id  TEXT PRIMARY KEY,
  student_id     TEXT,
  attend_date    DATE,
  present        INT
);
