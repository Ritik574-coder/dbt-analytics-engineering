
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_01ae8e7afbb4a3fcc03c7f992f6b1968_6324]
   as 
    
    
    



select review_date
from "RetailDB"."bronze"."int_review_transaction"
where review_date is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_01ae8e7afbb4a3fcc03c7f992f6b1968_6324]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_01ae8e7afbb4a3fcc03c7f992f6b1968_6324]
  ;')