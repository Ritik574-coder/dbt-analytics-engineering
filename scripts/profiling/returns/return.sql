--#############################################################################################
--#################################### RETURNS DATA ###########################################
--#############################################################################################

--=============================================================================================
--================================== return table overview ====================================
--=============================================================================================
SELECT 
       [return_id]
      ,[original_txn_id]
      ,[original_order_id]
      ,[customer_id]
      ,[customer_name]
      ,[product_id]
      ,[product_name]
      ,[quantity_returned]
      ,[return_date]
      ,[return_reason]
      ,[refund_amount]
      ,[refund_method]
      ,[return_channel]
      ,[restocked]
      ,[return_status]
      ,[handled_by_emp_id]
      ,[notes]
  FROM [bronze].[returns]

--=============================================================================================
--================================== return_id table overview =================================
--=============================================================================================
-- return id data profiling 
SELECT 
      return_id
FROM bronze.returns
WHERE return_id IS NULL
OR TRY_CONVERT(INT, return_id) IS NULL ; 

-- duplicate check in return_id 
SELECT 
      *
FROM 
(
      SELECT 
            return_id ,
            ROW_NUMBER() OVER(PARTITION BY return_id ORDER BY return_id DESC) as flag 
      FROM bronze.[returns]
)t WHERE flag > 1;

-- return_id cleaning and standerdazition 
SELECT 
      CASE 
            WHEN return_id < 1 OR TRY_CONVERT(INT, return_id) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, return_id)
      END as return_id
FROM bronze.[returns] ;

--=============================================================================================
--=============================== original_txn_id table overview ==============================
--=============================================================================================
-- original_txn_id data profiling 
SELECT 
      original_txn_id
FROM  bronze.[returns]
WHERE original_txn_id IS NULL 
   OR original_txn_id  NOT LIKE 'TXN-%'
   OR original_txn_id != TRIM(original_txn_id)
   OR original_txn_id != UPPER(original_txn_id)
   OR LEN(original_txn_id) < 10 ;

 -- original_txn_id check in return_id 
SELECT 
      *
FROM 
(
      SELECT 
            original_txn_id ,
            ROW_NUMBER() OVER(PARTITION BY original_txn_id ORDER BY original_txn_id DESC) as flag 
      FROM bronze.[returns]
)t WHERE flag > 1;  

-- original_txn_id cleaning and standardization
WITH cleaned_txn_ids AS 
(
      SELECT 
            CASE 
                  WHEN original_txn_id IS NULL THEN NULL
                  WHEN UPPER(TRIM(original_txn_id)) NOT LIKE 'TXN-%' THEN NULL
                  WHEN LEN(UPPER(TRIM(original_txn_id))) < 10 THEN NULL
                  ELSE UPPER(TRIM(original_txn_id))
            END as original_txn_id
      FROM bronze.[returns] 
)
SELECT 
      original_txn_id
FROM cleaned_txn_ids
WHERE original_txn_id IS NULL ;
--=============================================================================================
--=============================== original_order_id table overview ============================
--=============================================================================================
-- original_order_id data profiling 
SELECT 
      original_order_id
FROM  bronze.[returns]
WHERE original_order_id IS NULL 
OR TRY_CONVERT(INT, original_order_id) IS NULL ;

 -- duplicate check in original_order_id
SELECT 
      *
FROM 
(
      SELECT 
            original_order_id ,
            ROW_NUMBER() OVER(PARTITION BY original_order_id ORDER BY original_order_id DESC) as flag 
      FROM bronze.[returns]
)t WHERE flag > 1;  

-- original_order_id cleaning and standardization
WITH cleaned_order_ids AS 
(
      SELECT 
            CASE 
                  WHEN original_order_id IS NULL OR TRY_CONVERT(INT, original_order_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, original_order_id)
            END as original_order_id
      FROM bronze.[returns] 
)
SELECT 
      original_order_id
FROM cleaned_order_ids
WHERE original_order_id IS NULL;

--=============================================================================================
--=============================== customer_id table overview ==================================
--=============================================================================================
-- customer_id data profiling
SELECT 
      customer_id 
FROM bronze.[returns] 
WHERE customer_id IS NULL 
OR TRY_CONVERT(INT, customer_id) IS NULL ;

-- duplicate check in customer_id
SELECT 
      *
