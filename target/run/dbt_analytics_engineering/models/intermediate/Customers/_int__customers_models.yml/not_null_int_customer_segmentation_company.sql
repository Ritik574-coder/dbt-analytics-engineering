
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_030fca3c2ded2abbda113a0a9f3e9b9b_11911]
   as 
    
    
    



select company
from "RetailDB"."bronze"."int_customer_segmentation"
where company is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_030fca3c2ded2abbda113a0a9f3e9b9b_11911]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_030fca3c2ded2abbda113a0a9f3e9b9b_11911]
  ;')