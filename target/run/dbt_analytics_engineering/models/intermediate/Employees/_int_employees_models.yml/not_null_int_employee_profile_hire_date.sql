
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_91506ac3bf41368247eb9564fd8be441_3073]
   as 
    
    
    



select hire_date
from "RetailDB"."bronze"."int_employee_profile"
where hire_date is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_91506ac3bf41368247eb9564fd8be441_3073]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_91506ac3bf41368247eb9564fd8be441_3073]
  ;')