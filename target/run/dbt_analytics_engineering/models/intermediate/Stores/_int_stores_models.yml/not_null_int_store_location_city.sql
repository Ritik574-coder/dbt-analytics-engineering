
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_108b288333cfb1b4848c53b8897e2b6e_3910]
   as 
    
    
    



select city
from "RetailDB"."bronze"."int_store_location"
where city is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_108b288333cfb1b4848c53b8897e2b6e_3910]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_108b288333cfb1b4848c53b8897e2b6e_3910]
  ;')