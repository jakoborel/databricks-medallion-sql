# Databricks Medallion SQL Pipeline

A SQL-only medallion architecture and CI/CD pipeline implemented in Databricks using:

- Databricks Asset Bundles (DAB)
- Serverless SQL Warehouse
- Github Actions CI/CD
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

Each task runs as a SQL task against a Serverless SQL Warehouse. The same job definition is deployed to each environment with environment-specific parameters.

## CI/CD Pipeline

This project uses **GitHub Actions with Databricks Asset Bundles** to implement a promotion-based deployment workflow.

### Pipeline Flow

```
Pull Request
      ↓
CI Validation
(bundle validate + plan)
      ↓
Merge to main
      ↓
Deploy to DEV
      ↓
Manual Promotion
      ↓
Deploy to UAT
      ↓
Automatic Trigger
      ↓
Deploy to PROD (approval required)
```

### Workflow Details

#### CI (Pull Requests)
Runs validation checks before code can be merged:

- `databricks bundle validate`
- `databricks bundle plan`

#### Automatic Dev Deployment

When code is merged to `main`:

```
databricks bundle deploy -t dev
```

This keeps the development environment continuously updated.

#### UAT Promotion

Deployment to UAT is manually triggered via GitHub Actions:

```
databricks bundle deploy -t uat
```

#### Production Promotion

Production deployment is automatically triggered **only after a successful UAT deployment**, ensuring that code cannot skip environments.

The `prod` environment is protected by GitHub environment approval rules.

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

## Deployment Model

Databricks Asset Bundles deploy resources to environment-specific workspace paths:

```
/Workspace/Users/<user>/.bundle/...   (development mode)
/Workspace/Shared/...                 (production mode)
```

## Production Hardening Roadmap
Planned enhancements to evolve this project toward a production-grade data platform:

### Data Engineering Improvements
- Incremental bronze ingestion (append-only / backfill-safe loads)
- MERGE-based upserts in silver to support late-arriving updates
- Data quality validation layer (constraints / expectations)
### CI/CD Improvements
- Automated job smoke tests after deployment
- Deployment summary output in CI logs
- Data validation checks during CI
### Governance Enhancements
- Row-level security (RLS)
- Column masking for sensitive fields
- Gold layer-only access patterns
### Data Access Patterns
- Secure data access APIs
- Service-to-service authentication
- Rate limiting and audit logging
- Least-privilege dataset access
### Downstream Consumption
- Separate repositories for dashboards / BI
- Gold-layer datasets treated as stable contracts for external consumers