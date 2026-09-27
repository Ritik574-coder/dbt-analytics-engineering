
    
    

select
    review_id as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."int_review_transaction"
where review_id is not null
group by review_id
having count(*) > 1


