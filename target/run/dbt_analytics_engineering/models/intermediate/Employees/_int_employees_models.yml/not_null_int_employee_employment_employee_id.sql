
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_6b7697cd6027cfe4573bf04c2321c53b_7985]
   as 
    
    
    



select employee_id
from "RetailDB"."bronze"."int_employee_employment"
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
    [bronze].[testview_6b7697cd6027cfe4573bf04c2321c53b_7985]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_6b7697cd6027cfe4573bf04c2321c53b_7985]
  ;')