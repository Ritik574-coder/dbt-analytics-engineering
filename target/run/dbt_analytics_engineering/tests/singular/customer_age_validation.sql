
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_5cdd70a679da98ec4e21bc0de5f1a5ee_4610]
   as 
    SELECT
    * 
FROM "RetailDB"."bronze"."int_customer_profile"
WHEREdate_of_birth NOT LIKE ''____-__-__'' 
    OR date_of_birth IS NULL  ;
  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_5cdd70a679da98ec4e21bc0de5f1a5ee_4610]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_5cdd70a679da98ec4e21bc0de5f1a5ee_4610]
  ;')