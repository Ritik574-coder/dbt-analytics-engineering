
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_b90abe8a6741b12ea65e74d235ad05ab_7198]
   as 
    
    
    

select
    inventory_snapshot_sk as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_inventory_product"
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
    [bronze].[testview_b90abe8a6741b12ea65e74d235ad05ab_7198]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_b90abe8a6741b12ea65e74d235ad05ab_7198]
  ;')