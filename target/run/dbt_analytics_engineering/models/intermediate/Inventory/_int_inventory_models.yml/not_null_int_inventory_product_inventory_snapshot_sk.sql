
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_9e717169e893e7a375cfa42d69c31b19_12963]
   as 
    
    
    



select inventory_snapshot_sk
from "RetailDB"."bronze"."int_inventory_product"
where inventory_snapshot_sk is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_9e717169e893e7a375cfa42d69c31b19_12963]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_9e717169e893e7a375cfa42d69c31b19_12963]
  ;')