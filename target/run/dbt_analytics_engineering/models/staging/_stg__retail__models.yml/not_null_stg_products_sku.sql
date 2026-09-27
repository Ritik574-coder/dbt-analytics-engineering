
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_1df8d67e27bc6c47d357a0f5f1fa6fb0_8486]
   as 
    
    
    



select sku
from "RetailDB"."bronze"."stg_products"
where sku is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_1df8d67e27bc6c47d357a0f5f1fa6fb0_8486]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_1df8d67e27bc6c47d357a0f5f1fa6fb0_8486]
  ;')