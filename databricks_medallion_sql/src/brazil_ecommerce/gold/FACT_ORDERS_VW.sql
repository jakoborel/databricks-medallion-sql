-- FACT_ORDERS_VW

USE CATALOG {{CATALOG}};

CREATE OR REPLACE VIEW brazil_ecommerce_gold.FACT_ORDERS_VW AS
SELECT
  order_status,
  COUNT(*) AS order_count
FROM brazil_ecommerce_silver.ORDERS
GROUP BY order_status;