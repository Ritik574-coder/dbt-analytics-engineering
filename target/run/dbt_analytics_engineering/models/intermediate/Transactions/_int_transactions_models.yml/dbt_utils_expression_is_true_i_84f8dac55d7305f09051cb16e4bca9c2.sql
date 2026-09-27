
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_d08f0d69fdf6c6ca6455bfb0c8aa234c_16358]
   as 
    



select
    1
from "RetailDB"."bronze"."int_transaction_financial"

where not(quantity_ordered quantity_ordered >= 1 and quantity_ordered <= 30)


  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_d08f0d69fdf6c6ca6455bfb0c8aa234c_16358]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_d08f0d69fdf6c6ca6455bfb0c8aa234c_16358]
  ;')