SELECT
    customer_id,
    customer_segment,
    loyalty_points,
    annual_income_usd,
    company,
    is_active,
    account_created_date
FROM {{ ref('stg_customers') }} ;