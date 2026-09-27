
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_inventory_product__dbt_tmp__dbt_tmp_vw" AS SELECT 
    inventory_snapshot_sk,




    CASE
        WHEN TRIM(snapshot_date) LIKE ''[A-Z][a-z][a-z][a-z]% __, ____''
            THEN TRY_CONVERT(DATE, TRIM(snapshot_date))

        WHEN TRIM(snapshot_date) LIKE ''[A-Z][a-z][a-z] __, ____''
            THEN TRY_CONVERT(DATE, TRIM(snapshot_date))

        WHEN TRIM(snapshot_date) LIKE ''__-__-____''
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(snapshot_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(snapshot_date), 110)

        WHEN TRIM(snapshot_date) LIKE ''__-__-____''
            AND TRY_CONVERT(INT, LEFT(TRIM(snapshot_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(snapshot_date), 105)

        WHEN TRIM(snapshot_date) LIKE ''____-__-__''
            THEN TRY_CONVERT(DATE, TRIM(snapshot_date))

        WHEN TRIM(snapshot_date) LIKE ''____/__/__''
            THEN TRY_CONVERT(DATE, TRIM(snapshot_date))

        WHEN TRIM(snapshot_date) LIKE ''__/__/____''
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(snapshot_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(snapshot_date), 101)

        WHEN TRIM(snapshot_date) LIKE ''__/__/____''
            AND TRY_CONVERT(INT, LEFT(TRIM(snapshot_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(snapshot_date), 103)

        ELSE TRY_CONVERT(DATE, TRIM(snapshot_date), 101)

    END

 as snapshot_date,

    CASE 
        WHEN TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, product_id)
    END  as product_id,

    CASE 
        WHEN product_name IS NULL OR product_name = '''' THEN ''Unknown''
        ELSE TRIM(product_name)
    END as product_name,

    CASE 
        WHEN sku IS NULL OR sku = '''' THEN ''Unknown''
        ELSE TRIM(sku)
    END as sku,

    CASE 
        WHEN 
    LOWER(TRIM(category))
 = ''electronics'' THEN ''Electronics''
        WHEN 
    LOWER(TRIM(category))
 = ''clothing''    THEN ''Clothing''
        WHEN 
    LOWER(TRIM(category))
 = ''kitchen''     THEN ''Kitchen''
        WHEN 
    LOWER(TRIM(category))
 = ''office''      THEN ''Office''
        WHEN 
    LOWER(TRIM(category))
 = ''sports''      THEN ''Sports''
        WHEN 
    LOWER(TRIM(category))
 = ''health''      THEN ''Health''
        WHEN 
    LOWER(TRIM(category))
 = ''beauty''      THEN ''Beauty''
        WHEN 
    LOWER(TRIM(category))
 = ''footwear''    THEN ''Footwear''
        WHEN 
    LOWER(TRIM(category))
 = ''toys''        THEN ''Toys''
        WHEN 
    LOWER(TRIM(category))
 = ''bags''        THEN ''Bags''
        ELSE ''Unknown''
    END AS category
FROM "RetailDB"."bronze"."stg_inventory" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_inventory_product__dbt_tmp" FROM "RetailDB"."bronze"."int_inventory_product__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_inventory_product__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_inventory_product__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_inventory_product__dbt_tmp')
    )
    DROP index "bronze"."int_inventory_product__dbt_tmp".bronze_int_inventory_product__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_inventory_product__dbt_tmp_cci
    ON "bronze"."int_inventory_product__dbt_tmp"

   


  