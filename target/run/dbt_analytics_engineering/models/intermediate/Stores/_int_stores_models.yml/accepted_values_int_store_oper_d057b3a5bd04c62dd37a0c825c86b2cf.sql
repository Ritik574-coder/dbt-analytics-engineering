
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_470dec63d046aa4f52e593abf67655e9_17856]
   as 
    
    
    

with all_values as (

    select
        is_active as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_store_operations"
    group by is_active

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
    [bronze].[testview_470dec63d046aa4f52e593abf67655e9_17856]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_470dec63d046aa4f52e593abf67655e9_17856]
  ;')