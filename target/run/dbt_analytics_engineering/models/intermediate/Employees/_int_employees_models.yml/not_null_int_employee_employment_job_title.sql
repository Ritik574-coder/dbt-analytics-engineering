
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_372c8d4e326a6a233bba9d9576df3420_4720]
   as 
    
    
    



select job_title
from "RetailDB"."bronze"."int_employee_employment"
where job_title is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_372c8d4e326a6a233bba9d9576df3420_4720]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_372c8d4e326a6a233bba9d9576df3420_4720]
  ;')