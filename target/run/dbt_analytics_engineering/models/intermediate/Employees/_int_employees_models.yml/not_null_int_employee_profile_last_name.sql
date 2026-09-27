
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_0796cc6a9c586a75e106fb436074c355_10601]
   as 
    
    
    



select last_name
from "RetailDB"."bronze"."int_employee_profile"
where last_name is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_0796cc6a9c586a75e106fb436074c355_10601]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_0796cc6a9c586a75e106fb436074c355_10601]
  ;')