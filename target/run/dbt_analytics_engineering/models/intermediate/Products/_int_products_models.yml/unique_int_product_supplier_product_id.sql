
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_493bd2f2e6a04f7beec3136138675d5d_3928]
   as 
    
    
    

select
    product_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_product_supplier"
where product_id is not null
group by product_id
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
    [bronze].[testview_493bd2f2e6a04f7beec3136138675d5d_3928]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_493bd2f2e6a04f7beec3136138675d5d_3928]
  ;')