FROM 
(
      SELECT 
            customer_id ,
            ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY customer_id DESC) as flag 
      FROM bronze.[returns]
)t WHERE flag > 1;

-- customer_id cleaning and standardization
WITH cleaned_customer_ids AS 
(
       SELECT 
            CASE 
                  WHEN customer_id IS NULL OR TRY_CONVERT(INT, customer_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, customer_id)
            END as customer_id
      FROM bronze.[returns] 
)
SELECT 
      customer_id
FROM cleaned_customer_ids
WHERE customer_id IS NULL;
--=============================================================================================
--=============================== customer_name table overview ================================
--=============================================================================================
-- customer_name data profiling
SELECT 
      customer_name 
FROM  bronze.[returns]
WHERE customer_name IS NULL 
   OR customer_name != TRIM(customer_name) 
   OR customer_name != dbo.TitleCase(customer_name)
   OR LEN(customer_name) < 3 ;

-- customer_name cleaning and standardization
WITH cleaned_customer_names AS 
(
      SELECT 
            CASE 
                  WHEN customer_name IS NULL OR TRIM(customer_name) = '' THEN 'Unknown'
                  ELSE dbo.TitleCase(TRIM(customer_name))
            END as customer_name
      FROM bronze.[returns] 
)
SELECT 
      customer_name
FROM cleaned_customer_names
WHERE customer_name = 'Unknown' ;
--=============================================================================================
--==================================== product_id table overview ==============================
--=============================================================================================
-- product_id data profiling
SELECT 
      product_id
FROM bronze.[returns]
WHERE product_id IS NULL 
OR TRY_CONVERT(INT, product_id) IS NULL ;

-- duplicate check in product_id
SELECT 
      *
FROM 
(
      SELECT 
            product_id ,
            ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY product_id DESC) as flag 
      FROM bronze.[returns]
)t WHERE flag > 1;

-- product_id cleaning and standardization
WITH cleaned_product_ids AS 
(
      SELECT 
            CASE 
                  WHEN product_id IS NULL OR TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, product_id)
            END as product_id
      FROM bronze.[returns] 
)
SELECT 
      product_id
FROM cleaned_product_ids
WHERE product_id IS NULL ;
--=============================================================================================
--=============================== product_name table overview =================================
--=============================================================================================
-- product_name data profiling
SELECT 
      product_name
FROM  bronze.[returns]
WHERE product_name IS NULL 
   OR product_name != TRIM(product_name)
   OR product_name != dbo.TitleCase(product_name)
   OR LEN(product_name) < 3 ;

-- product_name cleaning and standardization
WITH cleaned_product_names AS 
(
      SELECT 
            CASE 
                  WHEN product_name IS NULL OR TRIM(product_name) = '' THEN 'Unknown'
                  ELSE dbo.TitleCase(TRIM(product_name))
            END as product_name
      FROM bronze.[returns] 
)
SELECT 
      product_name
FROM cleaned_product_names
WHERE product_name = 'Unknown' ;
--=============================================================================================
--=============================== quantity_returned table overview ============================
--=============================================================================================
-- quantity_returned data profiling
SELECT 
      quantity_returned
FROM bronze.[returns]
WHERE quantity_returned IS NULL 
OR TRY_CONVERT(INT, quantity_returned) IS NULL
OR TRY_CONVERT(INT, quantity_returned) < 1 ;

-- quantity_returned cleaning and standardization
WITH cleaned_quantity_returned AS 
(
      SELECT 
            CASE 
                  WHEN quantity_returned IS NULL OR TRY_CONVERT(INT, quantity_returned) IS NULL OR TRY_CONVERT(INT, quantity_returned) < 1 THEN NULL 
                  ELSE TRY_CONVERT(INT, quantity_returned)
            END as quantity_returned
      FROM bronze.[returns] 
)
SELECT 
      quantity_returned
FROM cleaned_quantity_returned
WHERE quantity_returned IS NULL ;

--=============================================================================================
--=============================== return_date table overview ==================================
--=============================================================================================
-- pattern check in return_date
WITH return_date_analysis AS 
(
      SELECT
            TRANSLATE(
                  TRIM(LOWER(return_date)),
                  '0123456789abcdefghijklmnopqrstuvwxyz',
                  '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
            ) as return_date_pattern
      FROM bronze.[returns] 
)
SELECT 
      return_date_pattern,
      COUNT(*) as count,
      CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bronze.[returns]), 2)as nvarchar) + '%' as percentage
