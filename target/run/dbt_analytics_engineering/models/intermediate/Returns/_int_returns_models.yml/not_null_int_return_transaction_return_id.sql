
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_40d1d3c17fa63975116efe78ebc97304_8397]
   as 
    
    
    



select return_id
from "RetailDB"."bronze"."int_return_transaction"
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
    [bronze].[testview_40d1d3c17fa63975116efe78ebc97304_8397]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_40d1d3c17fa63975116efe78ebc97304_8397]
  ;')