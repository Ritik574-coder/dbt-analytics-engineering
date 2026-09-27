
    
    

with all_values as (

    select
        is_available as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_product_inventory"
    group by is_available

)

select *
from all_values
where value_field not in (
    'Available','Not Available','Discontinued','Unknown'
)