FROM return_date_analysis
      GROUP BY return_date_pattern
      ORDER BY count DESC;

-- return_date data profiling
SELECT 
      return_date
FROM bronze.[returns]
WHERE return_date IS NULL
OR TRY_CONVERT(DATE, return_date) IS NULL
OR TRY_CONVERT(DATE, return_date) > GETDATE()
OR TRY_CONVERT(DATE, return_date) < '2000-01-01';

-- return_date cleaning and standardization
WITH clean_date AS 
(
    SELECT 
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
    FROM bronze.[returns]
)
SELECT 
    return_date
FROM clean_date 
WHERE TRY_CONVERT(DATE, return_date) IS NULL
    OR TRY_CONVERT(DATE, return_date) > GETDATE() ;
    
--=============================================================================================
--=============================== return_reason table overview ================================
--=============================================================================================
-- return_reason data profiling
SELECT 
      return_reason
FROM  bronze.[returns]
WHERE return_reason IS NULL
   OR TRIM(return_reason) = ''
   OR LEN(return_reason) < 5 ;

-- return_reason cleaning and standardization
WITH cleaned_return_reason AS 
(
      SELECT 
            CASE 
                  WHEN return_reason IS NULL OR TRIM(return_reason) = '' THEN 'Unknown'
                  ELSE TRIM(dbo.TitleCase(return_reason))
            END as return_reason
      FROM bronze.[returns] 
)
SELECT 
      return_reason
FROM cleaned_return_reason
WHERE return_reason = 'Unknown' ;

--=============================================================================================
--=============================== refund_amount table overview ================================
--=============================================================================================
-- refund_amount data profiling
SELECT 
      refund_amount
FROM bronze.[returns]
WHERE refund_amount IS NULL
OR TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', '')) IS NULL
OR TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', '')) < 0 ;

-- refund_amount cleaning and standardization
WITH cleaned_refund_amount AS 
(
      SELECT 
            CASE 
                  WHEN TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', '')) IS NULL THEN NULL
                  WHEN refund_amount IS NULL OR TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', '')) < 0 THEN NULL 
                  ELSE TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', ''))
            END as refund_amount
      FROM bronze.[returns] 
)
SELECT 
      refund_amount
FROM cleaned_refund_amount
WHERE refund_amount IS NULL ;

--=============================================================================================
--=============================== refund_method table overview ================================
--=============================================================================================
-- refund_method data overview 
SELECT 
      refund_method
FROM bronze.[returns] ;

-- refund_method data profiling 
SELECT 
      refund_method 
FROM  bronze.[returns] 
WHERE refund_method IS NULL 
   OR refund_method != TRIM(refund_method)
   OR refund_method != dbo.TitleCase(refund_method) ;

-- refund_method analysis 
SELECT 
      refund_method,
      COUNT(*) as method_count, 
      CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM bronze.[returns] 
      GROUP BY refund_method 
      ORDER BY method_count DESC ;

-- refund_amount cleaning and standardization
WITH clean_refund_method AS 
(
      SELECT 
            CASE 
                  WHEN refund_method IS NULL OR TRIM(refund_method) = '' THEN 'Unknown'
                  ELSE TRIM(dbo.TitleCase(refund_method))
            END as refund_method
      FROM bronze.[returns] 
) 
SELECT 
      refund_method
FROM bronze.[returns] 
WHERE refund_method = 'Unknown' ;
--=============================================================================================
--=============================== return_channel table overview ===============================
--=============================================================================================   
-- return_channel data overview          
SELECT 
      return_channel 
FROM bronze.[returns] ;

-- return_channel data_prifiling 
SELECT 
      return_channel 
FROM  bronze.[returns] 
WHERE return_channel IS NULL 
      OR return_channel != TRIM(return_channel)
      OR return_channel != dbo.TitleCase(return_channel) ;

-- return_channel type analysis 
SELECT 
      return_channel,
      COUNT(*) as channel_count,
      CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages
FROM bronze.[returns] 
      GROUP BY return_channel
      ORDER BY channel_count DESC 

