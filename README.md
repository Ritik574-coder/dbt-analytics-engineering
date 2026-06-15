# dbt Analytics Engineering

A learning-focused **dbt + SQL Server** project for retail analytics. The goal is to practice advanced dbt patterns—layered modeling, testing, documentation, snapshots, and CI/CD—in a realistic data engineering workflow.

## Tech stack

| Component | Version |
|-----------|---------|
| dbt-core | 1.11.11 |
| dbt-sqlserver | 1.10.0 |
| SQL Server | 2022 (Docker) |
| Python | 3.11+ |

## Project structure

```
dbt-analytics-engineering/
├── .github/
│   ├── profiles/profiles.yml   # CI profile (no secrets)
│   └── workflows/
│       ├── dbt-ci.yml          # Lint, parse, compile, run, test
│       ├── dbt-cd.yml          # Deploy to prod (secrets required)
│       └── dbt-docs.yml        # Generate & publish documentation
├── models/
│   ├── staging/                # Bronze: source cleaning & standardization
│   ├── intermediate/             # Silver: business logic & joins
│   └── marts/                    # Gold: analytics-ready facts & dimensions
├── macros/                       # Reusable SQL logic
├── seeds/                        # Static reference data (CSV)
├── snapshots/                    # SCD Type 2 history
├── tests/                        # Singular & schema tests
├── analyses/                     # Ad-hoc exploratory queries
├── scripts/                      # Setup & CI helper scripts
├── dbt_project.yml
├── packages.yml
├── profiles.example.yml          # Local profile template
├── requirements.txt
└── docker-compose.yml            # Local SQL Server
```

See [technical_design_document.md](technical_design_document.md) for architecture, layering strategy, and modeling decisions.

## Quick start

### 1. Prerequisites

- Python 3.11+
- Docker & Docker Compose
- [ODBC Driver 18 for SQL Server](https://learn.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server)

### 2. Clone and configure

```bash
git clone https://github.com/<your-org>/dbt-analytics-engineering.git
cd dbt-analytics-engineering

python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

cp .env.example .env
cp profiles.example.yml ~/.dbt/profiles.yml
# Edit ~/.dbt/profiles.yml or export DBT_SQLSERVER_* variables from .env
```

### 3. Start SQL Server

```bash
docker compose up -d
docker compose ps   # wait until healthy
```

### 4. Run dbt

```bash
dbt deps
dbt debug
dbt run
dbt test
dbt docs generate && dbt docs serve
```

For a guided local setup, see [scripts/setup-local-dev.sh](scripts/setup-local-dev.sh).  
For a full command reference (Docker, Git, Superset, dbt), see [env_setup_command.sh](env_setup_command.sh).

## CI/CD

### Pull requests (`dbt-ci.yml`)

Every PR to `main` runs:

1. **Lint & parse** — YAML validation, `dbt deps`, `dbt parse`, SQLFluff (when models exist)
2. **Integration** — SQL Server container, `dbt debug`, `compile`, `run`, `test`

### Deployment (`dbt-cd.yml`)

Triggered on push to `main` (model/macro changes) or manually via **Actions → dbt CD**.

Configure these GitHub repository secrets before enabling CD:

| Secret | Description |
|--------|-------------|
| `DBT_SQLSERVER_HOST` | Warehouse host |
| `DBT_SQLSERVER_PORT` | Port (default `1433`) |
| `DBT_SQLSERVER_DATABASE` | Target database |
| `DBT_SQLSERVER_SCHEMA` | Target schema |
| `DBT_SQLSERVER_USER` | Login user |
| `DBT_SQLSERVER_PASSWORD` | Login password |

### Documentation (`dbt-docs.yml`)

Generates dbt docs on every PR/push. On `main`, publishes to **GitHub Pages** (enable Pages with source = GitHub Actions in repo settings).

## Layer conventions

| Layer | Prefix | Materialization | Purpose |
|-------|--------|-----------------|---------|
| Staging | `stg_` | table | Clean & rename raw sources |
| Intermediate | `int_` | table | Business logic & aggregations |
| Marts | `fct_`, `dim_` | view | Star schema for BI |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Please open issues or PRs for improvements.

## License

[MIT](LICENSE)
