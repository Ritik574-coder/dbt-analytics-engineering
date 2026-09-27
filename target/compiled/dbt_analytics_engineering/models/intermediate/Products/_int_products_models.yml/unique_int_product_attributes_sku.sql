
    
    

select
    sku as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_product_attributes"
where sku is not null
group by sku
having count(*) > 1


