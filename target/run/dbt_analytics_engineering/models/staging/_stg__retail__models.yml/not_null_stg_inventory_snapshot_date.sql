
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_6cdf786e8b52f8471253323cf36ee27d_3311]
   as 
    
    
    



select snapshot_date
from "RetailDB"."bronze"."stg_inventory"
where snapshot_date is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_6cdf786e8b52f8471253323cf36ee27d_3311]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_6cdf786e8b52f8471253323cf36ee27d_3311]
  ;')