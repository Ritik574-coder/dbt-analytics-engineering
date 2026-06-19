SELECT 
    product_id,
    is_available,
    stock_quantity,
    reorder_level
FROM {{ ref('stg_products') }} ;