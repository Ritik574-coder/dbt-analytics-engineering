
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_c568e3589e9b1f75d91fc8db5809822d_4817]
   as 
    
    
    



select inventory_snapshot_sk
from "RetailDB"."bronze"."stg_inventory"
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
    [bronze].[testview_c568e3589e9b1f75d91fc8db5809822d_4817]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_c568e3589e9b1f75d91fc8db5809822d_4817]
  ;')