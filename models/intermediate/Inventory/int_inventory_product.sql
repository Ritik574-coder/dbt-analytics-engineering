SELECT 
    inventory_snapshot_sk,
    snapshot_date,
    product_id,
    product_name,
    sku,
    category
FROM {{ ref('stg_inventory') }} ;