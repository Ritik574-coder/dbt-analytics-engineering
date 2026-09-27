
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_inventory_stock__dbt_tmp__dbt_tmp_vw" AS WITH inventory as 
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
FROM "RetailDB"."bronze"."stg_inventory"
)
SELECT 
    inventory_snapshot_sk,
    stock_on_hand,
    stock_reserved,
    stock_on_hand - stock_reserved AS  stock_available,
    reorder_level
FROM inventory;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_inventory_stock__dbt_tmp" FROM "RetailDB"."bronze"."int_inventory_stock__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_inventory_stock__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_inventory_stock__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_inventory_stock__dbt_tmp')
    )
    DROP index "bronze"."int_inventory_stock__dbt_tmp".bronze_int_inventory_stock__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_inventory_stock__dbt_tmp_cci
    ON "bronze"."int_inventory_stock__dbt_tmp"

   


  