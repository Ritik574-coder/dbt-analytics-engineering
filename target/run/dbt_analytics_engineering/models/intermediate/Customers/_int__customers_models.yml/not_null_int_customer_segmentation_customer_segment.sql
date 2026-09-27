
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_83dd097b849ae2e91786a33fee0a59f3_18210]
   as 
    
    
    



select customer_segment
from "RetailDB"."bronze"."int_customer_segmentation"
where customer_segment is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_83dd097b849ae2e91786a33fee0a59f3_18210]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_83dd097b849ae2e91786a33fee0a59f3_18210]
  ;')