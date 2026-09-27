
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_6f9778b5b079997e9d9feb537b52faae_7611]
   as 
    
    
    



select store_id
from "RetailDB"."bronze"."int_store_profile"
where store_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_6f9778b5b079997e9d9feb537b52faae_7611]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_6f9778b5b079997e9d9feb537b52faae_7611]
  ;')