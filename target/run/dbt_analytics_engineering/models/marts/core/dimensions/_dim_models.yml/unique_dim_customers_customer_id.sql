
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_0e3814641ee2044f02b324e4ee8a6aa7_8624]
   as 
    
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."dim_customers"
where customer_id is not null
group by customer_id
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
    [bronze].[testview_0e3814641ee2044f02b324e4ee8a6aa7_8624]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_0e3814641ee2044f02b324e4ee8a6aa7_8624]
  ;')