
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_e4de03b5348882fbf5dbeb6578cce3f8_15855]
   as 
    
    
    

select
    transaction_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_transaction_financial"
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
    [bronze].[testview_e4de03b5348882fbf5dbeb6578cce3f8_15855]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_e4de03b5348882fbf5dbeb6578cce3f8_15855]
  ;')