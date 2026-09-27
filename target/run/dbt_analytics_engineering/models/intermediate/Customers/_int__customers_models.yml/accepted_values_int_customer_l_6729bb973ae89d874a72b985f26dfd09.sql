
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_b83b1e9561b73aa2e88a8099d4836e56_9659]
   as 
    
    
    

with all_values as (

    select
        region as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customer_location"
    group by region

)

select *
from all_values
where value_field not in (
    ''Midwest'',''Northeast'',''South'',''West''
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
    [bronze].[testview_b83b1e9561b73aa2e88a8099d4836e56_9659]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_b83b1e9561b73aa2e88a8099d4836e56_9659]
  ;')