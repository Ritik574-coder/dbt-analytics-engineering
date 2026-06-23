SELECT
    CASE 
          WHEN TRY_CONVERT(INT, return_id) < 1 OR TRY_CONVERT(INT, return_id) IS NULL THEN NULL 
          ELSE TRY_CONVERT(INT, return_id)
    END as return_id,

    CASE 
          WHEN original_txn_id IS NULL THEN NULL
          WHEN UPPER(TRIM(original_txn_id)) NOT LIKE 'TXN-%' THEN NULL
          WHEN LEN(UPPER(TRIM(original_txn_id))) < 10 THEN NULL
          ELSE UPPER(TRIM(original_txn_id))
    END as original_txn_id,

    CASE 
          WHEN original_order_id IS NULL OR TRY_CONVERT(INT, original_order_id) < 1 OR TRY_CONVERT(INT, original_order_id) IS NULL THEN NULL 
          ELSE TRY_CONVERT(INT, original_order_id)
    END as original_order_id,

    CASE 
          WHEN customer_id IS NULL OR TRY_CONVERT(INT, customer_id) IS NULL THEN NULL 
          ELSE TRY_CONVERT(INT, customer_id)
    END as customer_id,

    CASE 
          WHEN customer_name IS NULL OR TRIM(customer_name) = '' THEN 'Unknown'
          ELSE dbo.TitleCase(TRIM(customer_name))
    END as customer_name,

    CASE 
          WHEN product_id IS NULL OR TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
          ELSE TRY_CONVERT(INT, product_id)
    END as product_id,

    CASE 
          WHEN product_name IS NULL OR TRIM(product_name) = '' THEN 'Unknown'
          ELSE dbo.TitleCase(TRIM(product_name))
    END as product_name,

    CASE 
          WHEN quantity_returned IS NULL OR TRY_CONVERT(INT, quantity_returned) IS NULL OR TRY_CONVERT(INT, quantity_returned) < 1 THEN NULL 
          ELSE TRY_CONVERT(INT, quantity_returned)
    END as quantity_returned,

    CASE 
        WHEN return_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,return_date)
        WHEN return_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,return_date)
        WHEN return_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,return_date)
        WHEN return_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,return_date)

        WHEN return_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(return_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, return_date, 101)
        WHEN return_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(return_date, 2))         > 12 THEN TRY_CONVERT(DATE, return_date, 103)
        WHEN return_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(return_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, return_date, 110)
        WHEN return_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(return_date, 2))         > 12 THEN TRY_CONVERT(DATE, return_date, 105)
        ELSE TRY_CONVERT(DATE, return_date)
    END as return_date
FROM {{ ref('stg_returns') }} ;


