-- 01_dev_grants.sql
-- Purpose:
--   Apply development-environment Unity Catalog grants for the medallion schemas.
--
-- Assumptions:
--   - Catalog: dev
--   - Schemas:
--       dev.brazil_ecommerce_bronze
--       dev.brazil_ecommerce_silver
--       dev.brazil_ecommerce_gold
--   - Principals:
--       `dev_engineers`
--       `analysts`
--       `svc_pipeline_dev`
--
-- Notes:
--   - Privileges are granted at the schema level where possible so they inherit to
--     current and future tables/views in the schema.
--   - MODIFY applies to tables, and inherited schema-level MODIFY grants are supported.
--   - USE CATALOG and USE SCHEMA are required alongside SELECT / MODIFY.
--
-- Reference:
--   See README/docs governance matrix for the intended access model.

-- =========================================================
-- Catalog access
-- =========================================================

GRANT USE CATALOG ON CATALOG dev TO `dev_engineers`;
GRANT USE CATALOG ON CATALOG dev TO `analysts`;
GRANT USE CATALOG ON CATALOG dev TO `svc_pipeline_dev`;

-- =========================================================
-- Bronze schema
-- Policy:
--   dev_engineers   = read/write
--   analysts        = no access
--   svc_pipeline_dev = read/write
-- =========================================================

GRANT USE SCHEMA ON SCHEMA dev.brazil_ecommerce_bronze TO `dev_engineers`;
GRANT SELECT, MODIFY ON SCHEMA dev.brazil_ecommerce_bronze TO `dev_engineers`;

GRANT USE SCHEMA ON SCHEMA dev.brazil_ecommerce_bronze TO `svc_pipeline_dev`;
GRANT SELECT, MODIFY ON SCHEMA dev.brazil_ecommerce_bronze TO `svc_pipeline_dev`;

-- =========================================================
-- Silver schema
-- Policy:
--   dev_engineers   = read/write
--   analysts        = read
--   svc_pipeline_dev = read/write
-- =========================================================

GRANT USE SCHEMA ON SCHEMA dev.brazil_ecommerce_silver TO `dev_engineers`;
GRANT SELECT, MODIFY ON SCHEMA dev.brazil_ecommerce_silver TO `dev_engineers`;

GRANT USE SCHEMA ON SCHEMA dev.brazil_ecommerce_silver TO `analysts`;
GRANT SELECT ON SCHEMA dev.brazil_ecommerce_silver TO `analysts`;

GRANT USE SCHEMA ON SCHEMA dev.brazil_ecommerce_silver TO `svc_pipeline_dev`;
GRANT SELECT, MODIFY ON SCHEMA dev.brazil_ecommerce_silver TO `svc_pipeline_dev`;

-- =========================================================
-- Gold schema
-- Policy:
--   dev_engineers   = read/write
--   analysts        = read
--   svc_pipeline_dev = read/write
-- =========================================================

GRANT USE SCHEMA ON SCHEMA dev.brazil_ecommerce_gold TO `dev_engineers`;
GRANT SELECT, MODIFY ON SCHEMA dev.brazil_ecommerce_gold TO `dev_engineers`;

GRANT USE SCHEMA ON SCHEMA dev.brazil_ecommerce_gold TO `analysts`;
GRANT SELECT ON SCHEMA dev.brazil_ecommerce_gold TO `analysts`;

GRANT USE SCHEMA ON SCHEMA dev.brazil_ecommerce_gold TO `svc_pipeline_dev`;
GRANT SELECT, MODIFY ON SCHEMA dev.brazil_ecommerce_gold TO `svc_pipeline_dev`;