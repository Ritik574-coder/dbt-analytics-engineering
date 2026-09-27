
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_4f66223b636e21ed98b5dafb116e8318_4878]
   as 
    
    
    



select customer_id
from "RetailDB"."bronze"."dim_customers"
where customer_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_4f66223b636e21ed98b5dafb116e8318_4878]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_4f66223b636e21ed98b5dafb116e8318_4878]
  ;')