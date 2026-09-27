
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_9e081eefdc97e29e440e98074e93a409_17565]
   as 
    
    
    

with all_values as (

    select
        job_title as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_employee_employment"
    group by job_title

)

select *
from all_values
where value_field not in (
    ''Account Executive'',''Customer Advisor'',''Regional Manager'',''Sales Associate'',''Sales Consultant'',''Sales Manager'',''Sales Representative'',''Senior Sales Associate'',''Store Manager''
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
    [bronze].[testview_9e081eefdc97e29e440e98074e93a409_17565]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_9e081eefdc97e29e440e98074e93a409_17565]
  ;')