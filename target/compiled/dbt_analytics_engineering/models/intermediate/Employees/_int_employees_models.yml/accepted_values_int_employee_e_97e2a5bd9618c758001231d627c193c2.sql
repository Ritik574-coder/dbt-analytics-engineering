
    
    

with all_values as (

    select
        performance_rating as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_employee_employment"
    group by performance_rating

)

select *
from all_values
where value_field not in (
    'Excellent','Good','Average','Below Average','Unknown'
)


