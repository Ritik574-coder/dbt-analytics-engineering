
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_793423fe8f7609c699731c0a1017bf14_3071]
   as 
    
    
    

with all_values as (

    select
        restocked as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_return_processing"
    group by restocked

)

select *
from all_values
where value_field not in (
    ''Yes'',''No'',''Unknown''
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
    [bronze].[testview_793423fe8f7609c699731c0a1017bf14_3071]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_793423fe8f7609c699731c0a1017bf14_3071]
  ;')