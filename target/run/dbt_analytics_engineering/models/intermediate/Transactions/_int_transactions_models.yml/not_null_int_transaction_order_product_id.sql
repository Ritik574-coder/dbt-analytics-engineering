
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_02dea72aae18fbd8f106d8768bb9b6b8_9782]
   as 
    
    
    



select product_id
from "RetailDB"."bronze"."int_transaction_order"
where product_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_02dea72aae18fbd8f106d8768bb9b6b8_9782]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_02dea72aae18fbd8f106d8768bb9b6b8_9782]
  ;')