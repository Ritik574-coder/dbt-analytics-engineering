
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_eee567e52678dc8c5c826b219df3eeaf_6100]
   as 
    
    
    

select
    inventory_snapshot_sk as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."fct_inventory_snapshot"
where inventory_snapshot_sk is not null
group by inventory_snapshot_sk
having count(*) > 1



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_eee567e52678dc8c5c826b219df3eeaf_6100]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_eee567e52678dc8c5c826b219df3eeaf_6100]
  ;')