
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_e8a48b6b7dce1dc9b9ef228ce214eb7e_1633]
   as 
    
    
    



select brand
from "RetailDB"."bronze"."int_product_attributes"
where brand is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_e8a48b6b7dce1dc9b9ef228ce214eb7e_1633]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_e8a48b6b7dce1dc9b9ef228ce214eb7e_1633]
  ;')