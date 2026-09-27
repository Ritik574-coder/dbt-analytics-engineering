
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_0a420f23f1751fbd8e6a4d27bef95ba3_4332]
   as 
    
    
    

select
    return_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_return_processing"
where return_id is not null
group by return_id
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
    [bronze].[testview_0a420f23f1751fbd8e6a4d27bef95ba3_4332]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_0a420f23f1751fbd8e6a4d27bef95ba3_4332]
  ;')