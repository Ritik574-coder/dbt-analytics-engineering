SELECT 
    employee_id,
    email,
    phone
FROM {{ ref('stg_employees') }} ;