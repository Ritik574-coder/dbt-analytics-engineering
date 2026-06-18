SELECT
    employee_id,
    job_title,
    department,
    store_id,
    store_name,
    store_city,
    annual_salary_usd,
    commission_rate_pct,
    performance_rating,
    years_employed,
    manager_id,
    is_active
FROM {{ ref('stg_employees') }} ;