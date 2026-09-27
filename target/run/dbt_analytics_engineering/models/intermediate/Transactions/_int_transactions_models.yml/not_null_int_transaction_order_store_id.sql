
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_36ef61819aa721ce44cef5914aaa14ef_16155]
   as 
    
    
    



select store_id
from "RetailDB"."bronze"."int_transaction_order"
where store_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_36ef61819aa721ce44cef5914aaa14ef_16155]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_36ef61819aa721ce44cef5914aaa14ef_16155]
  ;')