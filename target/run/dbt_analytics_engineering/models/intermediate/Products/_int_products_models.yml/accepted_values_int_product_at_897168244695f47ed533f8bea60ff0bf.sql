
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_2083b38443f8da3110c72c24c4247815_9309]
   as 
    
    
    

with all_values as (

    select
        department as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_product_attributes"
    group by department

)

select *
from all_values
where value_field not in (
    ''Apparel & Sports'',''Books & Office'',''Fitness & Outdoors'',''Health & Beauty'',''Home & Garden'',''Technology'',''Toys & Games''
)



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_2083b38443f8da3110c72c24c4247815_9309]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_2083b38443f8da3110c72c24c4247815_9309]
  ;')