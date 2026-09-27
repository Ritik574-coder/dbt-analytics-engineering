
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_e278cde6220d956d646f0ca2799060a9_11485]
   as 
    
    
    



select customer_id
from "RetailDB"."bronze"."stg_customers"
where customer_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_e278cde6220d956d646f0ca2799060a9_11485]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_e278cde6220d956d646f0ca2799060a9_11485]
  ;')