
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_d4ae53b7bcdaddbca1300784f1ff339c_6159]
   as 
    
    
    



select order_date
from "RetailDB"."bronze"."int_transaction_fulfillment"
where order_date is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_d4ae53b7bcdaddbca1300784f1ff339c_6159]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_d4ae53b7bcdaddbca1300784f1ff339c_6159]
  ;')