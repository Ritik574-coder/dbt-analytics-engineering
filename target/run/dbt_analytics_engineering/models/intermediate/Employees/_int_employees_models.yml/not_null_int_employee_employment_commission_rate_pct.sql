
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_b6064928ebe535392d7d73b8b3264ccc_14362]
   as 
    
    
    



select commission_rate_pct
from "RetailDB"."bronze"."int_employee_employment"
where commission_rate_pct is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_b6064928ebe535392d7d73b8b3264ccc_14362]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_b6064928ebe535392d7d73b8b3264ccc_14362]
  ;')