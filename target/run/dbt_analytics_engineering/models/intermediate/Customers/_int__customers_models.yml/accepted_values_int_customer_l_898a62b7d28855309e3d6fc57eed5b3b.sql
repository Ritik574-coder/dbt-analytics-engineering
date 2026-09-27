
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_e855ff9e18667c9cc170f24eb1620e9f_10088]
   as 
    
    
    

with all_values as (

    select
        country as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customer_location"
    group by country

)

select *
from all_values
where value_field not in (
    ''United States'',''Unknown''
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
    [bronze].[testview_e855ff9e18667c9cc170f24eb1620e9f_10088]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_e855ff9e18667c9cc170f24eb1620e9f_10088]
  ;')