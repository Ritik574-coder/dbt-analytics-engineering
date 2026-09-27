
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."dim_date__dbt_tmp__dbt_tmp_vw" AS WITH dates AS (
    SELECT order_date AS date_day FROM "RetailDB"."bronze"."int_transaction_fulfillment"
    UNION
    SELECT ship_date AS date_day FROM "RetailDB"."bronze"."int_transaction_fulfillment"
    UNION
    SELECT delivery_date AS date_day FROM "RetailDB"."bronze"."int_transaction_fulfillment"
    UNION
    SELECT return_date AS date_day FROM "RetailDB"."bronze"."int_return_transaction"
    UNION
    SELECT review_date AS date_day FROM "RetailDB"."bronze"."int_review_transaction"
    UNION
    SELECT snapshot_date AS date_day FROM "RetailDB"."bronze"."int_inventory_product"
)

SELECT
    date_day,
    YEAR(date_day) AS year_number,
    DATEPART(QUARTER, date_day) AS quarter_number,
    MONTH(date_day) AS month_number,
    DATENAME(MONTH, date_day) AS month_name,
    DAY(date_day) AS day_of_month,
    DATEPART(WEEK, date_day) AS week_number,
    DATENAME(WEEKDAY, date_day) AS day_name,
    DATEPART(WEEKDAY, date_day) AS day_of_week_number,
    CASE
        WHEN DATEPART(WEEKDAY, date_day) IN (1, 7) THEN ''Weekend''
        ELSE ''Weekday''
    END AS day_type
FROM dates
WHERE date_day IS NOT NULL;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."dim_date__dbt_tmp" FROM "RetailDB"."bronze"."dim_date__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."dim_date__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_dim_date__dbt_tmp_cci'
        AND object_id=object_id('bronze_dim_date__dbt_tmp')
    )
    DROP index "bronze"."dim_date__dbt_tmp".bronze_dim_date__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_dim_date__dbt_tmp_cci
    ON "bronze"."dim_date__dbt_tmp"

   


  