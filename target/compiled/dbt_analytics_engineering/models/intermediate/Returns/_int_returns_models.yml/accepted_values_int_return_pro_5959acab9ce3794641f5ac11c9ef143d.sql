
    
    

with all_values as (

    select
        return_channel as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_return_processing"
    group by return_channel

)

select *
from all_values
where value_field not in (
    'Mobile App','In Store','Online','Phone Call','Catalog','Unknown'
)


