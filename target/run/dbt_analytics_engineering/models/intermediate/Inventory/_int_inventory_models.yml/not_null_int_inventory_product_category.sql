
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_39b3fe474196ec4386572cfef8dbead3_3031]
   as 
    
    
    



select category
from "RetailDB"."bronze"."int_inventory_product"
where category is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_39b3fe474196ec4386572cfef8dbead3_3031]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_39b3fe474196ec4386572cfef8dbead3_3031]
  ;')