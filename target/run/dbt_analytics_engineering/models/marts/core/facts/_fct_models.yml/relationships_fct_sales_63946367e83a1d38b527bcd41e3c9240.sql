
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_56037ca176f1eabf8b128a2c3a1420f7_2269]
   as 
    
    
    

with child as (
    select product_id as from_field
    from "RetailDB"."bronze"."fct_sales"
    where product_id is not null
),

parent as (
    select product_id as to_field
    from "RetailDB"."bronze"."dim_products"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_56037ca176f1eabf8b128a2c3a1420f7_2269]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_56037ca176f1eabf8b128a2c3a1420f7_2269]
  ;')