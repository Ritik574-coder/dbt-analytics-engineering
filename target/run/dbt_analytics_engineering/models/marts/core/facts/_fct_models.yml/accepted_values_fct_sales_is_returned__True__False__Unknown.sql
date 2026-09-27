
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_7653eacc5a92fa15b00cea7e31376adf_14923]
   as 
    
    
    

with all_values as (

    select
        is_returned as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."fct_sales"
    group by is_returned

)

select *
from all_values
where value_field not in (
    ''True'',''False'',''Unknown''
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
    [bronze].[testview_7653eacc5a92fa15b00cea7e31376adf_14923]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_7653eacc5a92fa15b00cea7e31376adf_14923]
  ;')