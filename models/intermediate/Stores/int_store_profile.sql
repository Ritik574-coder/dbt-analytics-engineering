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

{{ standardize_date('opened_date') }} as opened_date
FROM {{ ref('stg_stores') }} ;