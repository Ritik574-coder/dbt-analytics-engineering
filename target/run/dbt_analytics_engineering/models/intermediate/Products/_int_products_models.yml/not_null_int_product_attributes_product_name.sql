
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_5d42f92f196b2696ddd8d00a65af10f4_1486]
   as 
    
    
    



select product_name
from "RetailDB"."bronze"."int_product_attributes"
where product_name is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_5d42f92f196b2696ddd8d00a65af10f4_1486]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_5d42f92f196b2696ddd8d00a65af10f4_1486]
  ;')