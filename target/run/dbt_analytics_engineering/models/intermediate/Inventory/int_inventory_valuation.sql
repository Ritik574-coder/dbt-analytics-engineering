
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_inventory_valuation__dbt_tmp__dbt_tmp_vw" AS WITH inventory_valuation AS 
(
    SELECT 
        inventory_snapshot_sk,
        CASE 
            WHEN unit_cost LIKE ''$%'' THEN TRY_CONVERT(DECIMAL(10, 2), SUBSTRING(unit_cost, 2, LEN(unit_cost)))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_cost)
        END as unit_cost,

        CASE 
            WHEN TRY_CONVERT(DECIMAL(10,2), unit_price) IS NULL THEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_price, '','', ''''), ''$'', ''''))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_price)
        END as unit_price,

        CASE 
            WHEN TRY_CONVERT(INT, stock_on_hand) IS NULL OR stock_on_hand < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, stock_on_hand)
        END AS stock_on_hand,

        CASE 
            WHEN warehouse_location IS NULL OR warehouse_location = '''' THEN ''Unknown''
            ELSE UPPER(warehouse_location)
        END as warehouse_location,

        CASE 
            WHEN store_id IS NULL OR store_id = '''' THEN NULL
            ELSE TRY_CONVERT(INT, store_id)
        END as store_id 

    FROM "RetailDB"."bronze"."stg_inventory"
)
SELECT 
    inventory_snapshot_sk,
    unit_cost,
    unit_price,
    unit_price * stock_on_hand as inventory_value,
    warehouse_location,
    store_id
FROM inventory_valuation;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_inventory_valuation__dbt_tmp" FROM "RetailDB"."bronze"."int_inventory_valuation__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_inventory_valuation__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_inventory_valuation__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_inventory_valuation__dbt_tmp')
    )
    DROP index "bronze"."int_inventory_valuation__dbt_tmp".bronze_int_inventory_valuation__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_inventory_valuation__dbt_tmp_cci
    ON "bronze"."int_inventory_valuation__dbt_tmp"

   


  