
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_a76db9c12d3302a0249c5881df80af3d_1366]
   as 
    
    
    



select product_id
from "RetailDB"."bronze"."stg_inventory"
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
    [bronze].[testview_a76db9c12d3302a0249c5881df80af3d_1366]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_a76db9c12d3302a0249c5881df80af3d_1366]
  ;')