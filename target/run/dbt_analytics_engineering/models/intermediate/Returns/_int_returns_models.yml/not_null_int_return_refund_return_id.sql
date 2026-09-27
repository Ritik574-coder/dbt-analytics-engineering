
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_570a9ab87419596d94f888210feccaa4_16218]
   as 
    
    
    



select return_id
from "RetailDB"."bronze"."int_return_refund"
where return_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_570a9ab87419596d94f888210feccaa4_16218]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_570a9ab87419596d94f888210feccaa4_16218]
  ;')