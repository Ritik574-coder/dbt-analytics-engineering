
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_962699dcbdb4a5b5b123d9b5b6547512_14838]
   as 
    
    
    



select department
from "RetailDB"."bronze"."int_employee_employment"
where department is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_962699dcbdb4a5b5b123d9b5b6547512_14838]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_962699dcbdb4a5b5b123d9b5b6547512_14838]
  ;')