
    
    

with all_values as (

    select
        department as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_employee_employment"
    group by department

)

select *
from all_values
where value_field not in (
    'Customer Service','Management','Operations','Sales','Unknown'
)


