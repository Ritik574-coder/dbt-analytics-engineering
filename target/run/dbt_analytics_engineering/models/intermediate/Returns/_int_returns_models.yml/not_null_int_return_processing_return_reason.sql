
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_6e159989ab3b3a3b54339986cf2b31f0_1365]
   as 
    
    
    



select return_reason
from "RetailDB"."bronze"."int_return_processing"
where return_reason is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_6e159989ab3b3a3b54339986cf2b31f0_1365]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_6e159989ab3b3a3b54339986cf2b31f0_1365]
  ;')