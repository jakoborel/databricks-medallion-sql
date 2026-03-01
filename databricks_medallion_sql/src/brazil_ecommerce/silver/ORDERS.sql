-- ORDERS.sql

USE CATALOG {{CATALOG}};

CREATE TABLE IF NOT EXISTS brazil_ecommerce_silver.ORDERS
USING DELTA
AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM brazil_ecommerce_bronze.ORDERS_RAW;