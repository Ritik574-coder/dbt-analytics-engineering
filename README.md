# 🛒 Retail Analytics Engineering Platform

![dbt Core](https://img.shields.io/badge/dbt--Core-1.11.11-FF694B?style=flat&logo=dbt&logoColor=white)
![dbt-sqlserver](https://img.shields.io/badge/dbt--sqlserver-1.10.0-CC292B?style=flat&logo=microsoftsqlserver&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL_Server-2022-CC292B?style=flat&logo=microsoftsqlserver&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=flat&logo=python&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?style=flat&logo=docker&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

An end-to-end, enterprise-grade **Analytics Engineering Platform** leveraging **dbt (data build tool)** and **Microsoft SQL Server 2022**. This project models a multi-domain retail business ecosystem—covering **Customers, Transactions, Products, Employees, Stores, Inventory, Returns, and Reviews**—following industry-standard Medallion Architecture (Bronze → Silver → Gold) and Kimball Dimensional Modeling best practices.

---

## 🏗️ High-Level Architecture & Pipeline

The platform ingests raw operational data (CSV files loaded into SQL Server), applies automated data cleaning, enforces strict schema & business logic validations, and structures data into analytical Star Schema models optimized for BI platforms (Power BI, Tableau, Superset) and executive dashboards.

![dbt Medallion Architecture](https://img.shields.io/badge/Architecture-Medallion%20(Bronze%20%E2%86%92%20Silver%20%E2%86%92%20Gold)-orange?style=for-the-badge&logo=dbt)

### Medallion Architecture Breakdown

```
 ┌─────────────────────────┐      ┌─────────────────────────┐      ┌─────────────────────────┐
 │   BRONZE (Staging)      │      │   SILVER (Intermediate) │      │      GOLD (Marts)       │
 │   `stg_*` (Views)       ├─────►│   `int_*` (Tables)      ├─────►│   `dim_*` / `fct_*`     │
 │  Source Cleaning &      │      │   Business Logic &      │      │   Star Schema for BI &  │
 │  Standardization        │      │   Domain Aggregations   │      │   Analytical Reporting  │
 └─────────────────────────┘      └─────────────────────────┘      └─────────────────────────┘
```

```
┌───────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                           DATA PIPELINE DAG                                           │
├─────────────────────────────────┬──────────────────────────────────┬──────────────────────────────────┤
│ BRONZE LAYER (Staging)          │ SILVER LAYER (Intermediate)      │ GOLD LAYER (Marts)               │
├─────────────────────────────────┼──────────────────────────────────┼──────────────────────────────────┤
│ stg_customers                   │ int_customer_location            │ dim_customers                    │
│                                 │ int_customer_profile             │                                  │
│                                 │ int_customer_segmentation        │                                  │
│                                 │ int_customers_contact            │                                  │
├─────────────────────────────────┼──────────────────────────────────┼──────────────────────────────────┤
│ stg_transactions                │ int_transaction_financial        │ fct_transactions (Planned)       │
│                                 │ int_transaction_fulfillment      │                                  │
│                                 │ int_transaction_order            │                                  │
│                                 │ int_transaction_status           │                                  │
├─────────────────────────────────┼──────────────────────────────────┼──────────────────────────────────┤
│ stg_products                    │ Product aggregations & logic     │ dim_products                     │
│ stg_employees                   │ Employee hierarchy & logic       │ dim_employees                    │
│ stg_stores                      │ Store performance & mapping      │ dim_stores                       │
│ stg_inventory                   │ Stock movement aggregations      │ dim_inventory                    │
│ stg_returns                     │ Return reconciliation            │ fct_returns (Planned)            │
│ stg_reviews                     │ Review sentiment & metrics       │ fct_reviews (Planned)            │
└─────────────────────────────────┴──────────────────────────────────┴──────────────────────────────────┘
```

---

## 🛠️ Tech Stack & Key Components

| Component | Technology | Version | Description |
|-----------|------------|---------|-------------|
| **Transformation Engine** | `dbt-core` | `1.11.11` | Core dbt framework for modular SQL models |
| **Database Adapter** | `dbt-sqlserver` | `1.10.0` | Microsoft SQL Server adapter plugin for dbt |
| **Database Engine** | MS SQL Server 2022 | `2022-latest` | Containerized relational OLAP/OLTP engine |
| **Language Runtime** | Python | `3.11+` | CLI tools, package manager, and orchestration scripts |
| **Containerization** | Docker & Compose | `v2+` | Environment isolated local SQL Server container |
| **CI/CD Orchestration** | GitHub Actions | Workflows | Automated testing, linting, parsing & deployment |

---

## 📂 Project Structure

```
dbt-analytics-engineering/
├── .github/
│   ├── profiles/
│   │   └── profiles.yml           # CI dbt profile configuration
│   └── workflows/
│       ├── dbt-ci.yml             # Pull Request validation (Lint, compile, run, test)
│       ├── dbt-cd.yml             # CD deployment pipeline to production warehouse
│       └── dbt-docs.yml           # Automated dbt documentation site publishing
├── models/
│   ├── staging/                   # Bronze Layer (Raw cleaning, renaming, defensive casts)
│   │   ├── Customers/             # stg_customers.sql
│   │   ├── Employees/             # stg_employees.sql
│   │   ├── Inventory/             # stg_inventory.sql
│   │   ├── Products/              # stg_products.sql
│   │   ├── Returns/               # stg_returns.sql
│   │   ├── Reviews/               # stg_reviews.sql
│   │   ├── Stores/                # stg_stores.sql
│   │   ├── Transactions/          # stg_transactions.sql
│   │   ├── _stg__retail__models.yml   # Staging model definitions, descriptions & tests
│   │   └── _stg__retail__sources.yml  # Raw source metadata definitions
│   │
│   ├── intermediate/              # Silver Layer (Business logic, joins, aggregations)
│   │   ├── Customers/             # int_customer_location, profile, segmentation, contact
│   │   ├── Transactions/          # int_transaction_financial, fulfillment, order, status
│   │   ├── Employees/
│   │   ├── Inventory/
│   │   ├── Products/
│   │   ├── Returns/
│   │   ├── Reviews/
│   │   └── Stores/
│   │
│   └── marts/                     # Gold Layer (Dimensional Kimball Star Schema)
│       └── core/
│           └── dimensions/        # Conformed Dimensions (dim_customers, dim_products, etc.)
│               ├── dim_customers.sql
│               ├── dim_employees.sql
│               ├── dim_inventory.sql
│               ├── dim_products.sql
│               ├── dim_stores.sql
│               └── _dim_models.yml
│
├── macros/                        # Reusable Jinja/SQL macro utilities
│   ├── standardize_date.sql      # Multi-format pattern-aware date parser
│   ├── standardize_phone.sql     # US phone format standardizer +1 (AAA) BBB-CCCC
│   └── trim_lower.sql            # String trimming & lowercase normalization
│
├── snapshots/                     # SCD Type 2 tracking
│   └── inventory_snapshot.sql    # Historical inventory snapshot tracking
│
├── seeds/                         # Static reference data (CSVs)
├── tests/                         # Data Quality Tests (Singular & Generic)
├── analyses/                      # Ad-hoc exploratory SQL queries
├── scripts/                       # Database initialization & local dev helpers
│   ├── setup-local-dev.sh        # Automated local setup script
│   ├── wait_for_sqlserver.sh     # Health check wrapper script
│   └── ci-init-db.sql            # Initial schema setup script for SQL Server
│
├── dbt_project.yml                # Core dbt project settings & materialization rules
├── packages.yml                   # Dependencies (dbt_utils, dbt_expectations, etc.)
├── profiles.example.yml           # Connection profile template
├── docker-compose.yml             # Dockerized SQL Server setup
├── requirements.txt               # Python package dependencies
├── technical_design_document.md   # Architectural design document (ADD)
└── README.md                      # Project documentation
```

---

## 🎯 Data Modeling & Layering Strategy

### 1. 🥉 Staging Layer (Bronze)
- **Materialization**: `view` (tags: `["staging", "bronze"]`)
- **Naming Convention**: `stg_<entity>`
- **Objective**: Clean raw source attributes without altering core business definitions.
- **Operations**:
  - Standardizing column casing (`snake_case`).
  - Trimming leading/trailing whitespace.
  - Applying multi-format date parsing (`ISO 8601 YYYY-MM-DD`).
  - Formatting phone numbers into canonical U.S. formats (`+1 (AAA) BBB-CCCC`).
  - Defensive type-casting and handling missing or malformed values.

### 2. 🥈 Intermediate Layer (Silver)
- **Materialization**: `table` (tags: `["intermediate", "silver"]`)
- **Naming Convention**: `int_<domain>_<entity>`
- **Objective**: Implement domain business logic, complex joins, and reusable transformations.
- **Domains Covered**:
  - **Customers**: Profile aggregation, contact info cleaning, geography/location standardization, customer segmentation rules (Bronze/Silver/Gold/Platinum).
  - **Transactions**: Order line handling, financial calculation reconciliations (tax, discounts, line totals), status mapping, fulfillment metrics.
  - **Inventory, Products, Stores, Employees**: Cross-entity mapping, tenure/compensation standardization.

### 3. 🥇 Marts Layer (Gold)
- **Materialization**: `table` (tags: `["marts", "gold"]`)
- **Naming Convention**: `dim_<entity>` / `fct_<entity>`
- **Objective**: Expose analytics-ready Star Schema facts and dimensions optimized for BI consumption.
- **Core Models**:
  - `dim_customers`: Unified conformed customer dimension.
  - `dim_products`: Comprehensive product catalog dimension.
  - `dim_stores`: Retail store location and formatting dimension.
  - `dim_employees`: Staff organizational hierarchy dimension.
  - `dim_inventory`: Current stock levels and snapshot metrics.

### 4. 🕰️ Snapshots (SCD Type 2)
- **Strategy**: Capturing historical state changes over time using dbt snapshots (`snapshots/inventory_snapshot.sql`). Allows historical tracking of stock quantity variations and inventory valuation over time.

---

## ⚙️ Custom Macros & Data Quality Governance

### Custom Utility Macros

- **`standardize_date(column_name)`**: Handles mixed date formats (e.g., `YYYY-MM-DD`, `MM/DD/YYYY`, `DD-MM-YYYY`, text month names) using conditional SQL Server `TRY_CONVERT` logic.
- **`standardize_phone(column_name)`**: Normalizes phone strings into standard US format `+1 (AAA) BBB-CCCC` using regex pattern parsing and string manipulation.
- **`trim_lower(column_name)`**: Strips whitespace and forces string fields to lowercase for predictable key joins and comparisons.

### Data Quality & Testing Framework

Data quality is enforced at every layer using generic and custom singular tests:
- **Primary & Foreign Key Integrity**: `unique` and `not_null` constraints on all primary identifiers (`customer_id`, `transaction_id`, `product_id`, `employee_id`, `store_id`).
- **Domain Validations**: Accepted values testing for active flags, gender categories, and status codes.
- **Financial Validation**: Non-negative checks on prices, salaries, quantities, and line item totals.

---

## 🚀 Quick Start Guide

### 1. Prerequisites
- **Python 3.11+** installed.
- **Docker & Docker Compose** installed and running.
- **ODBC Driver 18 for SQL Server** installed on your operating system.

### 2. Setup Virtual Environment & Install Dependencies

```bash
# Clone repository
git clone https://github.com/<your-org>/dbt-analytics-engineering.git
cd dbt-analytics-engineering

# Create and activate Python virtual environment
python3 -m venv .venv
source .venv/bin/activate    # On Windows: .venv\Scripts\activate

# Install requirements
pip install -r requirements.txt
```

### 3. Configure Database Credentials

Copy the example environment file and connection profile:

```bash
cp .env.example .env
mkdir -p ~/.dbt
cp profiles.example.yml ~/.dbt/profiles.yml
```

Edit `~/.dbt/profiles.yml` or set environment variables in your `.env`:
```yaml
dbt_analytics_engineering:
  target: dev
  outputs:
    dev:
      type: sqlserver
      driver: 'ODBC Driver 18 for SQL Server'
      server: localhost
      port: 1433
      database: dbt_db
      schema: dbo
      user: sa
      password: 'YourStrong!Password123'
      trust_cert: true
```

### 4. Start Local SQL Server (Docker Container)

```bash
docker compose up -d
docker compose ps   # Verify container is healthy
```

### 5. Execute dbt Pipeline

```bash
# Install external package dependencies (dbt_utils, etc.)
dbt deps

# Verify connection to SQL Server database
dbt debug

# Compile models
dbt compile

# Run transformations across all layers
dbt run

# Execute data quality tests
dbt test

# Generate and serve interactive dbt documentation & lineage DAG
dbt docs generate
dbt docs serve
```

---

## 🔄 CI/CD Automation & GitHub Actions

The repository includes enterprise CI/CD workflows under `.github/workflows/`:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            GITHUB ACTIONS WORKFLOWS                         │
├───────────────────┬─────────────────────────────────────────────────────────┤
│ `dbt-ci.yml`      │ Runs on every Pull Request to `main`.                   │
│                   │ 1. Lints SQL and validates project parsing (`dbt parse`)│
│                   │ 2. Spins up an ephemeral SQL Server Docker container    │
│                   │ 3. Executes `dbt run` and `dbt test`                    │
├───────────────────┼─────────────────────────────────────────────────────────┤
│ `dbt-cd.yml`      │ Triggered on pushes to `main`. Deploys updated models   │
│                   │ and snapshots directly to the production warehouse.     │
├───────────────────┼─────────────────────────────────────────────────────────┤
│ `dbt-docs.yml`    │ Automatically compiles and deploys static dbt Docs &    │
│                   │ DAG Lineage visualizer to GitHub Pages.                 │
└───────────────────┴─────────────────────────────────────────────────────────┘
```

---

## 🤝 Contributing

We welcome contributions! Please adhere to the following workflow:
1. Fork the repository and create your feature branch (`git checkout -b feature/amazing-feature`).
2. Follow SQL naming conventions (`snake_case`) and model structure guidance.
3. Ensure all tests (`dbt test`) pass before opening a PR.
4. Review [CONTRIBUTING.md](CONTRIBUTING.md) for full submission guidelines.

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<p center="center">
  <b> Developed and Maintained by Ritik </b> • Built with ❤️ using dbt Core & SQL Server
</p>
