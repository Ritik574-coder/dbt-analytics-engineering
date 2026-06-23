SELECT 
    employee_id, 

    CASE 
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ','')) = 1 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
    END as first_name,

    PARSENAME(REPLACE(TRIM(full_name),' ','.'),1) as last_name,

    CASE 
        WHEN hire_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE,hire_date )
        WHEN hire_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE, hire_date)
        WHEN hire_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE, hire_date)
        WHEN hire_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE, hire_date)

        WHEN hire_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 THEN  TRY_CONVERT(DATE, hire_date,103)
        WHEN hire_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 THEN TRY_CONVERT(DATE, hire_date, 105)
        
        WHEN hire_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 THEN  TRY_CONVERT(DATE, hire_date,101)
        WHEN hire_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, hire_date, 110)
        ELSE TRY_CONVERT(DATE, hire_date)
    END hire_date
FROM {{ ref('stg_employees') }} ;