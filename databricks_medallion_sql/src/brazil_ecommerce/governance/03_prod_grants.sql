-- 03_prod_grants.sql
-- Purpose:
--   Apply production-environment Unity Catalog grants for the medallion schemas.
--
-- Assumptions:
--   - Catalog: prod
--   - Schemas:
--       prod.brazil_ecommerce_bronze
--       prod.brazil_ecommerce_silver
--       prod.brazil_ecommerce_gold
--   - Principals:
--       `dev_engineers`
--       `analysts`
--       `svc_pipeline_prod`

-- =========================================================
-- Catalog access
-- =========================================================

GRANT USE CATALOG ON CATALOG prod TO `dev_engineers`;
GRANT USE CATALOG ON CATALOG prod TO `analysts`;
GRANT USE CATALOG ON CATALOG prod TO `svc_pipeline_prod`;

-- =========================================================
-- Bronze schema
-- Policy:
--   dev_engineers     = no access
--   analysts          = no access
--   svc_pipeline_prod = read/write
-- =========================================================

GRANT USE SCHEMA ON SCHEMA prod.brazil_ecommerce_bronze TO `svc_pipeline_prod`;
GRANT SELECT, MODIFY ON SCHEMA prod.brazil_ecommerce_bronze TO `svc_pipeline_prod`;

-- =========================================================
-- Silver schema
-- Policy:
--   dev_engineers     = read
--   analysts          = read
--   svc_pipeline_prod = read/write
-- =========================================================

GRANT USE SCHEMA ON SCHEMA prod.brazil_ecommerce_silver TO `dev_engineers`;
GRANT SELECT ON SCHEMA prod.brazil_ecommerce_silver TO `dev_engineers`;

GRANT USE SCHEMA ON SCHEMA prod.brazil_ecommerce_silver TO `analysts`;
GRANT SELECT ON SCHEMA prod.brazil_ecommerce_silver TO `analysts`;

GRANT USE SCHEMA ON SCHEMA prod.brazil_ecommerce_silver TO `svc_pipeline_prod`;
GRANT SELECT, MODIFY ON SCHEMA prod.brazil_ecommerce_silver TO `svc_pipeline_prod`;

-- =========================================================
-- Gold schema
-- Policy:
--   dev_engineers     = read
--   analysts          = read
--   svc_pipeline_prod = read/write
-- =========================================================

GRANT USE SCHEMA ON SCHEMA prod.brazil_ecommerce_gold TO `dev_engineers`;
GRANT SELECT ON SCHEMA prod.brazil_ecommerce_gold TO `dev_engineers`;

GRANT USE SCHEMA ON SCHEMA prod.brazil_ecommerce_gold TO `analysts`;
GRANT SELECT ON SCHEMA prod.brazil_ecommerce_gold TO `analysts`;

GRANT USE SCHEMA ON SCHEMA prod.brazil_ecommerce_gold TO `svc_pipeline_prod`;
GRANT SELECT, MODIFY ON SCHEMA prod.brazil_ecommerce_gold TO `svc_pipeline_prod`;