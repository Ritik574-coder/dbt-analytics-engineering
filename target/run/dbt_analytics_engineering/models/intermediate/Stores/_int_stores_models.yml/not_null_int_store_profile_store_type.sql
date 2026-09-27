
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_b7223b29ea7c3a2e2f99a8ab40cd629d_15261]
   as 
    
    
    



select store_type
from "RetailDB"."bronze"."int_store_profile"
where store_type is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_b7223b29ea7c3a2e2f99a8ab40cd629d_15261]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_b7223b29ea7c3a2e2f99a8ab40cd629d_15261]
  ;')