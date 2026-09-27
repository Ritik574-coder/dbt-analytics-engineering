
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_b678a9dba9f0b00c52df77e579c2a76c_14796]
   as 
    
    
    



select transaction_id
from "RetailDB"."bronze"."int_transaction_fulfillment"
where transaction_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_b678a9dba9f0b00c52df77e579c2a76c_14796]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_b678a9dba9f0b00c52df77e579c2a76c_14796]
  ;')