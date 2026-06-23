WITH inventory as 
(
SELECT 
    inventory_snapshot_sk,

    CASE 
        WHEN TRY_CONVERT(INT, stock_on_hand) IS NULL OR TRY_CONVERT(INT, stock_on_hand) < 0 THEN NULL 
        ELSE TRY_CONVERT(INT, stock_on_hand)
    END AS stock_on_hand,

    CASE 
        WHEN TRY_CONVERT(INT, stock_reserved) < 0 OR TRY_CONVERT(INT, stock_reserved) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, stock_reserved)
    END  as stock_reserved,

    CASE 
        WHEN TRY_CONVERT(INT, reorder_level) IS NULL OR TRY_CONVERT(INT, reorder_level) < 0 THEN NULL 
        ELSE TRY_CONVERT(INT, reorder_level)
    END as reorder_level
FROM {{ ref('stg_inventory') }}
)
SELECT 
    inventory_snapshot_sk,
    stock_on_hand,
    stock_reserved,
    stock_on_hand - stock_reserved AS  stock_available,
    reorder_level
FROM inventory; 