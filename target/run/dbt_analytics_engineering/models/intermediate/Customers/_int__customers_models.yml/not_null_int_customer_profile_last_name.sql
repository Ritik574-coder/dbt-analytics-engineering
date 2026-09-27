
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_40aa02b17af28292f7a8e69b81dc9a0f_9039]
   as 
    
    
    



select last_name
from "RetailDB"."bronze"."int_customer_profile"
where last_name is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_40aa02b17af28292f7a8e69b81dc9a0f_9039]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_40aa02b17af28292f7a8e69b81dc9a0f_9039]
  ;')