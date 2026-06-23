SELECT
    store_id,

    CASE 
        WHEN sq_footage IS NULL OR sq_footage < 0 THEN NULL
        ELSE TRY_CONVERT(INT, sq_footage)
    END as sq_footage,

    CASE 
        WHEN num_employees IS NULL OR num_employees < 0 THEN NULL
        ELSE TRY_CONVERT(INT, num_employees)
    END as num_employees,

    CASE 
        WHEN annual_rent_usd < 1 OR annual_rent_usd  IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, annual_rent_usd)
    END as annual_rent_usd,

    CASE 
        WHEN TRIM(LOWER(is_active)) IN ('true', 'yes', 'y', '1', 'active')     THEN 'True'
        WHEN TRIM(LOWER(is_active)) IN ('false', 'no', 'n', '0', 'not active') THEN 'False'
        ELSE 'Unknown'
    END as is_active,

    CASE 
        WHEN TRIM(LOWER(has_parking)) IN ('true', 'yes', 'y', '1') THEN 'True'
        WHEN TRIM(LOWER(has_parking)) IN ('false', 'no', 'n', '0') THEN 'False'
        ELSE 'Unknown'
    END as has_parking,

    CASE 
        WHEN REPLACE(REPLACE(TRIM(LOWER(has_cafe)), CHAR(13), ''),CHAR(10), '') IN ('1', 'yes', 'y','true') THEN 'True'
        WHEN REPLACE(REPLACE(TRIM(LOWER(has_cafe)), CHAR(13), ''),CHAR(10), '') IN ('0', 'no', 'n','false') THEN 'False'
        ELSE 'Unknown'
    END as has_cafe
FROM {{ ref('stg_stores') }} ;