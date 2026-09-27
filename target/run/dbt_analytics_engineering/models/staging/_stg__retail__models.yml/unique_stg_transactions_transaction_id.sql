
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_1175759e0bb4ed1581ca5c86d02d2ef0_17232]
   as 
    
    
    

select
    transaction_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."stg_transactions"
where transaction_id is not null
group by transaction_id
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
    [bronze].[testview_1175759e0bb4ed1581ca5c86d02d2ef0_17232]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_1175759e0bb4ed1581ca5c86d02d2ef0_17232]
  ;')