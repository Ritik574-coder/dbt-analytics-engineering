
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_c5b2d311898e2646396650a2f00ced23_11068]
   as 
    
    
    



select warehouse_location
from "RetailDB"."bronze"."int_inventory_valuation"
where warehouse_location is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_c5b2d311898e2646396650a2f00ced23_11068]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_c5b2d311898e2646396650a2f00ced23_11068]
  ;')