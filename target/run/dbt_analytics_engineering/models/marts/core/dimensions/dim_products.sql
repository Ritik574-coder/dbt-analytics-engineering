
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."dim_products__dbt_tmp__dbt_tmp_vw" AS SELECT
    a.product_id,
    a.sku,
    a.product_name,
    a.brand,
    a.category,
    a.sub_category,
    a.department,
    a.launched_date,
    a.product_url,
    p.base_price_usd,
    p.cost_price_usd,
    p.gross_margin_pct,
    i.is_available,
    i.stock_quantity,
    i.reorder_level,
    s.supplier_name,
    s.supplier_country,
    s.weight_kg,
    s.warranty_years,
    s.rating_avg,
    s.review_count
FROM "RetailDB"."bronze"."int_product_attributes" AS a
LEFT JOIN "RetailDB"."bronze"."int_product_pricing" AS p
    ON a.product_id = p.product_id
LEFT JOIN "RetailDB"."bronze"."int_product_inventory" AS i
    ON a.product_id = i.product_id
LEFT JOIN "RetailDB"."bronze"."int_product_supplier" AS s
    ON a.product_id = s.product_id ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."dim_products__dbt_tmp" FROM "RetailDB"."bronze"."dim_products__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."dim_products__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_dim_products__dbt_tmp_cci'
        AND object_id=object_id('bronze_dim_products__dbt_tmp')
    )
    DROP index "bronze"."dim_products__dbt_tmp".bronze_dim_products__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_dim_products__dbt_tmp_cci
    ON "bronze"."dim_products__dbt_tmp"

   


  