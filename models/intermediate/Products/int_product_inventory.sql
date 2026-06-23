SELECT 
    product_id,
    
    CASE
        WHEN LOWER(TRIM(is_available)) IN ('a','y','ye','1','t','tr','in','i') THEN 'Available'
        WHEN LOWER(TRIM(is_available)) IN ('n','no','o','ou') THEN 'Not Available'
        WHEN LOWER(TRIM(is_available)) IN ('d','di') THEN 'Discontinued'
        ELSE 'Unknown'
    END AS is_available,

    CASE 
        WHEN stock_quantity IS NULL OR TRY_CONVERT(INT , stock_quantity) IS NULL OR TRY_CONVERT(INT , stock_quantity) < 0 THEN NULL
        ELSE TRY_CONVERT(INT , stock_quantity)
    END AS stock_quantity,

    CASE 
        WHEN reorder_level IS NULL OR TRY_CONVERT(INT , reorder_level) IS NULL OR TRY_CONVERT(INT , reorder_level) < 0 THEN NULL
        ELSE TRY_CONVERT(INT , reorder_level)
    END AS reorder_level
FROM {{ ref('stg_products') }} ;

