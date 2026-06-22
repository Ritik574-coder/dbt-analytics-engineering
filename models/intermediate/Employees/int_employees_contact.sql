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

    CASE 
        WHEN phone LIKE '+___________'   THEN  CONCAT('+1 (', SUBSTRING(phone, 3, 3), ') ' ,  SUBSTRING(phone, 6, 3), '-', SUBSTRING(phone, 9,4))
        WHEN phone LIKE '___.___.____'   THEN  CONCAT('+1 (', SUBSTRING(phone, 1,3) , ') ' ,  SUBSTRING(phone,5, 3), '-' ,  SUBSTRING(phone,9,4))
        WHEN phone LIKE '__________'     THEN  CONCAT('+1 (', SUBSTRING(phone, 1,3) , ') ' ,  SUBSTRING(phone, 4,3), '-' ,  SUBSTRING(phone,7,4))
        WHEN phone LIKE '___-___-____'   THEN  CONCAT('+1 (', SUBSTRING(phone,1, 3) , ') ' ,  SUBSTRING(phone, 5,8))
        WHEN phone LIKE '(___) ___-____' THEN  CONCAT('+1 ',  SUBSTRING(phone, 1,14))
    END as phone
FROM {{ ref('stg_employees') }} ;