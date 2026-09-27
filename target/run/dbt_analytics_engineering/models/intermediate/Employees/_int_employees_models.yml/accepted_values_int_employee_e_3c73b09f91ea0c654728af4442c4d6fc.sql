
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_2bceb98ba9b54cb9d6506fee840ca95a_17253]
   as 
    
    
    

with all_values as (

    select
        department as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_employee_employment"
    group by department

)

select *
from all_values
where value_field not in (
    ''Customer Service'',''Management'',''Operations'',''Sales'',''Unknown''
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
    [bronze].[testview_2bceb98ba9b54cb9d6506fee840ca95a_17253]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_2bceb98ba9b54cb9d6506fee840ca95a_17253]
  ;')