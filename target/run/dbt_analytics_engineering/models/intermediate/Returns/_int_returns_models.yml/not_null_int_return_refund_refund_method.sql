
    -- Create target schema if it does not
  USE [RetailDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
  BEGIN
    EXEC('CREATE SCHEMA [bronze]')
  END

  

  
  EXEC('create view 
    [bronze].[testview_04fb8b35ff51cef14196fe4a86cc8e3d_7370]
   as 
    
    
    



select refund_method
from "RetailDB"."bronze"."int_return_refund"
where refund_method is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [bronze].[testview_04fb8b35ff51cef14196fe4a86cc8e3d_7370]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [bronze].[testview_04fb8b35ff51cef14196fe4a86cc8e3d_7370]
  ;')