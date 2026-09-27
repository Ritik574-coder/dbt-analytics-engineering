
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_fc7a14e7d9a0923c0f1e607d568e92a5_12559]
   as 
    
    
    



select phone
from "RetailDB"."bronze"."int_store_location"
where phone is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_fc7a14e7d9a0923c0f1e607d568e92a5_12559]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_fc7a14e7d9a0923c0f1e607d568e92a5_12559]
  ;')