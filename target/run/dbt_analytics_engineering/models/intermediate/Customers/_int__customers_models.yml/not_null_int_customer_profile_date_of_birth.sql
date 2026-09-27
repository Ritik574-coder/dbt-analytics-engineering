
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_138c0de329baa08aad9d0a8d0525e67a_17952]
   as 
    
    
    



select date_of_birth
from "RetailDB"."bronze"."int_customer_profile"
where date_of_birth is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_138c0de329baa08aad9d0a8d0525e67a_17952]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_138c0de329baa08aad9d0a8d0525e67a_17952]
  ;')