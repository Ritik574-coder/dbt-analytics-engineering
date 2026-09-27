
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_14321c710060eec1e0186335589c0575_14548]
   as 
    
    
    



select snapshot_date
from "RetailDB"."bronze"."int_inventory_product"
where snapshot_date is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_14321c710060eec1e0186335589c0575_14548]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_14321c710060eec1e0186335589c0575_14548]
  ;')