
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_c01cd6f7b9db9e3b19e03636a59d2815_11391]
   as 
    
    
    



select store_id
from "RetailDB"."bronze"."int_store_operations"
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
    [bronze].[testview_c01cd6f7b9db9e3b19e03636a59d2815_11391]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_c01cd6f7b9db9e3b19e03636a59d2815_11391]
  ;')