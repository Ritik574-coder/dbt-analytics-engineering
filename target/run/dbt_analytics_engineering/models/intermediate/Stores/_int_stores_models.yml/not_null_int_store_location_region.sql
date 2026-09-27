
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_2d1cff721b6781557a9e9ac20640317a_15510]
   as 
    
    
    



select region
from "RetailDB"."bronze"."int_store_location"
where region is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_2d1cff721b6781557a9e9ac20640317a_15510]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_2d1cff721b6781557a9e9ac20640317a_15510]
  ;')