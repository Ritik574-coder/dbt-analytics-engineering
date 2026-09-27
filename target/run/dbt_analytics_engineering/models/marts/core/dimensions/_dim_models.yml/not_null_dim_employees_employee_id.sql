
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_a5f5c6ec12f361eec8eca8f56b3b17ff_13516]
   as 
    
    
    



select employee_id
from "RetailDB"."bronze"."dim_employees"
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
    [bronze].[testview_a5f5c6ec12f361eec8eca8f56b3b17ff_13516]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_a5f5c6ec12f361eec8eca8f56b3b17ff_13516]
  ;')