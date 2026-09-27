
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_b2c2a6cb21631be04f3326ae40e854b1_14660]
   as 
    
    
    



select gender
from "RetailDB"."bronze"."int_customer_profile"
where gender is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_b2c2a6cb21631be04f3326ae40e854b1_14660]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_b2c2a6cb21631be04f3326ae40e854b1_14660]
  ;')