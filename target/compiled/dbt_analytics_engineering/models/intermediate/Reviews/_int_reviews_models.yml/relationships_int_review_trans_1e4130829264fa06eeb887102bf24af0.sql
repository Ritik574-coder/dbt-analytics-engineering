
    
    

with child as (
    select review_id as from_field
    from "RetailDB"."bronze"."int_review_transaction"
    where review_id is not null
),

parent as (
    select review_id as to_field
    from "RetailDB"."bronze"."int_review_feedback"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


