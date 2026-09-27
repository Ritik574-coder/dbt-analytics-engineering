
    
    

with all_values as (

    select
        gender as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_customer_profile"
    group by gender

)

select *
from all_values
where value_field not in (
    'Male','Female','Non-Binary','Other','Unknown'
)


