-- ============================================================================
-- Model: int_customer_location
-- Purpose:
--   Standardizes customer location attributes by correcting common data quality
--   issues such as missing values, typographical errors, inconsistent casing,
--   invalid state abbreviations, invalid ZIP codes, and non-standard country
--   names. This model prepares clean and consistent geographic information for
--   downstream analytical models.
-- ============================================================================

-- dbt.TitleCase is a  custom function taht help me to convert string into title case 
SELECT 
    customer_id,

    CASE 
        WHEN address IS NULL OR address = '' THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(address))
    END as address,

    CASE 
        WHEN TRIM(LOWER(city)) = 'an diego'     THEN dbo.TitleCase('san diego')
        WHEN TRIM(LOWER(city)) = 'chiago'       THEN dbo.TitleCase('chicago')
        WHEN TRIM(LOWER(city)) = 'chrlotte'     THEN dbo.TitleCase('charlotte')
        WHEN TRIM(LOWER(city)) = 'dalla'        THEN dbo.TitleCase('dallas')
        WHEN TRIM(LOWER(city)) = 'inneapolis'   THEN dbo.TitleCase('minneapolis')
        WHEN TRIM(LOWER(city)) = 'louiville'    THEN dbo.TitleCase('louisville')
        WHEN TRIM(LOWER(city)) = 'milwakee'     THEN dbo.TitleCase('milwaukee')
        WHEN TRIM(LOWER(city)) = 'mnneapolis'   THEN dbo.TitleCase('minneapolis')
        WHEN TRIM(LOWER(city)) = 'oklahoma cty' THEN dbo.TitleCase('oklahoma city')
        WHEN TRIM(LOWER(city)) = 'ortland'      THEN dbo.TitleCase('portland')
        WHEN TRIM(LOWER(city)) = 'sa diego'     THEN dbo.TitleCase('san diego')
        WHEN TRIM(LOWER(city)) = 'san ntonio'   THEN dbo.TitleCase('san antonio')
        WHEN TRIM(LOWER(city)) = 'sn antonio'   THEN dbo.TitleCase('san antonio')
        WHEN TRIM(city) = ''                    THEN 'Unknown'
        WHEN city IS NULL                       THEN 'Unknown'
        ELSE dbo.TitleCase(TRIM(city))
    END AS city,
    
    CASE 
        WHEN TRIM(UPPER(state_abbr)) IS NULL OR TRIM(UPPER(state_abbr)) = '' THEN 'Unknown'
        WHEN LEN(TRIM(UPPER(state_abbr))) != 2 THEN 'Unknown'
        ELSE TRIM(UPPER(state_abbr))
    END as state_abbr,

    CASE
        WHEN TRIM(state_full) IS NULL OR TRIM(state_full) = '' THEN 'Unknown'
        ELSE TRIM(state_full)
    END AS state,

    CASE 
        WHEN zip_code IS NULL THEN 0
        WHEN LEN(zip_code) != 5 THEN 0
        WHEN TRY_CAST(zip_code AS INT) IS NULL THEN 0
        ELSE zip_code
    END as zip_code,

    CASE 
         WHEN TRIM(LOWER(country)) IN ('u.s.a', 'us', 'usa', 'united states') THEN 'United States'
         ELSE 'Unknown'
    END as country,

    CASE 
         WHEN region IS NULL OR TRIM(region) = '' THEN 'Unknown'
         ELSE TRIM(region)
    END as region
FROM {{ ref('stg_customers') }} ;