
    
    

select
    date_day as unique_field,
    count(*) as n_records

from "RetailDB"."bronze"."dim_date"
where date_day is not null
group by date_day
having count(*) > 1


