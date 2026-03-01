# Databricks Medallion SQL Pipeline

A SQL-only medallion architecture and CI/CD pipeline implemented in Databricks using:

- Databricks Asset Bundles (DAB)
- Serverless SQL Warehouse
- Environment targets (dev / uat / prod)
- Bronze → Silver → Gold layering
- Git-based source control and deployment 

All transformations are written in SQL and executed as warehouse-backed job tasks.
This project demonstrates how to build a production-style analytics pipeline for stable deployment and tracked changes.

## Architecture

Each environment is isolated by catalog:

- `dev`
- `uat`
- `prod`

Within each catalog:

- `brazil_ecommerce_bronze`
- `brazil_ecommerce_silver`
- `brazil_ecommerce_gold`

### Layers

**Bronze**  
- Raw ingestion from Unity Catalog volumes, no transformation, source-of-truth landing.

**Silver**  
- Cleaned and structured tables. Prepared for analytical use.

**Gold**  
- Aggregated, business-facing views and presentation-ready semantic layer.
All object names are standardized using uppercase table and view names.

## Environment Switching

Environment behavior is controlled via bundle targets and SQL task parameters:

- `CATALOG`
- `{ANY_NECESSARY_FILE_PATHS}`

## Job Structure

Single job:
`BRAZIL_ECOMMERCE_MEDALLION`

Tasks:

- `BRONZE__ORDERS_RAW`
- `SILVER__ORDERS`
- `GOLD__FACT_ORDERS_VW`

Each task runs as a SQL task against a Serverless SQL Warehouse.

## Run Locally

Requires Databricks CLI auth profile
Requires WAREHOUSE_ID, CATALOG, ORDERS_CSV_PATH set in databricks.yml targets

From the bundle directory:

```bash
databricks bundle validate -t dev
databricks bundle deploy -t dev
databricks bundle run BRAZIL_ECOMMERCE_MEDALLION -t dev
```

Switch environments:

`databricks bundle run BRAZIL_ECOMMERCE_MEDALLION -t uat`

Repository Structure
```
databricks_medallion_sql/
│
├── databricks.yml                 # Bundle configuration
├── resources/                     # Job definitions
├── src/                           # SQL source files
│   └── brazil_ecommerce/
│       ├── bronze/
│       ├── silver/
│       └── gold/
├── scratch/                       # Experimental queries (not deployed)
├── docs/                          # Documentation
└── README.md
```

Additional documentation is available in /docs.

## Production Hardening Roadmap
Planned enhancements to evolve this project toward a production-grade data platform:

- Incremental bronze ingestion (append-only / backfill-safe loads)
- MERGE-based upserts in silver to handle late-arriving updates
- Data quality validation layer (constraints / expectations and fail-fast checks)
- CI/CD via GitHub Actions (automated `bundle validate`, deploy, and promotion gates)
- Environment promotion workflow (dev → uat → prod) with approval steps
- Governance hardening:
  - Row-level security (RLS) for audience-specific access
  - Column masking for sensitive fields (e.g., PII)
  - Gold-only exposure patterns for most consumers
- Secure data access API:
  - Service-to-service auth (no user tokens)
  - Read-only access scoped to approved gold datasets
  - Rate limiting, auditing, and least-privilege access
- Downstream consumption separation:
  - Separate repository (or repos) for visualization layers (Dashboards / BI)
  - Treat gold datasets as stable contracts for external consumers