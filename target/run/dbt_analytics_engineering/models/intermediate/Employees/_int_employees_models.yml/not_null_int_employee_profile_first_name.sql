
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_a2eb893c688d2973f90e45b2ed0920cd_12937]
   as 
    
    
    



select first_name
from "RetailDB"."bronze"."int_employee_profile"
where first_name is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_a2eb893c688d2973f90e45b2ed0920cd_12937]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_a2eb893c688d2973f90e45b2ed0920cd_12937]
  ;')