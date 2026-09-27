
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_f99cac03ca59bb30b6728c46ed024188_13508]
   as 
    
    
    



select helpful_votes
from "RetailDB"."bronze"."int_review_feedback"
where helpful_votes is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_f99cac03ca59bb30b6728c46ed024188_13508]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_f99cac03ca59bb30b6728c46ed024188_13508]
  ;')