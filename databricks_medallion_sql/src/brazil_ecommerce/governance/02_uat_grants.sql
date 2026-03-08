-- 02_uat_grants.sql
-- Purpose:
--   Apply UAT-environment Unity Catalog grants for the medallion schemas.
--
-- Assumptions:
--   - Catalog: uat
--   - Schemas:
--       uat.brazil_ecommerce_bronze
--       uat.brazil_ecommerce_silver
--       uat.brazil_ecommerce_gold
--   - Principals:
--       `dev_engineers`
--       `analysts`
--       `svc_pipeline_uat`

-- =========================================================
-- Catalog access
-- =========================================================

GRANT USE CATALOG ON CATALOG uat TO `dev_engineers`;
GRANT USE CATALOG ON CATALOG uat TO `analysts`;
GRANT USE CATALOG ON CATALOG uat TO `svc_pipeline_uat`;

-- =========================================================
-- Bronze schema
-- Policy:
--   dev_engineers    = read
--   analysts         = no access
--   svc_pipeline_uat = read/write
-- =========================================================

GRANT USE SCHEMA ON SCHEMA uat.brazil_ecommerce_bronze TO `dev_engineers`;
GRANT SELECT ON SCHEMA uat.brazil_ecommerce_bronze TO `dev_engineers`;

GRANT USE SCHEMA ON SCHEMA uat.brazil_ecommerce_bronze TO `svc_pipeline_uat`;
GRANT SELECT, MODIFY ON SCHEMA uat.brazil_ecommerce_bronze TO `svc_pipeline_uat`;

-- =========================================================
-- Silver schema
-- Policy:
--   dev_engineers    = read
--   analysts         = read
--   svc_pipeline_uat = read/write
-- =========================================================

GRANT USE SCHEMA ON SCHEMA uat.brazil_ecommerce_silver TO `dev_engineers`;
GRANT SELECT ON SCHEMA uat.brazil_ecommerce_silver TO `dev_engineers`;

GRANT USE SCHEMA ON SCHEMA uat.brazil_ecommerce_silver TO `analysts`;
GRANT SELECT ON SCHEMA uat.brazil_ecommerce_silver TO `analysts`;

GRANT USE SCHEMA ON SCHEMA uat.brazil_ecommerce_silver TO `svc_pipeline_uat`;
GRANT SELECT, MODIFY ON SCHEMA uat.brazil_ecommerce_silver TO `svc_pipeline_uat`;

-- =========================================================
-- Gold schema
-- Policy:
--   dev_engineers    = read
--   analysts         = read
--   svc_pipeline_uat = read/write
-- =========================================================

GRANT USE SCHEMA ON SCHEMA uat.brazil_ecommerce_gold TO `dev_engineers`;
GRANT SELECT ON SCHEMA uat.brazil_ecommerce_gold TO `dev_engineers`;

GRANT USE SCHEMA ON SCHEMA uat.brazil_ecommerce_gold TO `analysts`;
GRANT SELECT ON SCHEMA uat.brazil_ecommerce_gold TO `analysts`;

GRANT USE SCHEMA ON SCHEMA uat.brazil_ecommerce_gold TO `svc_pipeline_uat`;
GRANT SELECT, MODIFY ON SCHEMA uat.brazil_ecommerce_gold TO `svc_pipeline_uat`;