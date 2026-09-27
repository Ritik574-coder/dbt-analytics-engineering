
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_d63d61a4932c3c9aabbd33f28d0bd698_14332]
   as 
    
    
    



select return_channel
from "RetailDB"."bronze"."int_return_processing"
where return_channel is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_d63d61a4932c3c9aabbd33f28d0bd698_14332]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_d63d61a4932c3c9aabbd33f28d0bd698_14332]
  ;')