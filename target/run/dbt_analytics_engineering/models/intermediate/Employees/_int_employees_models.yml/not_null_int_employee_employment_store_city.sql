
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_d470aeb7368a1565611d218fb11db17d_9522]
   as 
    
    
    



select store_city
from "RetailDB"."bronze"."int_employee_employment"
where store_city is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_d470aeb7368a1565611d218fb11db17d_9522]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_d470aeb7368a1565611d218fb11db17d_9522]
  ;')