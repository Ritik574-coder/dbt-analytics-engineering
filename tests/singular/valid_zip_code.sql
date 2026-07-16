SELECT *
FROM {{ ref('int_customer_location') }}
WHERE zip_code IS NULL
   OR LEN(CAST(zip_code AS VARCHAR(10))) <> 5
   OR TRY_CAST(zip_code AS INT) IS NULL