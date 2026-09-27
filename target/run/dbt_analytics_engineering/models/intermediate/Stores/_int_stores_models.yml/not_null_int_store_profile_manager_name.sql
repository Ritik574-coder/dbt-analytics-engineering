
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_6dc962fc8419d3b32d3ced4922b8d43d_14657]
   as 
    
    
    



select manager_name
from "RetailDB"."bronze"."int_store_profile"
where manager_name is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_6dc962fc8419d3b32d3ced4922b8d43d_14657]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_6dc962fc8419d3b32d3ced4922b8d43d_14657]
  ;')