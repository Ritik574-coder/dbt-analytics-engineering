
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_d546c20411539ef8576454e2a64e01ab_10397]
   as 
    
    
    

with all_values as (

    select
        rating as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_review_rating"
    group by rating

)

select *
from all_values
where value_field not in (
    ''1'',''2'',''3'',''4'',''5''
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
    [bronze].[testview_d546c20411539ef8576454e2a64e01ab_10397]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_d546c20411539ef8576454e2a64e01ab_10397]
  ;')