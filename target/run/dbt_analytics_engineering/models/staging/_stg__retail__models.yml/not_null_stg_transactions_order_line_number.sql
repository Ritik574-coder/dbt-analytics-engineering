
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_463f110eb29e79e54c67323d61cc4a92_6361]
   as 
    
    
    



select order_line_number
from "RetailDB"."bronze"."stg_transactions"
where order_line_number is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_463f110eb29e79e54c67323d61cc4a92_6361]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_463f110eb29e79e54c67323d61cc4a92_6361]
  ;')