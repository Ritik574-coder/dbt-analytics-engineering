
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_98651dc984524109f98ae8021d89d6ea_7852]
   as 
    
    
    



select district
from "RetailDB"."bronze"."int_store_location"
where district is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_98651dc984524109f98ae8021d89d6ea_7852]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_98651dc984524109f98ae8021d89d6ea_7852]
  ;')