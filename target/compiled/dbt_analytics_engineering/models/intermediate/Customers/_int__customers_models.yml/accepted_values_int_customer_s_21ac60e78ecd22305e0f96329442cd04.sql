
    
    

with all_values as (

    select
        is_active as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customer_segmentation"
    group by is_active

)

select *
from all_values
where value_field not in (
    'True','False','Unknown'
)


