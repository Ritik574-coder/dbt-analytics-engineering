
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_53d810dc6f571d49521505151e3aae96_12189]
   as 
    
    
    



select product_name
from "RetailDB"."bronze"."int_inventory_product"
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
    [bronze].[testview_53d810dc6f571d49521505151e3aae96_12189]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_53d810dc6f571d49521505151e3aae96_12189]
  ;')