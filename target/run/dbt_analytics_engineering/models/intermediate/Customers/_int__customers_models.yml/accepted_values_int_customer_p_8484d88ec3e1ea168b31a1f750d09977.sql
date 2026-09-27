
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_a2710fd926020818cc6edc4642aa4eff_6551]
   as 
    
    
    

with all_values as (

    select
        gender as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customer_profile"
    group by gender

)

select *
from all_values
where value_field not in (
    ''Male'',''Female'',''Non-Binary'',''Other'',''Unknown''
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
    [bronze].[testview_a2710fd926020818cc6edc4642aa4eff_6551]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_a2710fd926020818cc6edc4642aa4eff_6551]
  ;')