SELECT 
    inventory_snapshot_sk,
    product_id,
    stock_on_hand,
    stock_reserved,
    stock_available,
    reorder_level
FROM {{ ref('stg_inventory') }} ;