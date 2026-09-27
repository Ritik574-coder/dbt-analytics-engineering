
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_a1ada8d68c4d0d656759d2f8c27ff7b7_6782]
   as 
    
    
    

with all_values as (

    select
        performance_rating as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_employee_employment"
    group by performance_rating

)

select *
from all_values
where value_field not in (
    ''Excellent'',''Good'',''Average'',''Below Average'',''Unknown''
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
    [bronze].[testview_a1ada8d68c4d0d656759d2f8c27ff7b7_6782]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_a1ada8d68c4d0d656759d2f8c27ff7b7_6782]
  ;')