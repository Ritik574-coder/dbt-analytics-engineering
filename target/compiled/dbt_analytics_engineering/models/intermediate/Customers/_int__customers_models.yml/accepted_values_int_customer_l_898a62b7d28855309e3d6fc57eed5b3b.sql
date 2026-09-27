
    
    

with all_values as (

    select
        country as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customer_location"
    group by country

)

select *
from all_values
where value_field not in (
    'United States','Unknown'
)


