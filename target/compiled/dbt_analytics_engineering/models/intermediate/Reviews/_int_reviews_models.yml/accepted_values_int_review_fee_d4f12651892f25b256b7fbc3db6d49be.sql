
    
    

with all_values as (

    select
        review_channel as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_review_feedback"
    group by review_channel

)

select *
from all_values
where value_field not in (
    'Mobile App','In Store','Online','Phone Call','Catalog','Unknown'
)


