-- ORDERS_RAW.sql
USE CATALOG {{CATALOG}};

CREATE OR REPLACE TABLE brazil_ecommerce_bronze.ORDERS_RAW AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM read_files(
    {{ORDERS_CSV_PATH}},
    format => 'csv',
    header => true
);
