
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_8bf29ba65486a9868172cdd45176de77_8180]
   as 
    
    
    



select review_title
from "RetailDB"."bronze"."int_review_feedback"
where review_title is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_8bf29ba65486a9868172cdd45176de77_8180]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_8bf29ba65486a9868172cdd45176de77_8180]
  ;')