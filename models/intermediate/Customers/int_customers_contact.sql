-- ============================================================================
-- Model: int_customers_contact
--
-- Purpose:
--   Creates a trusted customer contact dataset by validating, correcting, and
--   standardizing customer communication attributes. This model repairs common
--   email formatting issues and domain typographical errors, transforms phone
--   numbers into a consistent business format, and normalizes preferred
--   communication channels into standardized business categories. The resulting
--   dataset provides reliable contact information for customer communication,
--   marketing campaigns, CRM operations, and downstream analytical models.
--
-- Maintainer: Ritik
-- ============================================================================
SELECT
    customer_id,

    CASE
        WHEN email IS NULL OR TRIM(email) = '' THEN 'Unknown'
        WHEN {{ trim_lower('email') }} NOT LIKE '%@%' THEN 'Unknown'
        WHEN PATINDEX('%@%@%', {{ trim_lower('email') }}) > 0 THEN
                LEFT({{ trim_lower('email') }},CHARINDEX('@', {{ trim_lower('email') }}) - 1)
                + '@' +
                REPLACE(
                    SUBSTRING(
                        {{ trim_lower('email') }},
                        CHARINDEX('@', {{ trim_lower('email') }}) + 1,
                        LEN(email)),'@','')
        ELSE
            CONCAT(
                LEFT({{ trim_lower('email') }},CHARINDEX('@', {{ trim_lower('email') }}) - 1), '@',
                CASE
                    WHEN RIGHT(
                        {{ trim_lower('email') }},
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'yahoocom' THEN 'yahoo.com'
                    WHEN RIGHT(
                        {{ trim_lower('email') }},
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'iclod.com' THEN 'icloud.com'
                    WHEN RIGHT(
                        {{ trim_lower('email') }},
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'outook.com' THEN 'outlook.com'
                    WHEN RIGHT(
                        {{ trim_lower('email') }},
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'ahoo.com' THEN 'yahoo.com'
                    ELSE RIGHT(
                        {{ trim_lower('email') }},
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email)))
                END
        )
    END AS email,
    
    {{ standardize_phone('phone') }}  as phone,

    CASE {{ trim_lower('preferred_channel') }}
        WHEN 'app'        THEN 'Mobile App'
        WHEN 'mobile app' THEN 'Mobile App'
        WHEN 'mobile'     THEN 'Mobile App'
        WHEN 'in store'   THEN 'In Store'
        WHEN 'in-store'   THEN 'In Store'
        WHEN 'store'      THEN 'In Store'
        WHEN 'catalog'    THEN 'Catalog'
        WHEN 'online'     THEN 'Website'
        WHEN 'web'        THEN 'Website'
        WHEN 'phone'      THEN 'Phone Call'
        ELSE 'Unknown'
    END as preferred_channel

FROM {{ ref('stg_customers') }} ;