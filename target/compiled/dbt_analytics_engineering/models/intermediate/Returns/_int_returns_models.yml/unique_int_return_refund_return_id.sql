
    
    

select
    return_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_return_refund"
where return_id is not null
group by return_id
having count(*) > 1


