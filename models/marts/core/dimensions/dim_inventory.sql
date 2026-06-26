-- models/marts/core/dimensions/dim_inventory.sql
{{ 
  config(
    materialized='table',
    unique_key='product_snapshot_sk',
    tags=['marts', 'dimension', 'inventory']
  ) 
}}

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
  FROM {{ ref('int_inventory_product') }} p
  INNER JOIN {{ ref('int_inventory_valuation') }} v
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
  {{ dbt_utils.generate_surrogate_key([
    'product_id', 
    'snapshot_date'
  ]) }} as product_snapshot_sk,
  
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
WHERE snapshot_date IS NOT NULL