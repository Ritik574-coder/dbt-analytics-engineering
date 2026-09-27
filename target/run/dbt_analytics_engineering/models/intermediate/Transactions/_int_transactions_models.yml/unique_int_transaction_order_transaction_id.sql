
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_be9cac256f8f842cecc68afc60ab202c_17849]
   as 
    
    
    

select
    transaction_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_transaction_order"
where transaction_id is not null
group by transaction_id
having count(*) > 1



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_be9cac256f8f842cecc68afc60ab202c_17849]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_be9cac256f8f842cecc68afc60ab202c_17849]
  ;')