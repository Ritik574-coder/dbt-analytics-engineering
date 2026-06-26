SELECT 
    p.customer_id, 
    TRIM(CONCAT(p.title, ' ', p.first_name, ' ', p.last_name)) as customer_name,
    p.gender,
    p.date_of_birth,
    c.email,
    c.phone,
    l.address,
    l.zip_code,
    l.city,
    l.region,
    l.state,
    l.state_abbr,
    l.country,
    s.company,
    s.customer_segment,
    c.preferred_channel,
    s.is_active,
    s.loyalty_points,
    s.annual_income_usd,
    s.account_created_date
FROM {{ ref('int_customer_profile') }} as p 

LEFT JOIN {{ ref('int_customers_contact') }} as c 
    ON p.customer_id = c.customer_id 

LEFT JOIN {{ ref('int_customer_location') }} as l
    ON p.customer_id = l.customer_id

LEFT JOIN {{ ref('int_customer_segmentation') }} as s  
    ON s.customer_id = p.customer_id ; 