
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_0e1ba299d57cca0a58c6f9358b78cf09_3874]
   as 
    
    
    



select email
from "RetailDB"."bronze"."int_customers_contact"
where email is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_0e1ba299d57cca0a58c6f9358b78cf09_3874]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_0e1ba299d57cca0a58c6f9358b78cf09_3874]
  ;')