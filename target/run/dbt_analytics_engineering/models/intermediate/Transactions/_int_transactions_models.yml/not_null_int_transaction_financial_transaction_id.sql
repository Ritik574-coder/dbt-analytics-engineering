
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_f3ee3482612ef56fdf129f1a2b699f0b_14422]
   as 
    
    
    



select transaction_id
from "RetailDB"."bronze"."int_transaction_financial"
where transaction_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_f3ee3482612ef56fdf129f1a2b699f0b_14422]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_f3ee3482612ef56fdf129f1a2b699f0b_14422]
  ;')