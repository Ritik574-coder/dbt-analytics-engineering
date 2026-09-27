
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_5c661fe9c08a1ec4639216f8c3c68e2b_5638]
   as 
    SELECT *
FROM "RetailDB"."bronze"."int_customer_location"
WHERE zip_code IS NULL
   OR LEN(CAST(zip_code AS VARCHAR(10))) <> 5
   OR TRY_CAST(zip_code AS INT) IS NULL
  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_5c661fe9c08a1ec4639216f8c3c68e2b_5638]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_5c661fe9c08a1ec4639216f8c3c68e2b_5638]
  ;')