
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_40b9f02f6e8b7c65d3ee3310b004e532_10705]
   as 
    
    
    



select phone
from "RetailDB"."bronze"."int_customers_contact"
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
    [bronze].[testview_40b9f02f6e8b7c65d3ee3310b004e532_10705]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_40b9f02f6e8b7c65d3ee3310b004e532_10705]
  ;')