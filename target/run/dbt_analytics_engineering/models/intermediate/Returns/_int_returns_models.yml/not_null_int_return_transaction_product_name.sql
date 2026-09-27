
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_b3698707793d4d4b3dafe4fcd875b316_3225]
   as 
    
    
    



select product_name
from "RetailDB"."bronze"."int_return_transaction"
where product_name is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_b3698707793d4d4b3dafe4fcd875b316_3225]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_b3698707793d4d4b3dafe4fcd875b316_3225]
  ;')