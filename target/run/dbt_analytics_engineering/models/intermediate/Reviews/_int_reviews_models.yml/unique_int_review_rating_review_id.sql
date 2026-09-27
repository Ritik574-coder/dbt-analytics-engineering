
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_3f907bb6a2ed0a3ef0bb855ea2e81451_3412]
   as 
    
    
    

select
    review_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_review_rating"
where review_id is not null
group by review_id
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
    [bronze].[testview_3f907bb6a2ed0a3ef0bb855ea2e81451_3412]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_3f907bb6a2ed0a3ef0bb855ea2e81451_3412]
  ;')