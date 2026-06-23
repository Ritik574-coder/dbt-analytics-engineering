SELECT 
    inventory_snapshot_sk,

    CASE 
        WHEN TRY_CONVERT(INT, stock_on_hand) IS NULL OR stock_on_hand < 0 THEN NULL 
        ELSE TRY_CONVERT(INT, stock_on_hand)
    END AS stock_on_hand,

    CASE 
        WHEN stock_reserved < 0 OR TRY_CONVERT(INT, stock_reserved) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, stock_reserved)
    END  as stock_reserved,

    stock_available,

    CASE 
        WHEN reorder_level IS NULL OR reorder_level < 0 OR TRY_CONVERT(INT, reorder_level) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, reorder_level)
    END as reorder_level
FROM {{ ref('stg_inventory') }} ;