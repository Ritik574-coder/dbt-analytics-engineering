
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_a4b4beccde243c66e904dd9c9c629282_11466]
   as 
    
    
    



select review_id
from "RetailDB"."bronze"."int_review_transaction"
where review_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_a4b4beccde243c66e904dd9c9c629282_11466]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_a4b4beccde243c66e904dd9c9c629282_11466]
  ;')