
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_8e3eb709d5879177bedcd7623578c784_17412]
   as 
    
    
    



select is_active
from "RetailDB"."bronze"."int_employee_employment"
where is_active is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_8e3eb709d5879177bedcd7623578c784_17412]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_8e3eb709d5879177bedcd7623578c784_17412]
  ;')