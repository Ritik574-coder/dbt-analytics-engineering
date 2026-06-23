WITH inventory_valuation AS 
(
    SELECT 
        inventory_snapshot_sk,
        CASE 
            WHEN unit_cost LIKE '$%' THEN TRY_CONVERT(DECIMAL(10, 2), SUBSTRING(unit_cost, 2, LEN(unit_cost)))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_cost)
        END as unit_cost,

        CASE 
            WHEN TRY_CONVERT(DECIMAL(10,2), unit_price) IS NULL THEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_price, ',', ''), '$', ''))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_price)
        END as unit_price,

        CASE 
            WHEN TRY_CONVERT(INT, stock_on_hand) IS NULL OR stock_on_hand < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, stock_on_hand)
        END AS stock_on_hand,

        CASE 
            WHEN warehouse_location IS NULL OR warehouse_location = '' THEN 'Unknown'
            ELSE UPPER(warehouse_location)
        END as warehouse_location,

        CASE 
            WHEN store_id IS NULL OR store_id = '' THEN NULL
            ELSE TRY_CONVERT(INT, store_id)
        END as store_id 

    FROM {{ ref('stg_inventory') }}
)
SELECT 
    inventory_snapshot_sk,
    unit_cost,
    unit_price,
    unit_price * stock_on_hand as inventory_value,
    warehouse_location,
    store_id
FROM inventory_valuation;