
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_a474a2fa4e3f937d1d2ad7da017ec060_8243]
   as 
    
    
    



select region
from "RetailDB"."bronze"."int_customer_location"
where region is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_a474a2fa4e3f937d1d2ad7da017ec060_8243]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_a474a2fa4e3f937d1d2ad7da017ec060_8243]
  ;')