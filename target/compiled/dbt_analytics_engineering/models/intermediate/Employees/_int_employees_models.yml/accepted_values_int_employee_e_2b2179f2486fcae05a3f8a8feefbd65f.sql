
    
    

with all_values as (

    select
        job_title as value_field,
        count(*) as n_records

    from "RetailDB"."bronze"."int_employee_employment"
    group by job_title

)

select *
from all_values
where value_field not in (
    'Account Executive','Customer Advisor','Regional Manager','Sales Associate','Sales Consultant','Sales Manager','Sales Representative','Senior Sales Associate','Store Manager'
)


