
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_898a0599dee3990f84222a72f44edc4e_13768]
   as 
    
    
    



select zip_code
from "RetailDB"."bronze"."int_customer_location"
where zip_code is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_898a0599dee3990f84222a72f44edc4e_13768]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_898a0599dee3990f84222a72f44edc4e_13768]
  ;')