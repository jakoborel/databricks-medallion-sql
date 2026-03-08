-- 04_show_grants_checks.sql
-- Verify effective grants after applying governance SQL.


-- =========================================================
-- dev access
-- =========================================================
SHOW GRANTS ON CATALOG dev;

SHOW GRANTS ON SCHEMA dev.brazil_ecommerce_bronze;
SHOW GRANTS ON SCHEMA dev.brazil_ecommerce_silver;
SHOW GRANTS ON SCHEMA dev.brazil_ecommerce_gold;

-- =========================================================
-- uat access
-- =========================================================
SHOW GRANTS ON CATALOG uat;

SHOW GRANTS ON SCHEMA uat.brazil_ecommerce_bronze;
SHOW GRANTS ON SCHEMA uat.brazil_ecommerce_silver;
SHOW GRANTS ON SCHEMA uat.brazil_ecommerce_gold;

-- =========================================================
-- prod access
-- =========================================================
SHOW GRANTS ON CATALOG prod;

SHOW GRANTS ON SCHEMA prod.brazil_ecommerce_bronze;
SHOW GRANTS ON SCHEMA prod.brazil_ecommerce_silver;
SHOW GRANTS ON SCHEMA prod.brazil_ecommerce_gold;
