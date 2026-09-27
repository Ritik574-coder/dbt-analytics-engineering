
    
    

select
    product_name as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_product_attributes"
where product_name is not null
group by product_name
having count(*) > 1


