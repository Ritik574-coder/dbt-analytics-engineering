
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_e8394af93ad0a687784fd5a883c4c25f_3701]
   as 
    
    
    



select transaction_id
from "RetailDB"."bronze"."fct_sales"
where transaction_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_e8394af93ad0a687784fd5a883c4c25f_3701]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_e8394af93ad0a687784fd5a883c4c25f_3701]
  ;')