
    
    

with all_values as (

    select
        customer_segment as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customer_segmentation"
    group by customer_segment

)

select *
from all_values
where value_field not in (
    'Bronze','Silver','Gold','Platinum','Unknown'
)


