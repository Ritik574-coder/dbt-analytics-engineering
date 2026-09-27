
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_917f6794340b18473f452c4aada420cf_14107]
   as 
    
    
    

select
    store_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_store_profile"
where store_id is not null
group by store_id
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
    [bronze].[testview_917f6794340b18473f452c4aada420cf_14107]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_917f6794340b18473f452c4aada420cf_14107]
  ;')