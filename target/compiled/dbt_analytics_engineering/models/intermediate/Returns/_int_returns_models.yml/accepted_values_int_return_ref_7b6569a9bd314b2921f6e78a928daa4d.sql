
    
    

with all_values as (

    select
        refund_method as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_return_refund"
    group by refund_method

)

select *
from all_values
where value_field not in (
    'Cash','Original Payment','Store Credit'
)


