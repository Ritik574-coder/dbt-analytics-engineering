
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_1eee88db4c3e5e8d69181b5c4933f12e_3474]
   as 
    
    
    



select country
from "RetailDB"."bronze"."int_store_location"
where country is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_1eee88db4c3e5e8d69181b5c4933f12e_3474]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_1eee88db4c3e5e8d69181b5c4933f12e_3474]
  ;')