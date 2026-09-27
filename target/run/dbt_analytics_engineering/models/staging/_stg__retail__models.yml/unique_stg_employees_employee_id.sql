
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_bc296d09846753804307c7176eaf898f_1998]
   as 
    
    
    

select
    employee_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."stg_employees"
where employee_id is not null
group by employee_id
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
    [bronze].[testview_bc296d09846753804307c7176eaf898f_1998]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_bc296d09846753804307c7176eaf898f_1998]
  ;')