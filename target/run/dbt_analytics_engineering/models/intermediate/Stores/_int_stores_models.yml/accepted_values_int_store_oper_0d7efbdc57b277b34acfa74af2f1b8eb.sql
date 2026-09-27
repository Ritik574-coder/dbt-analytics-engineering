
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_807605ca651b54e4f81d461f50dfdf71_7193]
   as 
    
    
    

with all_values as (

    select
        has_parking as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_store_operations"
    group by has_parking

)

select *
from all_values
where value_field not in (
    ''True'',''False'',''Unknown''
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
    [bronze].[testview_807605ca651b54e4f81d461f50dfdf71_7193]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_807605ca651b54e4f81d461f50dfdf71_7193]
  ;')