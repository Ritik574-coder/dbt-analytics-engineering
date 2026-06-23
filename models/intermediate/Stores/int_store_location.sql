SELECT
    store_id,

    CASE 
        WHEN address IS NULL OR TRIM(address) = '' OR LEN(address) < 5 THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(address))
    END address,

    CASE 
        WHEN city IS NULL OR TRIM(city) = '' OR LEN(TRIM(city)) < 3 THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(city))
    END as city,

    CASE 
        WHEN TRIM(state) = 'California'  THEN 'CA'
        WHEN TRIM(state) = 'Texas'       THEN 'TX'
        WHEN TRIM(state) = 'Arizona'     THEN 'AZ'
        WHEN TRIM(state) = 'Colorado'    THEN 'CO'
        WHEN TRIM(state) = 'Maryland'    THEN 'MD'
        WHEN TRIM(state) = 'Wisconsin'   THEN 'WI'
        WHEN TRIM(state) = 'Illinois'    THEN 'IL'
        WHEN TRIM(state) = 'Georgia'     THEN 'GA'
        WHEN TRIM(state) = 'Tennessee'   THEN 'TN'
        WHEN TRIM(state) = 'New Mexico'  THEN 'NM'
        WHEN TRIM(state) = 'Ohio'        THEN 'OH'
        WHEN state IS NULL OR TRIM(state) = '' OR LEN(TRIM(state))  < 2 THEN 'Unknown'
        ELSE state
    END as state,  

    CASE 
        WHEN state_full IS NULL OR TRIM(state_full) = '' OR LEN(TRIM(state_full)) < 4 THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(state_full))
    END as state_full,

    CASE 
        WHEN zip_code IS NULL OR TRY_CONVERT(INT, zip_code) IS NULL OR LEN(zip_code) < 5 THEN NULL 
        ELSE TRY_CONVERT(INT, zip_code)
    END as zip_code,

    CASE 
        WHEN TRIM(LOWER(country)) IN ('us', 'usa', 'united states', 'u.s.a', 'u.s') THEN 'United States'
        WHEN country IS NULL OR TRIM(country) = '' OR LEN(TRIM(country)) < 2        THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(country))
    END as country, 

    CASE 
        WHEN region IS NULL OR TRIM(region) = '' OR LEN(TRIM(region)) < 2 THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(region))
    END as region,

    CASE 
        WHEN district IS NULL OR TRIM(district) = '' OR LEN(TRIM(district)) < 2 THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(district))
    END as district,

    CASE 
        WHEN TRIM(phone) LIKE '(___) ___-____' THEN CONCAT('+1 ',  SUBSTRING(TRIM(phone), 1, 14))
        WHEN TRIM(phone) LIKE '+___________'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 3, 3), ') ', SUBSTRING(TRIM(phone), 6, 3),'-',  SUBSTRING(TRIM(phone), 9,4))
        WHEN TRIM(phone) LIKE '___-___-____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 8))
        WHEN TRIM(phone) LIKE '___.___.____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3), '-', SUBSTRING(TRIM(phone), 9, 4))
        WHEN TRIM(phone) LIKE '__________'     THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 4, 3), '-', SUBSTRING(TRIM(phone), 7, 4))
        ELSE TRIM(phone)
    END as phone
FROM {{ ref('stg_stores') }} ;

