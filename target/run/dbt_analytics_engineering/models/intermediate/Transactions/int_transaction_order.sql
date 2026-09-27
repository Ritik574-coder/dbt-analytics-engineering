
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_transaction_order__dbt_tmp__dbt_tmp_vw" AS SELECT
    transaction_id,
    order_id,
    customer_id,
    product_id,
    store_id,
    employee_id,
    CASE 
        WHEN order_line_number < 1 THEN NULL 
        WHEN order_line_number > 20 THEN NULL
        ELSE order_line_number
    END as order_line_number
FROM "RetailDB"."bronze"."stg_transactions" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_transaction_order__dbt_tmp" FROM "RetailDB"."bronze"."int_transaction_order__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_transaction_order__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_transaction_order__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_transaction_order__dbt_tmp')
    )
    DROP index "bronze"."int_transaction_order__dbt_tmp".bronze_int_transaction_order__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_transaction_order__dbt_tmp_cci
    ON "bronze"."int_transaction_order__dbt_tmp"

   


  