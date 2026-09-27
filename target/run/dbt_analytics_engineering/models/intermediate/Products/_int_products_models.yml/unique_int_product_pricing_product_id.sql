
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_e539b5560bbe3dd1deb1c6abdbaebece_12669]
   as 
    
    
    

select
    product_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_product_pricing"
where product_id is not null
group by product_id
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
    [bronze].[testview_e539b5560bbe3dd1deb1c6abdbaebece_12669]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_e539b5560bbe3dd1deb1c6abdbaebece_12669]
  ;')