
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_ce1b50ce25f22d7042872659f8dfe41c_2091]
   as 
    
    
    



select country
from "RetailDB"."bronze"."int_customer_location"
where country is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_ce1b50ce25f22d7042872659f8dfe41c_2091]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_ce1b50ce25f22d7042872659f8dfe41c_2091]
  ;')