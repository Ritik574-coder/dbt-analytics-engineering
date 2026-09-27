
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_47bee29180561ea38c17faf8dabf233a_14909]
   as 
    
    
    



select review_channel
from "RetailDB"."bronze"."int_review_feedback"
where review_channel is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_47bee29180561ea38c17faf8dabf233a_14909]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_47bee29180561ea38c17faf8dabf233a_14909]
  ;')