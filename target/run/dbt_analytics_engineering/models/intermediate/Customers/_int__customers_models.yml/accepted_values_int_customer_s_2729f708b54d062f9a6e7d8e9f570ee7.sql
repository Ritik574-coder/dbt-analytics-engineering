
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_0670ac43ce3d30a7412ddd5eac318562_9587]
   as 
    
    
    

with all_values as (

    select
        customer_segment as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customer_segmentation"
    group by customer_segment

)

select *
from all_values
where value_field not in (
    ''Bronze'',''Silver'',''Gold'',''Platinum'',''Unknown''
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
    [bronze].[testview_0670ac43ce3d30a7412ddd5eac318562_9587]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_0670ac43ce3d30a7412ddd5eac318562_9587]
  ;')