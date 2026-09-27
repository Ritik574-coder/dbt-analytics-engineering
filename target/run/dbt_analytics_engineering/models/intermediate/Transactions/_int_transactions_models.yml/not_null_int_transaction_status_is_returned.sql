
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_de9f824f81e93fbaf0eb6d3d9c1f87b1_14534]
   as 
    
    
    



select is_returned
from "RetailDB"."bronze"."int_transaction_status"
where is_returned is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_de9f824f81e93fbaf0eb6d3d9c1f87b1_14534]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_de9f824f81e93fbaf0eb6d3d9c1f87b1_14534]
  ;')