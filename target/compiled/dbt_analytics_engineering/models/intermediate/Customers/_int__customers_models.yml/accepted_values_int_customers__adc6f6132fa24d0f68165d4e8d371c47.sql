
    
    

with all_values as (

    select
        preferred_channel as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customers_contact"
    group by preferred_channel

)

select *
from all_values
where value_field not in (
    'Mobile App','In Store','Catalog','Website','Phone Call','Unknown'
)


