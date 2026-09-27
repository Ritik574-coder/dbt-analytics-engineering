
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_dea158c8e73949d9483e4427f3cabbdb_2399]
   as 
    
    
    

select
    sku as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_product_attributes"
where sku is not null
group by sku
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
    [bronze].[testview_dea158c8e73949d9483e4427f3cabbdb_2399]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_dea158c8e73949d9483e4427f3cabbdb_2399]
  ;')