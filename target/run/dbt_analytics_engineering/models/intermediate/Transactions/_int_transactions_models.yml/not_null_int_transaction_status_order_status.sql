
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_61868354251f30846c029e9ff783a18d_16775]
   as 
    
    
    



select order_status
from "RetailDB"."bronze"."int_transaction_status"
where order_status is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_61868354251f30846c029e9ff783a18d_16775]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_61868354251f30846c029e9ff783a18d_16775]
  ;')