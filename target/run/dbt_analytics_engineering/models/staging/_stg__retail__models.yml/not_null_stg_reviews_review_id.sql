
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_01e244abb8640bea664cfba4b4367f97_14637]
   as 
    
    
    



select review_id
from "RetailDB"."bronze"."stg_reviews"
where review_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_01e244abb8640bea664cfba4b4367f97_14637]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_01e244abb8640bea664cfba4b4367f97_14637]
  ;')