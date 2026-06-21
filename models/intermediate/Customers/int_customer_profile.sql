-- ============================================================================
-- Model: int_customer_profile
--
-- Purpose:
--   Creates a standardized customer profile dataset by applying business
--   rules to personal customer attributes. This model derives first and last
--   names from the full name, normalizes gender values into consistent
--   categories, and converts multiple source date formats into a reliable
--   DATE data type. The resulting dataset serves as a trusted foundation for
--   customer demographics, segmentation, personalization, and downstream
--   dimensional models.
--
-- Maintainer: Ritik
-- ============================================================================

SELECT
    customer_id,
    TRIM(title) as title,

    CASE
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ', '')) = 2 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ', '')) = 1 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
    END AS first_name,

    PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 1) AS last_name,

    CASE TRIM(LOWER(gender))
        WHEN 'f' THEN 'Female'
        WHEN 'female' THEN 'Female'
        WHEN 'm' THEN 'Male'
        WHEN 'male' THEN 'Male'
        WHEN 'nb' THEN 'Non-Binary'
        WHEN 'non-binary' THEN 'Non-Binary'
        WHEN 'other' THEN 'Other'
        WHEN 'prefer not to say' THEN 'Other'
        ELSE 'Unknown'
    END as gender,

    CASE
        WHEN TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE, TRIM(date_of_birth))
        WHEN TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE, TRIM(date_of_birth))
        WHEN TRIM(date_of_birth) LIKE '____-__-__'                     THEN TRY_CONVERT(DATE, TRIM(date_of_birth))
        WHEN TRIM(date_of_birth) LIKE '____/__/__'                     THEN TRY_CONVERT(DATE, TRIM(date_of_birth))

        WHEN TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(TRIM(date_of_birth), 4, 2)) > 12 THEN TRY_CONVERT(DATE, TRIM(date_of_birth), 101)
        WHEN TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(TRIM(date_of_birth), 2)) > 12         THEN TRY_CONVERT(DATE , TRIM(date_of_birth), 103)

        WHEN TRIM(date_of_birth) LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(TRIM(date_of_birth), 4, 2)) > 12 THEN TRY_CONVERT(DATE, TRIM(date_of_birth), 110)
        WHEN TRIM(date_of_birth) LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(TRIM(date_of_birth), 2)) > 12         THEN TRY_CONVERT(DATE , TRIM(date_of_birth), 105)
        ELSE TRY_CONVERT(DATE, TRIM(date_of_birth), 101)
    END date_of_birth

FROM {{ ref('stg_customers') }} ;