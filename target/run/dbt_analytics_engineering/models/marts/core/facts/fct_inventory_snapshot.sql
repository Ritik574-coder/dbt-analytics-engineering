
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."fct_inventory_snapshot__dbt_tmp__dbt_tmp_vw" AS SELECT
    p.inventory_snapshot_sk,
    p.snapshot_date,
    p.product_id,
    v.store_id,
    p.sku,
    p.product_name,
    p.category,
    s.stock_on_hand,
    s.stock_reserved,
    s.stock_available,
    s.reorder_level,
    v.unit_cost,
    v.unit_price,
    v.inventory_value,
    v.warehouse_location,
    CASE
        WHEN s.stock_available IS NULL OR s.reorder_level IS NULL THEN ''Unknown''
        WHEN s.stock_available <= s.reorder_level THEN ''Yes''
        ELSE ''No''
    END AS is_reorder_needed
FROM "RetailDB"."bronze"."int_inventory_product" AS p
LEFT JOIN "RetailDB"."bronze"."int_inventory_stock" AS s
    ON p.inventory_snapshot_sk = s.inventory_snapshot_sk
LEFT JOIN "RetailDB"."bronze"."int_inventory_valuation" AS v
    ON p.inventory_snapshot_sk = v.inventory_snapshot_sk
WHERE p.inventory_snapshot_sk IS NOT NULL;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."fct_inventory_snapshot__dbt_tmp" FROM "RetailDB"."bronze"."fct_inventory_snapshot__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."fct_inventory_snapshot__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_fct_inventory_snapshot__dbt_tmp_cci'
        AND object_id=object_id('bronze_fct_inventory_snapshot__dbt_tmp')
    )
    DROP index "bronze"."fct_inventory_snapshot__dbt_tmp".bronze_fct_inventory_snapshot__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_fct_inventory_snapshot__dbt_tmp_cci
    ON "bronze"."fct_inventory_snapshot__dbt_tmp"

   


  