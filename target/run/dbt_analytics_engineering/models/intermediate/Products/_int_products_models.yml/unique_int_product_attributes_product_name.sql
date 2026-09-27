
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_6a7f613207c7d59e1f90b6fa502e24c6_10129]
   as 
    
    
    

select
    product_name as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_product_attributes"
where product_name is not null
group by product_name
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
    [bronze].[testview_6a7f613207c7d59e1f90b6fa502e24c6_10129]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_6a7f613207c7d59e1f90b6fa502e24c6_10129]
  ;')