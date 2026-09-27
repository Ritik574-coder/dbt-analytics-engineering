
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_1dfb863feb84512558855d6328279c14_10683]
   as 
    
    
    



select review_id
from "RetailDB"."bronze"."int_review_rating"
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
    [bronze].[testview_1dfb863feb84512558855d6328279c14_10683]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_1dfb863feb84512558855d6328279c14_10683]
  ;')