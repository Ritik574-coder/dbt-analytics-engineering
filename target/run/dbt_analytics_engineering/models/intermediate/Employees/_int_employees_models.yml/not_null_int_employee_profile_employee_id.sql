
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_9f017e65951ef5a184aa7f5ea7bc2009_9479]
   as 
    
    
    



select employee_id
from "RetailDB"."bronze"."int_employee_profile"
where employee_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_9f017e65951ef5a184aa7f5ea7bc2009_9479]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_9f017e65951ef5a184aa7f5ea7bc2009_9479]
  ;')