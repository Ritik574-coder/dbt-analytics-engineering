SELECT
    p.store_id,
    p.store_name,
    p.store_type,
    p.manager_name,
    p.opened_date,
    l.address,
    l.city,
    l.state,
    l.state_full,
    l.zip_code,
    l.country,
    l.region,
    l.district,
    l.phone,
    o.sq_footage,
    o.num_employees,
    o.annual_rent_usd,
    o.is_active,
    o.has_parking,
    o.has_cafe
FROM {{ ref('int_store_profile') }} AS p
LEFT JOIN {{ ref('int_store_location') }} AS l
    ON p.store_id = l.store_id
LEFT JOIN {{ ref('int_store_operations') }} AS o
    ON p.store_id = o.store_id
WHERE p.store_id IS NOT NULL;
