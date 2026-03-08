# Governance Access Matrix

This document defines access permissions for the medallion architecture across environments.

Access control is implemented using **Unity Catalog privileges** and is granted at the **schema level** where possible.

Full implementation of group- and service-principal-based governance is designed in this repository but requires a paid Databricks environment with full identity management support.

Principals used in this model:

| Principal | Type | Description |
|---|---|---|
| dev_engineers | Group | Data engineers developing and maintaining pipelines |
| analysts | Group | Business / analytics users consuming curated datasets |
| svc_pipeline_dev | Service Principal | CI/CD pipeline identity deploying and running dev jobs |
| svc_pipeline_uat | Service Principal | CI/CD pipeline identity for UAT environment |
| svc_pipeline_prod | Service Principal | CI/CD pipeline identity for production pipelines |

Privileges referenced:

| Privilege | Meaning |
|---|---|
| USE CATALOG | Allows referencing a catalog |
| USE SCHEMA | Allows referencing objects in a schema |
| SELECT | Read access to tables/views |
| MODIFY | Insert/update/delete table data |

---

# Dev Environment (`dev` catalog)

Development environment supports full pipeline development and experimentation.

| Layer | dev_engineers | analysts | svc_pipeline_dev |
|---|---|---|---|
| bronze | SELECT, MODIFY | none | SELECT, MODIFY |
| silver | SELECT, MODIFY | SELECT | SELECT, MODIFY |
| gold | SELECT, MODIFY | SELECT | SELECT, MODIFY |

Notes:

- Analysts typically do not need direct access to bronze data.
- Developers can modify all layers for debugging and testing.

---

# UAT Environment (`uat` catalog)

UAT is used for integration testing and validation prior to production promotion.

| Layer | dev_engineers | analysts | svc_pipeline_uat |
|---|---|---|---|
| bronze | SELECT | none | SELECT, MODIFY |
| silver | SELECT | SELECT | SELECT, MODIFY |
| gold | SELECT | SELECT | SELECT, MODIFY |

Notes:

- Developers have read access only to validate pipelines.
- Only the pipeline identity writes to data.

---

# Production Environment (`prod` catalog)

Production environment contains finalized datasets.

| Layer | dev_engineers | analysts | svc_pipeline_prod |
|---|---|---|---|
| bronze | none | none | SELECT, MODIFY |
| silver | SELECT | SELECT | SELECT, MODIFY |
| gold | SELECT | SELECT | SELECT, MODIFY |

Notes:

- Bronze access is restricted to pipeline operations.
- Analysts should primarily consume gold datasets.
- Silver access may be granted for advanced analytical users.

---

# Catalog-Level Access

Catalog access must also be granted to allow principals to reference schemas.

| Catalog | Principal | Privilege |
|---|---|---|
| dev | dev_engineers | USE CATALOG |
| dev | analysts | USE CATALOG |
| dev | svc_pipeline_dev | USE CATALOG |
| uat | dev_engineers | USE CATALOG |
| uat | analysts | USE CATALOG |
| uat | svc_pipeline_uat | USE CATALOG |
| prod | dev_engineers | USE CATALOG |
| prod | analysts | USE CATALOG |
| prod | svc_pipeline_prod | USE CATALOG |

---

# Schema Structure

Each catalog contains three schemas following the medallion pattern:

```
<catalog>.brazil_ecommerce_bronze
<catalog>.brazil_ecommerce_silver
<catalog>.brazil_ecommerce_gold
```

Permissions are granted at the **schema level**, allowing inheritance to tables and views.

---

# Implementation

Privileges will be applied using SQL grant statements maintained in this repository.

Example:

```sql
GRANT USE SCHEMA ON SCHEMA dev.brazil_ecommerce_silver TO `dev_engineers`;
GRANT SELECT, MODIFY ON SCHEMA dev.brazil_ecommerce_silver TO `dev_engineers`;
```

Governance SQL scripts are stored under:

```
databricks_medallion_sql/src/governance/
```

These scripts can be applied manually or automated as part of future platform governance workflows.