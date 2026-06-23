SELECT
    product_id,
    
    CASE 
        WHEN base_price_usd IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', '')) IS NULL THEN NULL
        WHEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', '')) < 0 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', ''))
    END AS base_price_usd,

    CASE 
        WHEN cost_price_usd IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', '')) IS NULL THEN NULL
        WHEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', '')) < 0 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', ''))
    END AS cost_price_usd,

    CASE 
        WHEN gross_margin_pct IS NULL OR TRY_CONVERT(DECIMAL(5,1), gross_margin_pct) IS NULL THEN NULL
        WHEN TRY_CONVERT(DECIMAL(5,1), gross_margin_pct) > 100 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(5,1), gross_margin_pct)
    END AS gross_margin_pct
FROM {{ ref('stg_products') }} ;


