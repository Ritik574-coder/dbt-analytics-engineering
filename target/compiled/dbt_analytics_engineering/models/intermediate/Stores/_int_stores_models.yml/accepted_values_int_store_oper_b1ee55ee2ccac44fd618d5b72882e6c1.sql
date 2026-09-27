
    
    

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
    'True','False','Unknown'
)


