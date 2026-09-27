
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_795443c5df9e3c0d6006a098f9724a46_17218]
   as 
    
    
    



select product_id
from "RetailDB"."bronze"."dim_products"
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
    [bronze].[testview_795443c5df9e3c0d6006a098f9724a46_17218]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_795443c5df9e3c0d6006a098f9724a46_17218]
  ;')