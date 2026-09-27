
    
    

select
    store_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_store_operations"
where store_id is not null
group by store_id
having count(*) > 1


