
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_return_transaction__dbt_tmp__dbt_tmp_vw" AS SELECT
      CASE 
            WHEN TRY_CONVERT(INT, return_id) < 1 OR TRY_CONVERT(INT, return_id) IS NULL 
                  THEN NULL

            ELSE TRY_CONVERT(INT, return_id)
      END as return_id,

      CASE 
            WHEN original_txn_id IS NULL 
                  THEN NULL

            WHEN UPPER(TRIM(original_txn_id)) NOT LIKE ''TXN-%'' 
                  THEN NULL

            WHEN LEN(UPPER(TRIM(original_txn_id))) < 10 
                  THEN NULL

            ELSE UPPER(TRIM(original_txn_id))
      END as original_txn_id,

      CASE 
            WHEN original_order_id IS NULL OR TRY_CONVERT(INT, original_order_id) < 1 OR TRY_CONVERT(INT, original_order_id) IS NULL 
                  THEN NULL 

            ELSE TRY_CONVERT(INT, original_order_id)
      END as original_order_id,

      CASE 
            WHEN customer_id IS NULL OR TRY_CONVERT(INT, customer_id) IS NULL 
                  THEN NULL 

            ELSE TRY_CONVERT(INT, customer_id)
      END as customer_id,

      CASE 
            WHEN customer_name IS NULL OR TRIM(customer_name) = '''' 
                  THEN ''Unknown''

            ELSE dbo.TitleCase(TRIM(customer_name))
      END as customer_name,

      CASE 
            WHEN product_id IS NULL OR TRY_CONVERT(INT, product_id) IS NULL 
                  THEN NULL 

            ELSE TRY_CONVERT(INT, product_id)
      END as product_id,

      CASE 
            WHEN product_name IS NULL OR TRIM(product_name) = '''' 
                  THEN ''Unknown''

            ELSE dbo.TitleCase(TRIM(product_name))
      END as product_name,

      CASE 
            WHEN quantity_returned IS NULL OR TRY_CONVERT(INT, quantity_returned) IS NULL OR TRY_CONVERT(INT, quantity_returned) < 1 
                  THEN NULL 

            ELSE TRY_CONVERT(INT, quantity_returned)
      END as quantity_returned,




    CASE
        WHEN TRIM(return_date) LIKE ''[A-Z][a-z][a-z][a-z]% __, ____''
            THEN TRY_CONVERT(DATE, TRIM(return_date))

        WHEN TRIM(return_date) LIKE ''[A-Z][a-z][a-z] __, ____''
            THEN TRY_CONVERT(DATE, TRIM(return_date))

        WHEN TRIM(return_date) LIKE ''__-__-____''
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(return_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(return_date), 110)

        WHEN TRIM(return_date) LIKE ''__-__-____''
            AND TRY_CONVERT(INT, LEFT(TRIM(return_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(return_date), 105)

        WHEN TRIM(return_date) LIKE ''____-__-__''
            THEN TRY_CONVERT(DATE, TRIM(return_date))

        WHEN TRIM(return_date) LIKE ''____/__/__''
            THEN TRY_CONVERT(DATE, TRIM(return_date))

        WHEN TRIM(return_date) LIKE ''__/__/____''
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(return_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(return_date), 101)

        WHEN TRIM(return_date) LIKE ''__/__/____''
            AND TRY_CONVERT(INT, LEFT(TRIM(return_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(return_date), 103)

        ELSE TRY_CONVERT(DATE, TRIM(return_date), 101)

    END

 as return_date
FROM "RetailDB"."bronze"."stg_returns" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_return_transaction__dbt_tmp" FROM "RetailDB"."bronze"."int_return_transaction__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_return_transaction__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_return_transaction__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_return_transaction__dbt_tmp')
    )
    DROP index "bronze"."int_return_transaction__dbt_tmp".bronze_int_return_transaction__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_return_transaction__dbt_tmp_cci
    ON "bronze"."int_return_transaction__dbt_tmp"

   


  