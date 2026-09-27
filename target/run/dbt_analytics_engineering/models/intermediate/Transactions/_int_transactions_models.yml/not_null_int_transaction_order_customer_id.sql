
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_3bfbc564f5cf2a867ba2c1028f5f99df_9637]
   as 
    
    
    



select customer_id
from "RetailDB"."bronze"."int_transaction_order"
where customer_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_3bfbc564f5cf2a867ba2c1028f5f99df_9637]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_3bfbc564f5cf2a867ba2c1028f5f99df_9637]
  ;')