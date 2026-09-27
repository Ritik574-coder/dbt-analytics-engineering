
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_64ae43b30cc4fbcf620ce2fa2f0c8612_1907]
   as 
    
    
    



select first_name
from "RetailDB"."bronze"."int_customer_profile"
where first_name is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_64ae43b30cc4fbcf620ce2fa2f0c8612_1907]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_64ae43b30cc4fbcf620ce2fa2f0c8612_1907]
  ;')