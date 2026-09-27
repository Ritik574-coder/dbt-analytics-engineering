
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_fdc26d029920637b4fe01bfabfe3720a_12259]
   as 
    
    
    

with all_values as (

    select
        order_status as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_transaction_status"
    group by order_status

)

select *
from all_values
where value_field not in (
    ''Pending'',''Processing'',''Shipped'',''Delivered'',''Returned'',''Cancelled''
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
    [bronze].[testview_fdc26d029920637b4fe01bfabfe3720a_12259]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_fdc26d029920637b4fe01bfabfe3720a_12259]
  ;')