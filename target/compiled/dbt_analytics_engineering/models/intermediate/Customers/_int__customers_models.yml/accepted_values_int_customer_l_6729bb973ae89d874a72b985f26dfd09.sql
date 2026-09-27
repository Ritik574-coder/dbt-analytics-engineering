
    
    

with all_values as (

    select
        region as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customer_location"
    group by region

)

select *
from all_values
where value_field not in (
    'Midwest','Northeast','South','West'
)


