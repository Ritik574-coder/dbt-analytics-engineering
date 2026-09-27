
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_1c3f1e32c7fd4d15af046e17b31d04b9_3182]
   as 
    
    
    

with all_values as (

    select
        is_active as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_employee_employment"
    group by is_active

)

select *
from all_values
where value_field not in (
    ''True'',''False''
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
    [bronze].[testview_1c3f1e32c7fd4d15af046e17b31d04b9_3182]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_1c3f1e32c7fd4d15af046e17b31d04b9_3182]
  ;')