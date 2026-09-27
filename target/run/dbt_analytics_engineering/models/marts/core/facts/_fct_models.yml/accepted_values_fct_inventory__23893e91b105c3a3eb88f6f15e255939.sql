
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_3069796245d336a3dd9ff3d95f3700e9_3503]
   as 
    
    
    

with all_values as (

    select
        is_reorder_needed as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."fct_inventory_snapshot"
    group by is_reorder_needed

)

select *
from all_values
where value_field not in (
    ''Yes'',''No'',''Unknown''
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
    [bronze].[testview_3069796245d336a3dd9ff3d95f3700e9_3503]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_3069796245d336a3dd9ff3d95f3700e9_3503]
  ;')