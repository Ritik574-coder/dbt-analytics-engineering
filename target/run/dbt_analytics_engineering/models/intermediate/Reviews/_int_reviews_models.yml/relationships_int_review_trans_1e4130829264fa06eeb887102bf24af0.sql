
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_28c9d997e7b1b3002d783ad611bd4d5d_2848]
   as 
    
    
    

with child as (
    select review_id as from_field
    from "RetailDB"."bronze"."int_review_transaction"
    where review_id is not null
),

parent as (
    select review_id as to_field
    from "RetailDB"."bronze"."int_review_feedback"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_28c9d997e7b1b3002d783ad611bd4d5d_2848]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_28c9d997e7b1b3002d783ad611bd4d5d_2848]
  ;')