
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_87dc0204fdbd3289b8338995fcbc8784_15955]
   as 
    
    
    



select review_id
from "RetailDB"."bronze"."int_review_feedback"
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
    [bronze].[testview_87dc0204fdbd3289b8338995fcbc8784_15955]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_87dc0204fdbd3289b8338995fcbc8784_15955]
  ;')