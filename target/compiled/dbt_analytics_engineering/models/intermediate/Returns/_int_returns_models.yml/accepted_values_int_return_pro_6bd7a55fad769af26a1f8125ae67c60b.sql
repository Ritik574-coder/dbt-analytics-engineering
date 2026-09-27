
    
    

with all_values as (

    select
        restocked as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_return_processing"
    group by restocked

)

select *
from all_values
where value_field not in (
    'Yes','No','Unknown'
)


