
    
    

with all_values as (

    select
        category as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_product_attributes"
    group by category

)

select *
from all_values
where value_field not in (
    'Bags','Beauty','Clothing','Electronics','Footwear','Health','Kitchen','Office','Sports','Toys'
)