-- return_channel cleaning and standardization
SELECT 
    CASE 
        WHEN TRIM(LOWER(return_channel)) IN ('app', 'mobile app', 'mobile')   THEN 'Mobile App'
        WHEN TRIM(LOWER(return_channel)) IN ('in store', 'in-store', 'store') THEN 'In Store'
        WHEN TRIM(LOWER(return_channel)) IN ('online', 'web')                 THEN 'Online'
        WHEN TRIM(LOWER(return_channel)) = 'phone'                            THEN 'Phone Call'
        WHEN TRIM(LOWER(return_channel)) = 'catalog'                          THEN 'Catalog'
        ELSE 'Unknown'
    END AS return_channel
FROM bronze.[returns];

--=============================================================================================
--=============================== restocked table overview ====================================
--=============================================================================================
-- restocked data overvew 
SELECT 
      restocked
FROM bronze.[returns] 

-- restocked null check 
SELECT
restocked
FROM bronze.[returns] 
WHERE restocked IS NULL 

-- restocked type analysis 
SELECT 
      restocked,
      COUNT(*) as restocked_count,
      CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages
FROM bronze.[returns] 
      GROUP BY restocked
      ORDER BY restocked_count DESC 

-- restocked cleaning and standardization
WITH CleanRestocked AS 
(
      SELECT 
      CASE 
            WHEN TRIM(LOWER(restocked)) IN ('yes', 'y', '1') THEN 'Yes'
            WHEN TRIM(LOWER(restocked)) IN ('no', 'n', '0')  THEN 'No'
            ELSE 'Unknown'
      END AS restocked
      FROM bronze.[returns]
)
SELECT
      restocked,
      COUNT(*) as restocked_count,
      CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages
FROM CleanRestocked
      GROUP BY restocked
      ORDER BY restocked_count DESC ;

--=============================================================================================
--=============================== return_status table overview ================================
--=============================================================================================
-- return_status data overview 
SELECT 
      return_status
FROM bronze.[returns] ;

-- return_status data profiling 
SELECT 
      return_status
FROM  bronze.[returns] 
WHERE return_status IS NULL 
   OR return_status != TRIM(return_status)
   OR return_status != dbo.TitleCase(return_status) ;

-- return_channel type analysis 
SELECT 
      dbo.TitleCase(return_status) as return_status,
      COUNT(*) as return_status_count,
      CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages
FROM bronze.[returns] 
      GROUP BY return_status
      ORDER BY return_status_count DESC ;

-- return_channel cleaning and standardization

SELECT 
      CASE 
            WHEN return_status IS NULL THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(return_status))
      END as return_status
FROM bronze.[returns] ;

--=============================================================================================
--=============================== handled_by_emp_id table overview ============================
--=============================================================================================
-- handled_by_emp_id data ovevew 
SELECT 
      handled_by_emp_id
FROM bronze.[returns] ;

-- handled_by_emp_id data profiling 
SELECT 
      handled_by_emp_id
FROM bronze.[returns] 
WHERE handled_by_emp_id IS NULL 
   OR TRY_CONVERT(INT, handled_by_emp_id) IS NULL ;

-- handled_by_emp_id cleaning and standardization
WITH clean_data AS 
(
SELECT 
      CASE 
            WHEN handled_by_emp_id IS NULL OR TRY_CONVERT(INT, handled_by_emp_id) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, handled_by_emp_id)
      END as handled_by_emp_id
FROM bronze.[returns] 
)
SELECT 
      handled_by_emp_id 
FROM clean_data 
WHERE handled_by_emp_id IS NULL ;
--=============================================================================================
--================================== notes table overview =====================================
--=============================================================================================
-- note overvew 
SELECT 
      notes 
FROM bronze.[returns] ; 

-- notes data profiling 
SELECT 
      notes
FROM bronze.[returns] 
WHERE notes IS NULL 
   OR notes != TRIM(notes) ;


-- notes cleaning and standardization
SELECT 
      CASE 
            WHEN notes IS NULL OR LEN(TRIM(notes)) < 3 OR TRIM(notes) = '' THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(REPLACE(REPLACE(notes, CHAR(10), ''), CHAR(13), '')))
      END as notes
FROM bronze.[returns] ;

--#############################################################################################
--############################## RETURNS CLEAN DATA ###########################################
--#############################################################################################

SELECT 
       return_id
      ,original_txn_id
      ,original_order_id
      ,customer_id
      ,customer_name
      ,product_id
      ,product_name
      ,quantity_returned
      ,return_date
      ,return_reason
      ,refund_amount
      ,refund_method
      ,return_channel
      ,restocked
      ,return_status
      ,handled_by_emp_id
      ,notes
