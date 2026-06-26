marts/
├── core/                          # Conformed dimensions and core facts
│   ├── dimensions/                # Shared dimensions (used across multiple facts)
│   │   ├── dim_customers.sql
│   │   ├── dim_products.sql
│   │   ├── dim_stores.sql
│   │   ├── dim_date.sql
│   │   ├── dim_employees.sql
│   │   └── _core__dimensions.yml  # Documentation for all core dimensions
│   │
│   ├── facts/                     # Core fact tables
│   │   ├── fct_transactions.sql
│   │   ├── fct_returns.sql
│   │   ├── fct_reviews.sql
│   │   ├── fct_inventory.sql
│   │   └── _core__facts.yml
│   │
│   └── scd/                       # Slowly Changing Dimensions
│       ├── scd_dim_customers.sql
│       ├── scd_dim_products.sql
│       └── _core__scd.yml
│
├── finance/                       # Finance-specific marts
│   ├── dimensions/
│   │   ├── dim_revenue_categories.sql
│   │   └── _finance__dimensions.yml
│   ├── facts/
│   │   ├── fct_revenue.sql
│   │   ├── fct_costs.sql
│   │   └── _finance__facts.yml
│   └── aggregated/                # Pre-aggregated metrics for dashboards
│       ├── fct_daily_revenue.sql
│       ├── fct_monthly_profitability.sql
│       └── _finance__aggregated.yml
│
├── marketing/                     # Marketing-specific marts
│   ├── dimensions/
│   │   ├── dim_campaigns.sql
│   │   ├── dim_customer_segments.sql
│   │   └── _marketing__dimensions.yml
│   ├── facts/
│   │   ├── fct_customer_acquisition.sql
│   │   ├── fct_campaign_performance.sql
│   │   └── _marketing__facts.yml
│   └── aggregated/
│       ├── fct_customer_lifetime_value.sql
│       └── _marketing__aggregated.yml
│
├── operations/                    # Operations-specific marts
│   ├── dimensions/
│   │   ├── dim_store_performance.sql
│   │   └── _operations__dimensions.yml
│   ├── facts/
│   │   ├── fct_inventory_turnover.sql
│   │   └── _operations__facts.yml
│   └── aggregated/
│       ├── fct_store_performance.sql
│       └── _operations__aggregated.yml
│
└── _marts__sources.yml            # Sources for marts (if needed)