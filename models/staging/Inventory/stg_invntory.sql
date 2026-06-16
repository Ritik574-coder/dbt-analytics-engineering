SELECT  
     snapshot_date
    ,product_id
    ,product_name
    ,sku
    ,category
    ,stock_on_hand
    ,stock_reserved
    ,stock_available
    ,reorder_level
    ,unit_cost
    ,unit_price
    ,inventory_value
    ,warehouse_location
    ,store_id
FROM {{ source('bronze', 'inventory_snapshots') }} ;
