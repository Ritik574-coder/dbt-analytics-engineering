SELECT
    store_id,
    
    CASE 
        WHEN manager_name IS NULL OR TRIM(manager_name) = '' OR LEN(TRIM(manager_name)) < 2 THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(manager_name))
    END as manager_name,

    CASE 
        WHEN store_name IS NULL OR LEN(TRIM(store_name)) < 3 THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(store_name))
    END as store_name,

    CASE 
        WHEN store_type IS NULL OR LEN(TRIM(store_type)) < 3 THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(store_type))
    END as store_type,

    CASE 
        WHEN opened_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,opened_date)
        WHEN opened_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,opened_date)
        WHEN opened_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,opened_date)
        WHEN opened_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,opened_date)
    
        WHEN opened_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(opened_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, opened_date, 101)
        WHEN opened_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(opened_date, 2))         > 12 THEN TRY_CONVERT(DATE, opened_date, 103)
        WHEN opened_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(opened_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, opened_date, 110)
        WHEN opened_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(opened_date, 2))         > 12 THEN TRY_CONVERT(DATE, opened_date, 105)
        ELSE TRY_CONVERT(DATE, opened_date)
    END as opened_date
FROM {{ ref('stg_stores') }} ;