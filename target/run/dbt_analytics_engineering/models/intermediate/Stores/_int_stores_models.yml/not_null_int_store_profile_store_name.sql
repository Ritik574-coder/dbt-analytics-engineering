
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_e1ae6f76244f063ef828ad655ef44268_9731]
   as 
    
    
    



select store_name
from "RetailDB"."bronze"."int_store_profile"
where store_name is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_e1ae6f76244f063ef828ad655ef44268_9731]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_e1ae6f76244f063ef828ad655ef44268_9731]
  ;')