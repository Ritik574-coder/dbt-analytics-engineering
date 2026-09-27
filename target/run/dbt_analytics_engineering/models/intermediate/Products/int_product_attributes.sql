
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_product_attributes__dbt_tmp__dbt_tmp_vw" AS SELECT
    CASE 
        WHEN TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, product_id)
    END as product_id,

    CASE 
        WHEN TRIM(sku) = '''' OR sku IS NULL OR LEN(TRIM(sku)) != 13 THEN ''Unknown''
        ELSE TRIM(UPPER(sku))
    END as sku,

    CASE 
        WHEN TRIM(product_name) = '''' OR product_name IS NULL THEN ''Unknown''
        ELSE TRIM(dbo.TitleCase(product_name))
    END as product_name,

    CASE 
        WHEN TRIM(brand) = '''' OR brand IS NULL THEN ''Unknown''
        ELSE TRIM(dbo.TitleCase(brand))
    END as brand,

    CASE 
        WHEN category IS NULL OR TRIM(category) = '''' THEN ''Unknown''
        ELSE TRIM(dbo.titleCase(category))
    END AS category,

    CASE 
        WHEN sub_category IS NULL OR TRIM(sub_category) = '''' THEN ''Unknown''
        ELSE dbo.TitleCase(TRIM(sub_category))
    END AS sub_category,

    CASE 
        WHEN department IS NULL OR TRIM(department) = '''' THEN ''Unknown''
        ELSE dbo.TitleCase(TRIM(department))
    END AS department,

    


    CASE
        WHEN TRIM(launched_date) LIKE ''[A-Z][a-z][a-z][a-z]% __, ____''
            THEN TRY_CONVERT(DATE, TRIM(launched_date))

        WHEN TRIM(launched_date) LIKE ''[A-Z][a-z][a-z] __, ____''
            THEN TRY_CONVERT(DATE, TRIM(launched_date))

        WHEN TRIM(launched_date) LIKE ''__-__-____''
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(launched_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(launched_date), 110)

        WHEN TRIM(launched_date) LIKE ''__-__-____''
            AND TRY_CONVERT(INT, LEFT(TRIM(launched_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(launched_date), 105)

        WHEN TRIM(launched_date) LIKE ''____-__-__''
            THEN TRY_CONVERT(DATE, TRIM(launched_date))

        WHEN TRIM(launched_date) LIKE ''____/__/__''
            THEN TRY_CONVERT(DATE, TRIM(launched_date))

        WHEN TRIM(launched_date) LIKE ''__/__/____''
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(launched_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(launched_date), 101)

        WHEN TRIM(launched_date) LIKE ''__/__/____''
            AND TRY_CONVERT(INT, LEFT(TRIM(launched_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(launched_date), 103)

        ELSE TRY_CONVERT(DATE, TRIM(launched_date), 101)

    END

 as launched_date,

    CASE 
        WHEN product_url IS NULL OR TRIM(product_url) = '''' OR product_url NOT LIKE ''https://%'' THEN ''Unknown''
        ELSE REPLACE(REPLACE(
    LOWER(TRIM(product_url))
, CHAR(13), ''''),CHAR(10), '''')
    END as product_url
FROM "RetailDB"."bronze"."stg_products" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_product_attributes__dbt_tmp" FROM "RetailDB"."bronze"."int_product_attributes__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_product_attributes__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_product_attributes__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_product_attributes__dbt_tmp')
    )
    DROP index "bronze"."int_product_attributes__dbt_tmp".bronze_int_product_attributes__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_product_attributes__dbt_tmp_cci
    ON "bronze"."int_product_attributes__dbt_tmp"

   


  