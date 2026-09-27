
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_1459a3f3833c39d4b4949aa20d3eb4aa_3669]
   as 
    
    
    



select has_cafe
from "RetailDB"."bronze"."int_store_operations"
where has_cafe is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_1459a3f3833c39d4b4949aa20d3eb4aa_3669]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_1459a3f3833c39d4b4949aa20d3eb4aa_3669]
  ;')