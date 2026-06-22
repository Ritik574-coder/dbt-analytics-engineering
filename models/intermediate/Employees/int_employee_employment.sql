SELECT
    employee_id,

    CASE 
        WHEN job_title IS NULL OR job_title = '' THEN 'Unknown'
        ELSE TRIM(job_title) 
    END as job_title,

    CASE 
        WHEN department IS NULL OR department = '' THEN 'Unknown'
        ELSE TRIM(department)
    END as department,

    CASE 
        WHEN store_id < 0 OR TRY_CONVERT(INT, store_id) IS NULL THEN NULL
        ELSE TRY_CONVERT(INT, store_id) 
    END as store_id,

    CASE 
        WHEN store_name IS NULL OR store_name = '' THEN 'Unknown'
        ELSE TRIM(store_name)
    END as store_name,

    CASE 
        WHEN store_city IS NULL OR LEN(store_city) < 4 OR store_city = '' THEN 'Unknown'
        ELSE TRIM(store_city)
    END store_city,

    CASE 
        WHEN annual_salary_usd IS NULL 
        OR TRY_CONVERT(DECIMAL(18,2), annual_salary_usd) IS NULL 
        OR TRY_CONVERT(DECIMAL(18,2), annual_salary_usd) < 0 THEN NULL
        ELSE TRY_CONVERT(DECIMAL(18,2), annual_salary_usd)
    END AS annual_salary_usd,

    CASE 
        WHEN commission_rate_pct IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), commission_rate_pct) IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), commission_rate_pct) < 0 THEN NULL
        ELSE TRY_CONVERT(DECIMAL(4,2), commission_rate_pct)
    END AS commission_rate_pct,

    CASE
        WHEN TRIM(LOWER(performance_rating)) IN ('excellent', 'a', '5')     THEN 'Excellent'
        WHEN TRIM(LOWER(performance_rating)) IN ('good', 'b', '4')          THEN 'Good'
        WHEN TRIM(LOWER(performance_rating)) IN ('average', 'c', '3')       THEN 'Average'
        WHEN TRIM(LOWER(performance_rating)) IN ('below average', 'd', '2') THEN 'Below Average'
        WHEN performance_rating IS NULL OR TRIM(performance_rating) = ''    THEN 'Unknown'
        ELSE 'Unknown'
    END AS performance_rating,

    CASE 
        WHEN years_employed IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), years_employed) IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), years_employed) < 0 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(4,2), TRY_CONVERT(DECIMAL(4,2), years_employed))
    END years_employed,

    CASE 
        WHEN TRY_CONVERT(INT ,manager_id) IS NULL THEN NULL 
        ELSE manager_id 
    END as manager_id,

    CASE
        WHEN TRIM(LOWER(is_active)) IN ('active', 'y', 'yes', '1', 'true')     THEN 'True'
        WHEN TRIM(LOWER(is_active)) IN ('terminated', 'n', 'no', '0', 'false') THEN 'False'
        ELSE NULL
    END AS is_active
FROM {{ ref('stg_employees') }} ;