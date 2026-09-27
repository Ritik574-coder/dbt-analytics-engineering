
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_1c37c3473bfa761d8809fab2373eff1f_6074]
   as 
    
    
    



select product_id
from "RetailDB"."bronze"."int_product_pricing"
where product_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_1c37c3473bfa761d8809fab2373eff1f_6074]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_1c37c3473bfa761d8809fab2373eff1f_6074]
  ;')