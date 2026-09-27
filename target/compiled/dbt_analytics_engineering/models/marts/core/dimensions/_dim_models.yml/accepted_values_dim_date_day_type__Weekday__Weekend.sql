
    
    

with all_values as (

    select
        day_type as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."dim_date"
    group by day_type

)

select *
from all_values
where value_field not in (
    'Weekday','Weekend'
)


