
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_dc3b54dcbbb27f00b8ea0ef8b88a6f42_5969]
   as 
    
    
    

with all_values as (

    select
        is_available as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_product_inventory"
    group by is_available

)

select *
from all_values
where value_field not in (
    ''Available'',''Not Available'',''Discontinued'',''Unknown''
)



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_dc3b54dcbbb27f00b8ea0ef8b88a6f42_5969]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_dc3b54dcbbb27f00b8ea0ef8b88a6f42_5969]
  ;')