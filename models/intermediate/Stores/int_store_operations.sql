SELECT
    store_id,
    sq_footage,
    num_employees,
    annual_rent_usd,
    is_active,
    has_parking,
    has_cafe
FROM {{ ref('stg_stores') }} ;