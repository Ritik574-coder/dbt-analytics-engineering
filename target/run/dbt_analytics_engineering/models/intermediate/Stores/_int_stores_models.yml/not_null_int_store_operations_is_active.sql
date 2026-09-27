
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_4d937a141d070d8fae5bef168664a696_7417]
   as 
    
    
    



select is_active
from "RetailDB"."bronze"."int_store_operations"
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
    [bronze].[testview_4d937a141d070d8fae5bef168664a696_7417]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_4d937a141d070d8fae5bef168664a696_7417]
  ;')