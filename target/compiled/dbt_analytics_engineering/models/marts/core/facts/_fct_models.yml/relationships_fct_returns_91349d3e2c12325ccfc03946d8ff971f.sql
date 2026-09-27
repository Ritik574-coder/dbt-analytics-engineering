
    
    

with child as (
    select handled_by_emp_id as from_field
    from "RetailDB"."bronze"."fct_returns"
    where handled_by_emp_id is not null
),

parent as (
    select employee_id as to_field
    from "RetailDB"."bronze"."dim_employees"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


