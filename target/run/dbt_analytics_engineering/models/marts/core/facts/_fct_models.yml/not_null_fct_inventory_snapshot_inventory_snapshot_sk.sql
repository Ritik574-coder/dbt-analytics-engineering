
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_aa4ce383968a1383e1bef2ed1813850a_12188]
   as 
    
    
    



select inventory_snapshot_sk
from "RetailDB"."bronze"."fct_inventory_snapshot"
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
    [bronze].[testview_aa4ce383968a1383e1bef2ed1813850a_12188]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_aa4ce383968a1383e1bef2ed1813850a_12188]
  ;')