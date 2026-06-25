SELECT 
    p.employee_id,
    e.store_id,
    e.manager_id,
    CONCAT(p.first_name, ' ', p.last_name) as employee_name,
    e.job_title,
    e.department,
    e.performance_rating,
    e.store_name,      
    e.store_city,
    c.email,
    c.phone,
    e.annual_salary_usd,  
    e.commission_rate_pct,    
    e.years_employed,    
    e.is_active,
    p.hire_date 
FROM {{ ref('int_employee_profile') }} as p 

LEFT JOIN {{ ref('int_employee_contact') }} as c  
    ON p.employee_id = c.employee_id

LEFT JOIN {{ ref('int_employee_employment') }} as e  
    ON p.employee_id = e.employee_id ; 