FROM 
(
      SELECT 
            CASE 
                  WHEN TRY_CONVERT(INT, return_id) < 1 OR TRY_CONVERT(INT, return_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, return_id)
            END as return_id

            ,CASE 
                  WHEN original_txn_id IS NULL THEN NULL
                  WHEN UPPER(TRIM(original_txn_id)) NOT LIKE 'TXN-%' THEN NULL
                  WHEN LEN(UPPER(TRIM(original_txn_id))) < 10 THEN NULL
                  ELSE UPPER(TRIM(original_txn_id))
            END as original_txn_id

            ,CASE 
                  WHEN original_order_id IS NULL OR TRY_CONVERT(INT, original_order_id) < 1 OR TRY_CONVERT(INT, original_order_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, original_order_id)
            END as original_order_id

            ,CASE 
                  WHEN customer_id IS NULL OR TRY_CONVERT(INT, customer_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, customer_id)
            END as customer_id

            ,CASE 
                  WHEN customer_name IS NULL OR TRIM(customer_name) = '' THEN 'Unknown'
                  ELSE dbo.TitleCase(TRIM(customer_name))
            END as customer_name

            ,CASE 
                  WHEN product_id IS NULL OR TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, product_id)
            END as product_id

            ,CASE 
                  WHEN product_name IS NULL OR TRIM(product_name) = '' THEN 'Unknown'
                  ELSE dbo.TitleCase(TRIM(product_name))
            END as product_name

            ,CASE 
                  WHEN quantity_returned IS NULL OR TRY_CONVERT(INT, quantity_returned) IS NULL OR TRY_CONVERT(INT, quantity_returned) < 1 THEN NULL 
                  ELSE TRY_CONVERT(INT, quantity_returned)
            END as quantity_returned

            ,CASE 
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

            ,CASE 
                  WHEN return_reason IS NULL OR TRIM(return_reason) = '' THEN 'Unknown'
                  ELSE TRIM(dbo.TitleCase(return_reason))
            END as return_reason

            ,CASE 
                  WHEN TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', '')) IS NULL THEN NULL
                  WHEN refund_amount IS NULL OR TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', '')) < 0 THEN NULL 
                  ELSE TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', ''))
            END as refund_amount

            ,CASE 
                  WHEN refund_method IS NULL OR TRIM(refund_method) = '' THEN 'Unknown'
                  ELSE TRIM(dbo.TitleCase(refund_method))
            END as refund_method

            ,CASE 
                WHEN TRIM(LOWER(return_channel)) IN ('app', 'mobile app', 'mobile')   THEN 'Mobile App'
                WHEN TRIM(LOWER(return_channel)) IN ('in store', 'in-store', 'store') THEN 'In Store'
                WHEN TRIM(LOWER(return_channel)) IN ('online', 'web')                 THEN 'Online'
                WHEN TRIM(LOWER(return_channel)) = 'phone'                            THEN 'Phone Call'
                WHEN TRIM(LOWER(return_channel)) = 'catalog'                          THEN 'Catalog'
                ELSE 'Unknown'
            END AS return_channel

            ,CASE 
                  WHEN TRIM(LOWER(restocked)) IN ('yes', 'y', '1') THEN 'Yes'
                  WHEN TRIM(LOWER(restocked)) IN ('no', 'n', '0')  THEN 'No'
                  ELSE 'Unknown'
            END AS restocked

            ,CASE 
                  WHEN return_status IS NULL THEN 'Unknown'
                  ELSE TRIM(dbo.TitleCase(return_status))
            END as return_status

            ,CASE 
                  WHEN handled_by_emp_id IS NULL OR TRY_CONVERT(INT, handled_by_emp_id) IS NULL THEN NULL 
                  ELSE TRY_CONVERT(INT, handled_by_emp_id)
            END as handled_by_emp_id

            ,CASE 
                  WHEN notes IS NULL OR LEN(TRIM(notes)) < 3 OR TRIM(notes) = '' THEN 'Unknown'
                  ELSE TRIM(dbo.TitleCase(REPLACE(REPLACE(notes, CHAR(10), ''), CHAR(13), '')))
            END as notes

      FROM [bronze].[returns]
)t ; 