
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_2db3a6a7bc322de59daa692b5ce851c1_13540]
   as 
    
    
    



select sub_category
from "RetailDB"."bronze"."int_product_attributes"
where sub_category is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_2db3a6a7bc322de59daa692b5ce851c1_13540]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_2db3a6a7bc322de59daa692b5ce851c1_13540]
  ;')