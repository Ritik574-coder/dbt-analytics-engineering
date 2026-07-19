SELECT 
    employee_id,

    CASE 
        WHEN email IS NULL OR TRIM(email) = '' THEN 'Unknown'
        WHEN email NOT LIKE '%@%' THEN 'Unknown'
        WHEN PATINDEX('%@%@%', TRIM(LOWER(email))) > 0 THEN 
        LEFT(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) -1)
        + '@' + REPLACE(SUBSTRING(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) +1,
        LEN(TRIM(LOWER(email)))), '@' ,'')
        ELSE TRIM(LOWER(email))
    END as email,

    {{ standardize_phone('phone') }} as phone
FROM {{ ref('stg_employees') }} ;