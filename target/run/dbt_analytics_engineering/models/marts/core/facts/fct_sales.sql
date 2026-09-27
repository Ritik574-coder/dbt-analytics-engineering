
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."fct_sales__dbt_tmp__dbt_tmp_vw" AS SELECT
    o.transaction_id,
    o.order_id,
    o.order_line_number,
    o.customer_id,
    o.product_id,
    o.store_id,
    o.employee_id,
    f.order_date,
    f.ship_date,
    f.delivery_date,
    f.shipping_method,
    f.sales_channel,
    f.payment_method,
    s.promo_id,
    s.promo_name,
    s.order_status,
    s.is_returned,
    s.data_source,
    m.quantity_ordered,
    m.unit_list_price,
    m.discount_pct,
    m.unit_selling_price,
    m.line_total_before_tax,
    m.tax_rate_pct,
    m.tax_amount,
    m.line_total_with_tax
FROM "RetailDB"."bronze"."int_transaction_order" AS o
LEFT JOIN "RetailDB"."bronze"."int_transaction_fulfillment" AS f
    ON o.transaction_id = f.transaction_id
LEFT JOIN "RetailDB"."bronze"."int_transaction_status" AS s
    ON o.transaction_id = s.transaction_id
LEFT JOIN "RetailDB"."bronze"."int_transaction_financial" AS m
    ON o.transaction_id = m.transaction_id
WHERE o.transaction_id IS NOT NULL;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."fct_sales__dbt_tmp" FROM "RetailDB"."bronze"."fct_sales__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."fct_sales__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_fct_sales__dbt_tmp_cci'
        AND object_id=object_id('bronze_fct_sales__dbt_tmp')
    )
    DROP index "bronze"."fct_sales__dbt_tmp".bronze_fct_sales__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_fct_sales__dbt_tmp_cci
    ON "bronze"."fct_sales__dbt_tmp"

   


  