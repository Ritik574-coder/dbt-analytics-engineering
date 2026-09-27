
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_8f8cd2a6a9fcc17d1d71b32dcd21f708_13569]
   as 
    
    
    



select annual_salary_usd
from "RetailDB"."bronze"."int_employee_employment"
where annual_salary_usd is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_8f8cd2a6a9fcc17d1d71b32dcd21f708_13569]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_8f8cd2a6a9fcc17d1d71b32dcd21f708_13569]
  ;')