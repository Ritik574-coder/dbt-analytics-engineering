
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_281725be2d109519267eb3fc62057a0d_10891]
   as 
    
    
    

with all_values as (

    select
        refund_method as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_return_refund"
    group by refund_method

)

select *
from all_values
where value_field not in (
    ''Cash'',''Original Payment'',''Store Credit''
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
    [bronze].[testview_281725be2d109519267eb3fc62057a0d_10891]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_281725be2d109519267eb3fc62057a0d_10891]
  ;')