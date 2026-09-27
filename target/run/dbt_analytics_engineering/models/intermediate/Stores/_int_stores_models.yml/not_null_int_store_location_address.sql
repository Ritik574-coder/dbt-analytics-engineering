
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_e0aefa506e90ab8ab0290dafd74a4f2e_3635]
   as 
    
    
    



select address
from "RetailDB"."bronze"."int_store_location"
where address is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_e0aefa506e90ab8ab0290dafd74a4f2e_3635]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_e0aefa506e90ab8ab0290dafd74a4f2e_3635]
  ;')