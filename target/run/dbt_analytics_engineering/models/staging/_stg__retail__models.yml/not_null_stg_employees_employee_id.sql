
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_3d63e9137ebb127a56884a6c39f57475_16328]
   as 
    
    
    



select employee_id
from "RetailDB"."bronze"."stg_employees"
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
    [bronze].[testview_3d63e9137ebb127a56884a6c39f57475_16328]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_3d63e9137ebb127a56884a6c39f57475_16328]
  ;')