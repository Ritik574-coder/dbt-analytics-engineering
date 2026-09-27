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
        WHEN TRIM(opened_date) LIKE '[A-Z][a-z][a-z][a-z]% __, ____'
            THEN TRY_CONVERT(DATE, TRIM(opened_date))

        WHEN TRIM(opened_date) LIKE '[A-Z][a-z][a-z] __, ____'
            THEN TRY_CONVERT(DATE, TRIM(opened_date))

        WHEN TRIM(opened_date) LIKE '__-__-____'
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(opened_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(opened_date), 110)

        WHEN TRIM(opened_date) LIKE '__-__-____'
            AND TRY_CONVERT(INT, LEFT(TRIM(opened_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(opened_date), 105)

        WHEN TRIM(opened_date) LIKE '____-__-__'
            THEN TRY_CONVERT(DATE, TRIM(opened_date))

        WHEN TRIM(opened_date) LIKE '____/__/__'
            THEN TRY_CONVERT(DATE, TRIM(opened_date))

        WHEN TRIM(opened_date) LIKE '__/__/____'
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(opened_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(opened_date), 101)

        WHEN TRIM(opened_date) LIKE '__/__/____'
            AND TRY_CONVERT(INT, LEFT(TRIM(opened_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(opened_date), 103)

        ELSE TRY_CONVERT(DATE, TRIM(opened_date), 101)

    END

 as opened_date
FROM "RetailDB"."bronze"."stg_stores" ;