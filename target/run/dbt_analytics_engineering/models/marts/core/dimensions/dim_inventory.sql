
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."dim_inventory__dbt_tmp__dbt_tmp_vw" AS -- models/marts/core/dimensions/dim_inventory.sql


/*
  Description: Product dimension with SCD Type 2 tracking
  Grain: 1 row per product snapshot change
  Load: Full refresh daily
*/

WITH product_base AS (
  SELECT
    p.inventory_snapshot_sk,
    p.snapshot_date,
    p.product_id,
    p.product_name,
    p.sku,
    p.category,
    v.unit_cost,
    v.unit_price,
    v.warehouse_location,
    v.store_id
  FROM "RetailDB"."bronze"."int_inventory_product" p
  INNER JOIN "RetailDB"."bronze"."int_inventory_valuation" v
    ON p.inventory_snapshot_sk = v.inventory_snapshot_sk
),

product_with_lead AS (
  SELECT
    *,
    LEAD(snapshot_date) OVER (
      PARTITION BY product_id 
      ORDER BY snapshot_date
    ) as next_effective_date
  FROM product_base
)

SELECT
  
    lower(convert(varchar(50), hashbytes(''md5'', coalesce(convert(varchar(8000), concat(coalesce(cast(product_id as VARCHAR(MAX)), ''_dbt_utils_surrogate_key_null_''), ''-'', coalesce(cast(snapshot_date as VARCHAR(MAX)), ''_dbt_utils_surrogate_key_null_''))), '''')), 2))
 as product_snapshot_sk,
  
  product_id,
  inventory_snapshot_sk,
  product_name,
  sku,
  category,
  
  unit_cost,
  unit_price,
  unit_price - unit_cost as unit_margin,
  CASE 
    WHEN unit_price = 0 OR unit_price IS NULL THEN 0
    ELSE ROUND(((unit_price - unit_cost) / unit_price) * 100, 2)
  END as margin_percentage,
  
  warehouse_location,
  store_id,
  
  snapshot_date as effective_from_date,
  next_effective_date as effective_to_date,
  
  CASE 
    WHEN next_effective_date IS NULL THEN 1 
    ELSE 0 
  END as is_current_record,
  
  CASE 
    WHEN unit_cost > unit_price THEN 1 
    ELSE 0 
  END as is_negative_margin,
  
  GETDATE() as dbt_created_at,
  GETDATE() as dbt_updated_at
  
FROM product_with_lead
WHERE snapshot_date IS NOT NULL;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."dim_inventory__dbt_tmp" FROM "RetailDB"."bronze"."dim_inventory__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."dim_inventory__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_dim_inventory__dbt_tmp_cci'
        AND object_id=object_id('bronze_dim_inventory__dbt_tmp')
    )
    DROP index "bronze"."dim_inventory__dbt_tmp".bronze_dim_inventory__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_dim_inventory__dbt_tmp_cci
    ON "bronze"."dim_inventory__dbt_tmp"

   


  