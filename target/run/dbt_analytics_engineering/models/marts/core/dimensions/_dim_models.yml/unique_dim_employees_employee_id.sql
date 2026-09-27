
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_457547c2c5d056f0106582524b0d2206_11051]
   as 
    
    
    

select
    employee_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."dim_employees"
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
    [bronze].[testview_457547c2c5d056f0106582524b0d2206_11051]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_457547c2c5d056f0106582524b0d2206_11051]
  ;')