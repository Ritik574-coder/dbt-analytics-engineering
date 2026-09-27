
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_f05b5d8bfb44869107fde2b7d766dd53_17322]
   as 
    

SELECT 
    *
FROM "RetailDB"."bronze"."int_customer_profile"
WHERE date_of_birth > ''1900-01-01''
    AND date_of_birth < ''2100-01-01''
    

  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_f05b5d8bfb44869107fde2b7d766dd53_17322]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_f05b5d8bfb44869107fde2b7d766dd53_17322]
  ;')