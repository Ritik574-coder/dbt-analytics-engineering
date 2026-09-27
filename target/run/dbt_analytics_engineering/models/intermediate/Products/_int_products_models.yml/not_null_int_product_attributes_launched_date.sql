
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_c638e7831ed50bf9c949d3d6bf589e1f_18122]
   as 
    
    
    



select launched_date
from "RetailDB"."bronze"."int_product_attributes"
where launched_date is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_c638e7831ed50bf9c949d3d6bf589e1f_18122]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_c638e7831ed50bf9c949d3d6bf589e1f_18122]
  ;')