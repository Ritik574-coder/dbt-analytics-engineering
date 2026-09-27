SELECT 
    employee_id,

    CASE 
        WHEN email IS NULL OR 
            
    LOWER(TRIM(email))
 = '' THEN 'Unknown'

        WHEN email NOT LIKE '%@%' 
            THEN 'Unknown'

        WHEN PATINDEX('%@%@%', 
    LOWER(TRIM(email))
) > 0 
            THEN 
                LEFT(
    LOWER(TRIM(email))
, CHARINDEX('@', 
    LOWER(TRIM(email))
) -1)
                + '@' + REPLACE(SUBSTRING(
    LOWER(TRIM(email))
, CHARINDEX('@', 
    LOWER(TRIM(email))
) +1,
                LEN(
    LOWER(TRIM(email))
)), '@' ,'')

        ELSE 
    LOWER(TRIM(email))


    END as email,

    

    CASE 
        WHEN TRIM(phone) LIKE '+1__________'   
            THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 3, 3), ') ',
            SUBSTRING(TRIM(phone), 6, 3),'-',
            SUBSTRING(TRIM(phone),9,4))

        WHEN TRIM(phone) LIKE '__________'     
            THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1 ,3), ') ',
            SUBSTRING(TRIM(phone), 4 ,3), '-',
            SUBSTRING(TRIM(phone), 7, 4))

        WHEN TRIM(phone) LIKE '___-___-____'   
            THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ',
            SUBSTRING(TRIM(phone), 5, 3), '-',
            SUBSTRING(TRIM(phone), 9 ,4))

        WHEN TRIM(phone) LIKE '___.___.____'   
            THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ',
            SUBSTRING(TRIM(phone), 5, 3), '-',
            SUBSTRING(TRIM(phone),9, 4))

        WHEN TRIM(phone) LIKE '(___) ___-____' 
            THEN CONCAT('+1 ',  SUBSTRING(TRIM(phone), 1, 14))

        WHEN TRIM(phone) IS NULL OR TRIM(phone) = '' 
            THEN 'Unknown'

        ELSE 'Unknown'
    END
 as phone
FROM "RetailDB"."bronze"."stg_employees" ;