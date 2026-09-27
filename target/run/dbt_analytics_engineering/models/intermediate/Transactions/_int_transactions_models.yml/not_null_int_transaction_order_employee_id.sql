
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_31d5a6be96d5ee94ffcc3d09fbbc9c5d_18673]
   as 
    
    
    



select employee_id
from "RetailDB"."bronze"."int_transaction_order"
where employee_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_31d5a6be96d5ee94ffcc3d09fbbc9c5d_18673]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_31d5a6be96d5ee94ffcc3d09fbbc9c5d_18673]
  ;')