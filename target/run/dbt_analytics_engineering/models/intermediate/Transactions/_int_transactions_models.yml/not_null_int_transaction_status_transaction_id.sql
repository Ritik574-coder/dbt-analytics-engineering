
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_6650b171750c3dff9ee96dd0424336db_13420]
   as 
    
    
    



select transaction_id
from "RetailDB"."bronze"."int_transaction_status"
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
    [bronze].[testview_6650b171750c3dff9ee96dd0424336db_13420]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_6650b171750c3dff9ee96dd0424336db_13420]
  ;')