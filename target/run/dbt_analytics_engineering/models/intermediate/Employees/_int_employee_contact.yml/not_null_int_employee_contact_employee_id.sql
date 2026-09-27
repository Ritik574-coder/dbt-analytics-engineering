
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_c280b070440e699ab4b0c2bbc0c1cc26_9056]
   as 
    
    
    



select employee_id
from "RetailDB"."bronze"."int_employee_contact"
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
    [bronze].[testview_c280b070440e699ab4b0c2bbc0c1cc26_9056]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_c280b070440e699ab4b0c2bbc0c1cc26_9056]
  ;')