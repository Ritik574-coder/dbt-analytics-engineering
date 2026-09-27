
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_8de62e3fce7d0456038265d8126317b2_13794]
   as 
    
    
    



select store_id
from "RetailDB"."bronze"."dim_stores"
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
    [bronze].[testview_8de62e3fce7d0456038265d8126317b2_13794]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_8de62e3fce7d0456038265d8126317b2_13794]
  ;')