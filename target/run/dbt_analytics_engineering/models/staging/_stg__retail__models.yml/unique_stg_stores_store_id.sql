
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_bd0cd5a583a7e6752386250f5abedc1c_12716]
   as 
    
    
    

select
    store_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."stg_stores"
where store_id is not null
group by store_id
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
    [bronze].[testview_bd0cd5a583a7e6752386250f5abedc1c_12716]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_bd0cd5a583a7e6752386250f5abedc1c_12716]
  ;')