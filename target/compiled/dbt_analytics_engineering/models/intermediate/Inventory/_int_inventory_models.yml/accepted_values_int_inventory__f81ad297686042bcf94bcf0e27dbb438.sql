
    
    

with all_values as (

    select
        category as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_inventory_product"
    group by category

)

select *
from all_values
where value_field not in (
    'Electronics','Clothing','Kitchen','Office','Sports','Health','Beauty','Footwear','Toys','Bags','Unknown'
)


