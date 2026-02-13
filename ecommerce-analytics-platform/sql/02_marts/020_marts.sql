-- E-commerce (Olist) demo: marts layer (dim/fact)

DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS fact_orders;
DROP TABLE IF EXISTS fact_order_items;

CREATE TABLE dim_date AS
SELECT DISTINCT (order_purchase_ts::date) AS date_id
FROM stg_orders
WHERE order_purchase_ts IS NOT NULL;

CREATE TABLE dim_customer AS
SELECT DISTINCT
  customer_unique_id,
  customer_state
FROM stg_customers;

CREATE TABLE dim_product AS
SELECT DISTINCT
  product_id,
  product_category_name
FROM stg_products;

-- Fact: order-level (one row per order)
CREATE TABLE fact_orders AS
WITH pay AS (
  SELECT order_id, SUM(payment_value) AS paid_value
  FROM stg_order_payments
  GROUP BY 1
)
SELECT
  o.order_id,
  o.customer_id,
  c.customer_unique_id,
  o.order_purchase_ts::date AS date_id,
  o.order_status,
  COALESCE(p.paid_value,0) AS paid_value
FROM stg_orders o
JOIN stg_customers c ON o.customer_id = c.customer_id
LEFT JOIN pay p ON o.order_id = p.order_id;

-- Fact: item-level (one row per order item)
CREATE TABLE fact_order_items AS
SELECT
  i.order_id,
  i.order_item_id,
  i.product_id,
  i.seller_id,
  o.order_purchase_ts::date AS date_id,
  (i.price + i.freight_value) AS item_gmv
FROM stg_order_items i
JOIN stg_orders o ON i.order_id = o.order_id
WHERE o.order_purchase_ts IS NOT NULL;
