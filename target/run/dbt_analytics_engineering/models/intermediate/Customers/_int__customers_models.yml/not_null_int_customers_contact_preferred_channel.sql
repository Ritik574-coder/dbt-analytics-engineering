
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_3222e126a8cb65bd840f33b0a9952c43_16563]
   as 
    
    
    



select preferred_channel
from "RetailDB"."bronze"."int_customers_contact"
where preferred_channel is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_3222e126a8cb65bd840f33b0a9952c43_16563]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_3222e126a8cb65bd840f33b0a9952c43_16563]
  ;')