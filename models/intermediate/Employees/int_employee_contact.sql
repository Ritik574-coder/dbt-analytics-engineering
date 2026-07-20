SELECT 
    employee_id,

    CASE 
        WHEN email IS NULL OR 
            {{ trim_lower('email') }} = '' THEN 'Unknown'

        WHEN email NOT LIKE '%@%' 
            THEN 'Unknown'

        WHEN PATINDEX('%@%@%', {{ trim_lower('email') }}) > 0 
            THEN 
                LEFT({{ trim_lower('email') }}, CHARINDEX('@', {{ trim_lower('email') }}) -1)
                + '@' + REPLACE(SUBSTRING({{ trim_lower('email') }}, CHARINDEX('@', {{ trim_lower('email') }}) +1,
                LEN({{ trim_lower('email') }})), '@' ,'')

        ELSE {{ trim_lower('email') }}

    END as email,

    {{ standardize_phone('phone') }} as phone
FROM {{ ref('stg_employees') }} ;