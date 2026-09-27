
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_644b84621c8d19951d6974c090d7ab05_6763]
   as 
    
    
    

with all_values as (

    select
        preferred_channel as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customers_contact"
    group by preferred_channel

)

select *
from all_values
where value_field not in (
    ''Mobile App'',''In Store'',''Catalog'',''Website'',''Phone Call'',''Unknown''
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
    [bronze].[testview_644b84621c8d19951d6974c090d7ab05_6763]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_644b84621c8d19951d6974c090d7ab05_6763]
  ;')