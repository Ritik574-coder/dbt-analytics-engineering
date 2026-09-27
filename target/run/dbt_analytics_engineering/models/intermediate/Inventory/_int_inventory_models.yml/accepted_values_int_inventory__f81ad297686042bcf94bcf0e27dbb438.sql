
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_a4425523c5e1536fe659a65f16d402a8_12248]
   as 
    
    
    

with all_values as (

    select
        category as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_inventory_product"
    group by category

)

select *
from all_values
where value_field not in (
    ''Electronics'',''Clothing'',''Kitchen'',''Office'',''Sports'',''Health'',''Beauty'',''Footwear'',''Toys'',''Bags'',''Unknown''
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
    [bronze].[testview_a4425523c5e1536fe659a65f16d402a8_12248]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_a4425523c5e1536fe659a65f16d402a8_12248]
  ;')