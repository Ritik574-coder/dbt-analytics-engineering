
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_0e9170293b5f381f4d8ab89f7c35d678_2975]
   as 
    
    
    



select promo_name
from "RetailDB"."bronze"."int_transaction_status"
where promo_name is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_0e9170293b5f381f4d8ab89f7c35d678_2975]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_0e9170293b5f381f4d8ab89f7c35d678_2975]
  ;')