
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_aae1e1ca43896b65f1d1251ca799cf90_4619]
   as 
    
    
    



select txn_id
from "RetailDB"."bronze"."int_review_transaction"
where txn_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_aae1e1ca43896b65f1d1251ca799cf90_4619]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_aae1e1ca43896b65f1d1251ca799cf90_4619]
  ;')