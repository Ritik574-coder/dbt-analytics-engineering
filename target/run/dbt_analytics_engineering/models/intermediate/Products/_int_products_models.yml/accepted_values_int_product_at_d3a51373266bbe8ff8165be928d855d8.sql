
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_34295cf42755f3347be0327c9122b632_9584]
   as 
    
    
    

with all_values as (

    select
        category as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_product_attributes"
    group by category

)

select *
from all_values
where value_field not in (
    ''Bags'',''Beauty'',''Clothing'',''Electronics'',''Footwear'',''Health'',''Kitchen'',''Office'',''Sports'',''Toys''
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
    [bronze].[testview_34295cf42755f3347be0327c9122b632_9584]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_34295cf42755f3347be0327c9122b632_9584]
  ;')