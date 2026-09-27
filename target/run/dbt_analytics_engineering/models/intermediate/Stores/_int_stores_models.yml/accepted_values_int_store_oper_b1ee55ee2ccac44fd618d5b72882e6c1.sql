
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_1e3e76568a3f52dc07f49af5cd00e4ec_4041]
   as 
    
    
    

with all_values as (

    select
        has_cafe as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_store_operations"
    group by has_cafe

)

select *
from all_values
where value_field not in (
    ''True'',''False'',''Unknown''
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
    [bronze].[testview_1e3e76568a3f52dc07f49af5cd00e4ec_4041]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_1e3e76568a3f52dc07f49af5cd00e4ec_4041]
  ;')