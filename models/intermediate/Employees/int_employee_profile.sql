SELECT 
    employee_id,
    first_name,
    last_name,
    hire_date
FROM {{ ref('stg_employees') }} ;