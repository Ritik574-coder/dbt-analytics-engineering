
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_c890f88e489830c23758ff9b2e518177_11592]
   as 
    
    
    



select sku
from "RetailDB"."bronze"."int_inventory_product"
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
    [bronze].[testview_c890f88e489830c23758ff9b2e518177_11592]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_c890f88e489830c23758ff9b2e518177_11592]
  ;')