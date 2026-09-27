
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_65bf5bc998bbca4c34bd697649259695_3442]
   as 
    
    
    

with all_values as (

    select
        return_channel as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_return_processing"
    group by return_channel

)

select *
from all_values
where value_field not in (
    ''Mobile App'',''In Store'',''Online'',''Phone Call'',''Catalog'',''Unknown''
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
    [bronze].[testview_65bf5bc998bbca4c34bd697649259695_3442]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_65bf5bc998bbca4c34bd697649259695_3442]
  ;')