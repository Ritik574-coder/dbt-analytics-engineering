SELECT
    product_id,
    base_price_usd,
    cost_price_usd,
    gross_margin_pct
FROM {{ ref('stg_products') }} ;