
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_return_refund__dbt_tmp__dbt_tmp_vw" AS SELECT 
    return_id,
    
    CASE 
          WHEN TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, '','', ''''), ''$'', '''')) IS NULL THEN NULL
          WHEN refund_amount IS NULL OR TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, '','', ''''), ''$'', '''')) < 0 THEN NULL 
          ELSE TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, '','', ''''), ''$'', ''''))
    END as refund_amount,

    CASE 
          WHEN refund_method IS NULL OR TRIM(refund_method) = '''' THEN ''Unknown''
          ELSE TRIM(dbo.TitleCase(refund_method))
    END as refund_method
FROM "RetailDB"."bronze"."stg_returns" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_return_refund__dbt_tmp" FROM "RetailDB"."bronze"."int_return_refund__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_return_refund__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_return_refund__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_return_refund__dbt_tmp')
    )
    DROP index "bronze"."int_return_refund__dbt_tmp".bronze_int_return_refund__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_return_refund__dbt_tmp_cci
    ON "bronze"."int_return_refund__dbt_tmp"

   


  