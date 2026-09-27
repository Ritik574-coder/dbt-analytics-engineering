
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_review_transaction__dbt_tmp__dbt_tmp_vw" AS SELECT
    review_id,
    txn_id,

    customer_id,
    customer_name,

    product_id,
    product_name,

    


    CASE
        WHEN TRIM(review_date) LIKE ''[A-Z][a-z][a-z][a-z]% __, ____''
            THEN TRY_CONVERT(DATE, TRIM(review_date))

        WHEN TRIM(review_date) LIKE ''[A-Z][a-z][a-z] __, ____''
            THEN TRY_CONVERT(DATE, TRIM(review_date))

        WHEN TRIM(review_date) LIKE ''__-__-____''
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(review_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(review_date), 110)

        WHEN TRIM(review_date) LIKE ''__-__-____''
            AND TRY_CONVERT(INT, LEFT(TRIM(review_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(review_date), 105)

        WHEN TRIM(review_date) LIKE ''____-__-__''
            THEN TRY_CONVERT(DATE, TRIM(review_date))

        WHEN TRIM(review_date) LIKE ''____/__/__''
            THEN TRY_CONVERT(DATE, TRIM(review_date))

        WHEN TRIM(review_date) LIKE ''__/__/____''
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(review_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(review_date), 101)

        WHEN TRIM(review_date) LIKE ''__/__/____''
            AND TRY_CONVERT(INT, LEFT(TRIM(review_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(review_date), 103)

        ELSE TRY_CONVERT(DATE, TRIM(review_date), 101)

    END

 as review_date,

    CASE 
        WHEN TRIM(LOWER(verified_purchase)) IN (''1'', ''y'', ''yes'', ''true'', ''verified'') THEN ''Verified''
        WHEN TRIM(LOWER(verified_purchase)) IN (''0'', ''n'', ''no'', ''false'')             THEN ''Not Verified''    
        ELSE ''Unknown''
    END AS verified_purchase
FROM "RetailDB"."bronze"."stg_reviews" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_review_transaction__dbt_tmp" FROM "RetailDB"."bronze"."int_review_transaction__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_review_transaction__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_review_transaction__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_review_transaction__dbt_tmp')
    )
    DROP index "bronze"."int_review_transaction__dbt_tmp".bronze_int_review_transaction__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_review_transaction__dbt_tmp_cci
    ON "bronze"."int_review_transaction__dbt_tmp"

   


  