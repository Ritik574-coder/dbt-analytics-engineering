
    
    

with all_values as (

    select
        department as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_product_attributes"
    group by department

)

select *
from all_values
where value_field not in (
    'Apparel & Sports','Books & Office','Fitness & Outdoors','Health & Beauty','Home & Garden','Technology','Toys & Games'
)


