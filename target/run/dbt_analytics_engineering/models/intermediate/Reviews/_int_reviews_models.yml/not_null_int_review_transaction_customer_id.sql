
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_8ee09d7990a28f27e40d679c4df6c315_4627]
   as 
    
    
    



select customer_id
from "RetailDB"."bronze"."int_review_transaction"
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
    [bronze].[testview_8ee09d7990a28f27e40d679c4df6c315_4627]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_8ee09d7990a28f27e40d679c4df6c315_4627]
  ;')