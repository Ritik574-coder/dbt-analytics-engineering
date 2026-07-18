SELECT 
    employee_id, 

    CASE 
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ','')) = 1 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
    END as first_name,

    PARSENAME(REPLACE(TRIM(full_name),' ','.'),1) as last_name,

    {{ standardize_date('hire_date') }} as hire_date
FROM {{ ref('stg_employees') }} ;