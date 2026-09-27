
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_f44054b1ff4ac6c90cbe7ae3cafaa25f_12936]
   as 
    
    
    



select state
from "RetailDB"."bronze"."int_customer_location"
where state is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_f44054b1ff4ac6c90cbe7ae3cafaa25f_12936]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_f44054b1ff4ac6c90cbe7ae3cafaa25f_12936]
  ;')