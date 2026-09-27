SELECT
    
    lower(convert(varchar(50), hashbytes('md5', coalesce(convert(varchar(8000), concat(coalesce(cast(snapshot_date as VARCHAR(MAX)), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(product_id as VARCHAR(MAX)), '_dbt_utils_surrogate_key_null_'), '-', coalesce(cast(store_id as VARCHAR(MAX)), '_dbt_utils_surrogate_key_null_'))), '')), 2))
 AS inventory_snapshot_sk,

    snapshot_date,
    product_id,
    product_name,
    sku,
    category,
    stock_on_hand,
    stock_reserved,
    stock_available,
    reorder_level,
    unit_cost,
    unit_price,
    inventory_value,
    warehouse_location,
    store_id

FROM "RetailDB"."bronze"."inventory_snapshots";