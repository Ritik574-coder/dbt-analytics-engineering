
    
    

with all_values as (

    select
        is_reorder_needed as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."fct_inventory_snapshot"
    group by is_reorder_needed

)

select *
from all_values
where value_field not in (
    'Yes','No','Unknown'
)


