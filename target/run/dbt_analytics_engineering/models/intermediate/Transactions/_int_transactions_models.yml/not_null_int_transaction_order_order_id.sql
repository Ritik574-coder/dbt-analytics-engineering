
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_8f1e8edc59776bc9eac655fa8f201f84_12516]
   as 
    
    
    



select order_id
from "RetailDB"."bronze"."int_transaction_order"
where order_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_8f1e8edc59776bc9eac655fa8f201f84_12516]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_8f1e8edc59776bc9eac655fa8f201f84_12516]
  ;')