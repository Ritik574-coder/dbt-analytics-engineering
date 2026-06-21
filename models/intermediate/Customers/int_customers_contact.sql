-- ============================================================================
-- Model: int_customers_contact
--
-- Purpose:
--   Standardizes customer contact information by cleaning and validating
--   email addresses, phone numbers, and preferred communication channels.
--   This model corrects common email domain typographical errors, formats
--   phone numbers into a consistent structure, and normalizes customer
--   communication preferences for reliable downstream analytical models.
--
-- Maintainer: Ritik
-- ============================================================================
SELECT
    customer_id,

    CASE
        WHEN email IS NULL OR TRIM(email) = '' THEN 'Unknown'
        WHEN TRIM(LOWER(email)) NOT LIKE '%@%' THEN 'Unknown'
        WHEN PATINDEX('%@%@%', TRIM(LOWER(email))) > 0 THEN
                LEFT(TRIM(LOWER(email)),CHARINDEX('@', TRIM(LOWER(email))) - 1)
                + '@' +
                REPLACE(
                    SUBSTRING(
                        TRIM(LOWER(email)),
                        CHARINDEX('@', TRIM(LOWER(email))) + 1,
                        LEN(email)),'@','')
        ELSE
            CONCAT(
                LEFT(TRIM(LOWER(email)),CHARINDEX('@', TRIM(LOWER(email))) - 1), '@',
                CASE
                    WHEN RIGHT(
                        TRIM(LOWER(email)),
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'yahoocom' THEN 'yahoo.com'
                    WHEN RIGHT(
                        TRIM(LOWER(email)),
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'iclod.com' THEN 'icloud.com'
                    WHEN RIGHT(
                        TRIM(LOWER(email)),
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'outook.com' THEN 'outlook.com'
                    WHEN RIGHT(
                        TRIM(LOWER(email)),
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'ahoo.com' THEN 'yahoo.com'
                    ELSE RIGHT(
                        TRIM(LOWER(email)),
                        LEN(TRIM(email)) - CHARINDEX('@', TRIM(email)))
                END
        )
    END AS email,

    CASE 
        WHEN TRIM(phone) LIKE '+1__________'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 3, 3), ') ', SUBSTRING(TRIM(phone), 6, 3),'-',   SUBSTRING(TRIM(phone),9,4))
        WHEN TRIM(phone) LIKE '__________'     THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1 ,3), ') ', SUBSTRING(TRIM(phone), 4 ,3), '-',  SUBSTRING(TRIM(phone), 7, 4))
        WHEN TRIM(phone) LIKE '___-___-____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3),       SUBSTRING(TRIM(phone), 8 ,5))
        WHEN TRIM(phone) LIKE '___.___.____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3), '-',  SUBSTRING(TRIM(phone),9, 4))
        WHEN TRIM(phone) LIKE '(___) ___-____' THEN CONCAT('+1 ',  SUBSTRING(TRIM(phone), 1, 14))
        WHEN TRIM(phone) IS NULL OR TRIM(phone) = '' THEN 'Unknown'
        ELSE 'Unknown'
    END  as phone,

    CASE TRIM(LOWER(preferred_channel))
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