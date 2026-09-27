
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_580959aba68ef130d8cbfa43c555c4b2_14083]
   as 
    
    
    



select store_id
from "RetailDB"."bronze"."int_store_location"
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
    [bronze].[testview_580959aba68ef130d8cbfa43c555c4b2_14083]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_580959aba68ef130d8cbfa43c555c4b2_14083]
  ;')