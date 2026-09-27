
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_3bfcdff6bd0f291458b56f99b3698928_6209]
   as 
    
    
    



select is_active
from "RetailDB"."bronze"."int_customer_segmentation"
where is_active is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_3bfcdff6bd0f291458b56f99b3698928_6209]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_3bfcdff6bd0f291458b56f99b3698928_6209]
  ;')