
    
    

with child as (
    select store_id as from_field
    from "RetailDB"."bronze"."int_employee_employment"
    where store_id is not null
),

parent as (
    select store_id as to_field
    from "RetailDB"."bronze"."int_store_profile"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


