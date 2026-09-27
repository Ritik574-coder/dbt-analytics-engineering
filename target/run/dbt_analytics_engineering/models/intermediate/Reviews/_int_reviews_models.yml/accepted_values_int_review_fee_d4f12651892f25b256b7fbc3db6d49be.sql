
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_6c81532c9922547e39d4c9c7754298ec_10905]
   as 
    
    
    

with all_values as (

    select
        review_channel as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_review_feedback"
    group by review_channel

)

select *
from all_values
where value_field not in (
    ''Mobile App'',''In Store'',''Online'',''Phone Call'',''Catalog'',''Unknown''
)



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_6c81532c9922547e39d4c9c7754298ec_10905]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_6c81532c9922547e39d4c9c7754298ec_10905]
  ;')