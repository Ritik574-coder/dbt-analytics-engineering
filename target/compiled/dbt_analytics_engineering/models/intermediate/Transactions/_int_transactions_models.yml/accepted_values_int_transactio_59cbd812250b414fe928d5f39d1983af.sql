
    
    

with all_values as (

    select
        is_returned as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_transaction_status"
    group by is_returned

)

select *
from all_values
where value_field not in (
    'True','False','Unknown'
)


