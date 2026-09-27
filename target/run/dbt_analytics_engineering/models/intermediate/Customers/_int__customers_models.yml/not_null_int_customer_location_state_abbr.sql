
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_aa43af34375282406ff246813004b6cc_14260]
   as 
    
    
    



select state_abbr
from "RetailDB"."bronze"."int_customer_location"
where state_abbr is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_aa43af34375282406ff246813004b6cc_14260]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_aa43af34375282406ff246813004b6cc_14260]
  ;')