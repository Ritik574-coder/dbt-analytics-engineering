
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_product_inventory__dbt_tmp__dbt_tmp_vw" AS SELECT 
    product_id,
    
    CASE
        WHEN 
    LOWER(TRIM(is_available))
 IN (''a'',''y'',''ye'',''1'',''t'',''tr'',''in'',''i'') THEN ''Available''
        WHEN 
    LOWER(TRIM(is_available))
 IN (''n'',''no'',''o'',''ou'') THEN ''Not Available''
        WHEN 
    LOWER(TRIM(is_available))
 IN (''d'',''di'') THEN ''Discontinued''
        ELSE ''Unknown''
    END AS is_available,

    CASE 
        WHEN stock_quantity IS NULL OR TRY_CONVERT(INT , stock_quantity) IS NULL OR TRY_CONVERT(INT , stock_quantity) < 0 THEN NULL
        ELSE TRY_CONVERT(INT , stock_quantity)
    END AS stock_quantity,

    CASE 
        WHEN reorder_level IS NULL OR TRY_CONVERT(INT , reorder_level) IS NULL OR TRY_CONVERT(INT , reorder_level) < 0 THEN NULL
        ELSE TRY_CONVERT(INT , reorder_level)
    END AS reorder_level
FROM "RetailDB"."bronze"."stg_products" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_product_inventory__dbt_tmp" FROM "RetailDB"."bronze"."int_product_inventory__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_product_inventory__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_product_inventory__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_product_inventory__dbt_tmp')
    )
    DROP index "bronze"."int_product_inventory__dbt_tmp".bronze_int_product_inventory__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_product_inventory__dbt_tmp_cci
    ON "bronze"."int_product_inventory__dbt_tmp"

   


  