
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_67bacecdd40ba5eefbedf8c0c2cd320a_18815]
   as 
    
    
    



select email
from "RetailDB"."bronze"."int_employee_contact"
where email is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_67bacecdd40ba5eefbedf8c0c2cd320a_18815]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_67bacecdd40ba5eefbedf8c0c2cd320a_18815]
  ;')