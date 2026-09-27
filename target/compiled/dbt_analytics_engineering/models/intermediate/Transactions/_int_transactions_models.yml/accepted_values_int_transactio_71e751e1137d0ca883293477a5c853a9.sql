
    
    

with all_values as (

    select
        order_status as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_transaction_status"
    group by order_status

)

select *
from all_values
where value_field not in (
    'Pending','Processing','Shipped','Delivered','Returned','Cancelled'
)


