```
retail_analytics/
│
├── .github/                  # GitHub CI/CD and workflows
│   └── workflows/
│       ├── dbt_test.yml      # Run tests on PRs
│       ├── dbt_deploy.yml    # Deploy to production
│       └── dbt_docs.yml      # Generate and deploy docs
│
├── dbt_project.yml           # Core dbt configuration
├── packages.yml              # dbt packages (e.g., dbt_utils, dbt_expectations)
├── profiles.yml              # Database connection profiles
│
├── models/                   # All dbt models
│   ├── staging/               # Bronze Layer: Raw → Cleaned
│   │   ├── _retail__sources.yml  # Source definitions
│   │   ├── _retail__models.yml   # Staging model configs
│   │   ├── customers/
│   │   │   └── stg_customers.sql
│   │   ├── sales/
│   │   │   └── stg_sales.sql
│   │   ├── products/
│   │   │   └── stg_products.sql
│   │   ├── inventory/
│   │   │   └── stg_inventory.sql
│   │   ├── marketing/
│   │   │   └── stg_marketing.sql
│   │   ├── finance/
│   │   │   └── stg_finance.sql
│   │   ├── fulfillment/
│   │   │   └── stg_fulfillment.sql
│   │   └── returns/
│   │       └── stg_returns.sql
│   │
│   ├── intermediate/          # Silver Layer: Business Logic
│   │   ├── _int__models.yml   # Intermediate model configs
│   │   ├── customers/
│   │   │   └── int_customer_lifetime.sql
│   │   ├── sales/
│   │   │   ├── int_sales_aggregates.sql
│   │   │   └── int_sales_by_product.sql
│   │   ├── products/
│   │   │   └── int_product_performance.sql
│   │   ├── inventory/
│   │   │   └── int_inventory_turnover.sql
│   │   ├── marketing/
│   │   │   └── int_marketing_attribution.sql
│   │   ├── finance/
│   │   │   └── int_revenue_recognition.sql
│   │   └── returns/
│   │       └── int_returns_analysis.sql
│   │
│   └── marts/                  # Gold Layer: Star Schema
│       ├── core/               # Shared dimensions
│       │   ├── _marts__models.yml
│       │   ├── dim_customers.sql
│       │   ├── dim_products.sql
│       │   ├── dim_date.sql
│       │   ├── dim_stores.sql
│       │   └── dim_promotions.sql
│       │
│       ├── sales/              # Sales domain
│       │   ├── fct_sales.sql
│       │   ├── fct_sales_returns.sql
│       │   └── _sales__models.yml
│       │
│       ├── inventory/          # Inventory domain
│       │   ├── fct_inventory.sql
│       │   └── fct_stock_movements.sql
│       │
│       ├── marketing/          # Marketing domain
│       │   ├── fct_marketing_spend.sql
│       │   └── fct_campaign_performance.sql
│       │
│       └── finance/            # Finance domain
│           ├── fct_revenue.sql
│           └── fct_costs.sql
│
├── snapshots/                 # SCD Type 2 tables
│   ├── _snapshots__models.yml
│   ├── scd_customers.sql
│   ├── scd_products.sql
│   └── scd_inventory.sql
│
├── seeds/                     # Static reference data
│   ├── country_codes.csv
│   ├── product_categories.csv
│   ├── store_locations.csv
│   ├── promotion_types.csv
│   └── return_reasons.csv
│
├── macros/                    # Reusable SQL logic
│   ├── utils/
│   │   ├── surrogate_key.sql
│   │   ├── date_spine.sql
│   │   ├── schema_change_alert.sql
│   │   └── index_creator.sql
│   │
│   ├── custom_tests/
│   │   ├── test_order_totals.sql
│   │   ├── test_customer_lifetime_value.sql
│   │   └── test_inventory_balance.sql
│   │
│   └── dbt_utils_override.sql  # Custom macros to override dbt_utils
│
├── tests/                     # Data quality tests
│   ├── schema/                # Generic tests
│   │   ├── not_null.yml
│   │   ├── unique.yml
│   │   ├── accepted_values.yml
│   │   └── relationships.yml
│   │
│   └── custom/                # Singular tests
│       ├── test_sales_amount_positive.sql
│       ├── test_inventory_non_negative.sql
│       └── test_customer_email_format.sql
│
├── analyses/                  # Ad-hoc analysis and validations
│   ├── customer_analysis/
│   │   ├── customer_segmentation.sql
│   │   └── customer_retention.sql
│   │
│   ├── sales_analysis/
│   │   ├── sales_trends.sql
│   │   └── sales_by_region.sql
│   │
│   └── inventory_analysis/
│       ├── stockout_analysis.sql
│       └── turnover_ratio.sql
│
├── docs/                      # Documentation
│   ├── README.md              # Project overview, setup, and usage
│   ├── architecture.md        # High-level architecture and design decisions
│   ├── data_model.md          # Data model documentation
│   ├── lineage.md             # Mermaid diagrams for lineage
│   └── best_practices.md      # Team guidelines and best practices
│
├── data/                      # Local data for testing (optional)
│   ├── raw/
│   │   ├── customers.csv
│   │   ├── sales.csv
│   │   └── products.csv
│   │
│   └── processed/             # Processed data (optional)
│
└── scripts/                   # Helper scripts
    ├── generate_docs.py       # Script to auto-generate docs
    ├── data_quality_check.py  # Custom data quality scripts
    └── setup_local_db.sh      # Script to set up a local SQL Server instance

```