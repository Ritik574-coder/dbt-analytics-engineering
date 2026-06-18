SELECT 
    snapshot_date,
    product_id,
    product_name,
    sku,
    category
FROM {{ ref('stg_inventory') }} ;