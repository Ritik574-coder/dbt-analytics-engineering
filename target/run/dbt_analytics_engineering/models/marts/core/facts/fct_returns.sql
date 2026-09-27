
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."fct_returns__dbt_tmp__dbt_tmp_vw" AS SELECT
    t.return_id,
    t.original_txn_id,
    t.original_order_id,
    t.customer_id,
    t.product_id,
    t.quantity_returned,
    t.return_date,
    p.return_reason,
    p.return_channel,
    p.restocked,
    p.return_status,
    p.handled_by_emp_id,
    p.notes,
    r.refund_amount,
    r.refund_method
FROM "RetailDB"."bronze"."int_return_transaction" AS t
LEFT JOIN "RetailDB"."bronze"."int_return_processing" AS p
    ON t.return_id = p.return_id
LEFT JOIN "RetailDB"."bronze"."int_return_refund" AS r
    ON t.return_id = r.return_id
WHERE t.return_id IS NOT NULL;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."fct_returns__dbt_tmp" FROM "RetailDB"."bronze"."fct_returns__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."fct_returns__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_fct_returns__dbt_tmp_cci'
        AND object_id=object_id('bronze_fct_returns__dbt_tmp')
    )
    DROP index "bronze"."fct_returns__dbt_tmp".bronze_fct_returns__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_fct_returns__dbt_tmp_cci
    ON "bronze"."fct_returns__dbt_tmp"

   


  