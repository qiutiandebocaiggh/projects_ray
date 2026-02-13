-- E-commerce (Olist) demo: staging layer
-- Goal: cast types + standardize timestamps/status

DROP TABLE IF EXISTS stg_orders;
DROP TABLE IF EXISTS stg_order_items;
DROP TABLE IF EXISTS stg_order_payments;
DROP TABLE IF EXISTS stg_customers;
DROP TABLE IF EXISTS stg_products;

CREATE TABLE stg_orders AS
SELECT
  order_id,
  customer_id,
  LOWER(order_status) AS order_status,
  NULLIF(order_purchase_timestamp,'')::timestamp AS order_purchase_ts,
  NULLIF(order_delivered_customer_date,'')::timestamp AS delivered_customer_ts,
  NULLIF(order_estimated_delivery_date,'')::timestamp AS estimated_delivery_ts
FROM orders;

CREATE TABLE stg_order_items AS
SELECT
  order_id,
  order_item_id,
  product_id,
  seller_id,
  NULLIF(shipping_limit_date,'')::timestamp AS shipping_limit_ts,
  price::numeric(12,2) AS price,
  freight_value::numeric(12,2) AS freight_value
FROM order_items;

CREATE TABLE stg_order_payments AS
SELECT
  order_id,
  payment_sequential,
  LOWER(payment_type) AS payment_type,
  payment_installments,
  payment_value::numeric(12,2) AS payment_value
FROM order_payments;

CREATE TABLE stg_customers AS
SELECT
  customer_id,
  customer_unique_id,
  customer_city,
  customer_state
FROM customers;

CREATE TABLE stg_products AS
SELECT
  product_id,
  product_category_name
FROM products;
