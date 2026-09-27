
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_4701d8da399d32ccd3a7390107f6d8bd_12891]
   as 
    
    
    



select return_status
from "RetailDB"."bronze"."int_return_processing"
where return_status is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_4701d8da399d32ccd3a7390107f6d8bd_12891]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_4701d8da399d32ccd3a7390107f6d8bd_12891]
  ;')