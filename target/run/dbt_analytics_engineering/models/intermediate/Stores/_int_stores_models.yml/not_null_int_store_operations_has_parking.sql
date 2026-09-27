
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_255ad621416db7bc344518b7cfe89f11_12758]
   as 
    
    
    



select has_parking
from "RetailDB"."bronze"."int_store_operations"
where has_parking is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_255ad621416db7bc344518b7cfe89f11_12758]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_255ad621416db7bc344518b7cfe89f11_12758]
  ;')