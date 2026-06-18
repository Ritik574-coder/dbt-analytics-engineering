--#############################################################################################
--#################################### REVIEW DATA ############################################
--#############################################################################################

--=============================================================================================
--================================== review table overview ====================================
--=============================================================================================
SELECT
       [review_id]
      ,[txn_id]
      ,[customer_id]
      ,[customer_name]
      ,[product_id]
      ,[product_name]
      ,[rating]
      ,[rating_text]
      ,[review_date]
      ,[verified_purchase]
      ,[helpful_votes]
      ,[review_channel]
      ,[review_title]
  FROM [bronze].[reviews]

--=============================================================================================
--================================ review_id column cleaning ==================================
--=============================================================================================
-- review_id data overview 
SELECT 
    review_id
FROM bronze.reviews ;

-- review_id data profiling 
SELECT 
    review_id 
FROM bronze.reviews 
WHERE review_id IS NULL 
OR review_id < 1 ;

-- duplicate check in reviwe_id 
SELECT 
    * 
FROM
(
    SELECT 
    review_id ,
    ROW_NUMBER() OVER(PARTITION BY review_id ORDER BY review_id) as flag 
    FROM bronze.reviews 
)t
WHERE flag != 1 ; 

-- the reviw_id column are clean

--=============================================================================================
--================================== txn_id  column cleaning ==================================
--=============================================================================================
-- txn_id data overview 
SELECT 
     txn_id 
FROM bronze.reviews ;

-- txn_id data profiling 
SELECT 
      txn_id 
FROM  bronze.reviews 
WHERE txn_id IS NULL 
   OR txn_id != TRIM(UPPER(txn_id))
   OR txn_id NOT LIKE 'TXN-%'
   OR LEN(txn_id) < 10 ;

-- duplicate check in txn_id 
SELECT 
    * 
FROM
(
    SELECT 
    txn_id ,
    ROW_NUMBER() OVER(PARTITION BY txn_id ORDER BY txn_id) as flag 
    FROM bronze.reviews 
)t
WHERE flag != 1 ; 

--=============================================================================================
--================================== customer_name  column cleaning ===========================
--=============================================================================================
-- customer_name data overview 
SELECT 
    customer_name 
FROM bronze.reviews ;

-- customer_name data profiling 
SELECT 
      customer_name 
FROM  bronze.reviews 
WHERE customer_name IS NULL 
   OR customer_name != TRIM(customer_name)
   OR customer_name != dbo.TitleCase(customer_name)
   OR TRIM(customer_name) = ''
   OR LEN(customer_name) < 2 ;

-- Customer Name Consistency Check 
SELECT 
      r.customer_name ,
      c.full_name
FROM  bronze.reviews as r 
INNER JOIN bronze.customers as c   
ON    r.customer_id = c.customer_id 
WHERE c.full_name != r.customer_name ;

--=============================================================================================
--================================== customer_id  column cleaning =============================
--=============================================================================================
-- custome id data overview 
SELECT 
    customer_id 
FROM bronze.reviews ;

-- data type check in custoemr_id 
SELECT 
    customer_id 
FROM bronze.reviews 
WHERE TRY_CONVERT(INT, customer_id) IS NULL ;

-- customer_id data profiling 
SELECT 
    customer_id 
FROM bronze.reviews 
WHERE customer_id IS NULL 
OR customer_id < 1 ; 

-- customer id duplicate check 
SELECT 
    customer_id ,
COUNT(*) as customer_count
FROM bronze.reviews 
    GROUP BY customer_id 
    ORDER BY customer_count DESC;

--=============================================================================================
--================================== product_id  column cleaning ==============================
--=============================================================================================
-- product_id data overview 
SELECT 
    product_id 
FROM bronze.reviews ;

-- product_id column data type check 
SELECT 
    product_id 
FROM bronze.reviews 
WHERE TRY_CONVERT(INT, product_id) IS NULL ;

-- product_id data profiling 
SELECT 
      product_id 
FROM  bronze.reviews 
WHERE product_id IS NULL 
   OR product_id < 1 ;

-- product_id duplicate check 
SELECT 
    product_id ,
COUNT(*) as ProductIdCount 
FROM bronze.reviews  
    GROUP BY product_id 
    ORDER BY ProductIdCount DESC ;

--=============================================================================================
--================================== product_name  column cleaning ============================
--=============================================================================================
-- product_name data overview 
SELECT 
    product_name 
FROM bronze.reviews ;

-- product_name data profiling 
SELECT 
      product_name 
FROM  bronze.reviews 
WHERE product_name IS NULL 
   OR TRIM(product_name) != product_name
   OR TRIM(product_name) = ''
   OR dbo.TitleCase(product_name) != product_name
   OR LEN(product_name) < 2 ;
   
-- Product Name Consistency Check 
SELECT 
    r.product_name,
    p.product_name
FROM bronze.reviews as r  
INNER JOIN bronze.products as p  
ON p.product_id = r.product_id 
WHERE p.product_id != r.product_id ;

--=============================================================================================
--===================================== rating  column cleaning ===============================
--=============================================================================================
-- rating data overview 
SELECT 
    rating
FROM bronze.reviews ;

-- rating data overview 
SELECT
    rating
FROM bronze.reviews 
WHERE rating IS NULL 
   OR rating > 5 
   OR rating < 1 ;

-- rating data analysis 
SELECT 
    rating, 
    COUNT(*) as rating_count ,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as nvarchar) + '%' AS percentages 
FROM bronze.reviews 
    GROUP BY rating
    ORDER BY rating_count DESC ;

--=============================================================================================
--================================ rating_text  column cleaning ===============================
--=============================================================================================
-- rating_text data overviwe 
SELECT 
    rating_text 
FROM bronze.reviews ;

-- rating_text data profiling 
SELECT 
      rating_text 
FROM  bronze.reviews 
WHERE rating_text IS NULL 
   OR TRIM(rating_text) = ''
   OR TRIM(rating_text) != rating_text 
   OR TRIM(dbo.TitleCase(rating_text)) != rating_text 
   OR LEN(TRIM(rating_text)) < 2 ; 

-- rating_text data analysis 
SELECT 
    rating_text, 
    COUNT(*) as rating_txt_count ,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as nvarchar) + '%' AS percentages 
FROM bronze.reviews 
    GROUP BY rating_text
    ORDER BY rating_txt_count DESC ;

--=============================================================================================
--================================ reviews_date  column cleaning ==============================
--=============================================================================================
-- review_date data profiling 
SELECT 
    review_date
FROM bronze.reviews ;

-- Review Date Structure Validation
WITH review_date_analysis AS 
(
      SELECT
            TRANSLATE(
                  TRIM(LOWER(review_date)),
                  '0123456789abcdefghijklmnopqrstuvwxyz',
                  '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
            ) as review_date_pattern
      FROM bronze.reviews 
)
SELECT 
      review_date_pattern,
      COUNT(*) as count,
      CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() , 2)as nvarchar) + '%' as percentage
FROM review_date_analysis
      GROUP BY review_date_pattern
      ORDER BY count DESC;

-- review_date cleaning and standardization
WITH clean_review_date AS 
(
    SELECT 
        CASE 
            WHEN review_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,review_date)
            WHEN review_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,review_date)
            WHEN review_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,review_date)
            WHEN review_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,review_date)
        
            WHEN review_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(review_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, review_date, 101)
            WHEN review_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(review_date, 2))         > 12 THEN TRY_CONVERT(DATE, review_date, 103)
            WHEN review_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(review_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, review_date, 110)
            WHEN review_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(review_date, 2))         > 12 THEN TRY_CONVERT(DATE, review_date, 105)
            ELSE TRY_CONVERT(DATE, review_date)
        END as review_date
    FROM bronze.reviews
)
SELECT 
    review_date
FROM clean_review_date
WHERE  TRY_CONVERT(DATE, review_date) IS NULL
    OR TRY_CONVERT(DATE, review_date) > GETDATE() ;

--=============================================================================================
--============================= verified_purchase  column cleaning ============================
--=============================================================================================
-- verified_purchase data overview
SELECT 
    verified_purchase
FROM bronze.reviews ;

-- verified_purchase data profiling 
SELECT
      verified_purchase
FROM  bronze.reviews 
WHERE verified_purchase IS NULL 
   OR TRIM(verified_purchase) != verified_purchase
   OR TRIM(verified_purchase) = '';

-- verified_purchase data analysis 
SELECT 
    verified_purchase, 
    COUNT(*) as verified_purchase_count ,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as nvarchar) + '%' AS percentages 
FROM bronze.reviews 
    GROUP BY verified_purchase
    ORDER BY verified_purchase_count DESC ;

-- verified_purchase cleaning and standardization
WITH clean_verified_purchase AS 
(
    SELECT 
        CASE 
            WHEN TRIM(LOWER(verified_purchase)) IN ('1', 'y', 'yes', 'true', 'verified') THEN 'Verified'
            WHEN TRIM(LOWER(verified_purchase)) IN ('0', 'n', 'no', 'false')             THEN 'Not Verified'    
            ELSE 'Unknown'
        END AS verified_purchase
    FROM bronze.reviews
)
SELECT 
verified_purchase,
    COUNT(*) as verified_purchase_count ,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as nvarchar) + '%' AS percentages 
FROM clean_verified_purchase
    GROUP BY verified_purchase
    ORDER BY verified_purchase_count DESC ; 

--=============================================================================================
--================================= helpful_votes  column cleaning ============================
--=============================================================================================
-- helpful_votes data overview 
SELECT
    helpful_votes
FROM bronze.reviews;

-- helpful_votes data profiling 
SELECT 
    helpful_votes
FROM bronze.reviews 
WHERE helpful_votes IS NULL 
OR helpful_votes < 0 ; 

--=============================================================================================
--================================ review_channel  column cleaning ============================
--=============================================================================================
-- review_channel data overview          
SELECT 
      review_channel 
FROM bronze.reviews ;

-- review_channel data_prifiling 
SELECT 
      review_channel 
FROM  bronze.reviews
WHERE review_channel IS NULL 
      OR review_channel != TRIM(review_channel)
      OR review_channel != dbo.TitleCase(review_channel) ;

-- review_channel type analysis 
SELECT 
      review_channel,
      COUNT(*) as channel_count,
      CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages
FROM bronze.reviews
      GROUP BY review_channel
      ORDER BY channel_count DESC ;

-- review_channel cleaning and standardization
WITH clean_review_channel AS 
(
    SELECT 
        CASE 
            WHEN TRIM(LOWER(review_channel)) IN ('app', 'mobile app', 'mobile')   THEN 'Mobile App'
            WHEN TRIM(LOWER(review_channel)) IN ('in store', 'in-store', 'store') THEN 'In Store'
            WHEN TRIM(LOWER(review_channel)) IN ('online', 'web')                 THEN 'Online'
            WHEN TRIM(LOWER(review_channel))  = 'phone'                            THEN 'Phone Call'
            WHEN TRIM(LOWER(review_channel))  = 'catalog'                          THEN 'Catalog'
            ELSE 'Unknown'
        END AS review_channel
    FROM bronze.reviews
)
SELECT 
      review_channel,
      COUNT(*) as channel_count,
      CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages
FROM  clean_review_channel
      GROUP BY review_channel
      ORDER BY channel_count DESC ;
      
--=============================================================================================
--================================== review_title  column cleaning ============================
--=============================================================================================
-- review_title data overview 
SELECT 
    review_title 
FROM bronze.reviews ;

-- review_title  data profiling 
SELECT 
      review_title 
FROM  bronze.reviews 
WHERE review_title IS NULL 
   OR TRIM(review_title) = ''
   OR TRIM(dbo.TitleCase(review_title)) != review_title 
   OR LEN(TRIM(review_title)) < 2 ;

 -- review_title data analysis 
SELECT 
    review_title, 
    COUNT(*) as review_title_count ,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as nvarchar) + '%' AS percentages 
FROM bronze.reviews 
    GROUP BY review_title
    ORDER BY review_title_count DESC ;

-- review_title cleaning and standardization
SELECT 
    CASE
        WHEN REPLACE(REPLACE(TRIM(dbo.TitleCase(review_title)), CHAR(13), ''), CHAR(10), '') = '' THEN 'Unknown'
        ELSE REPLACE(REPLACE(TRIM(dbo.TitleCase(review_title)), CHAR(13), ''), CHAR(10), '')
    END as review_title
FROM bronze.reviews ;

--#############################################################################################
--############################## REVIEW CLEAN DATA ############################################
--#############################################################################################
SELECT
       review_id
      ,txn_id
      ,customer_id
      ,customer_name
      ,product_id
      ,product_name
      ,rating
      ,rating_text
      ,review_date
      ,verified_purchase
      ,helpful_votes
      ,review_channel
      ,review_title
FROM 
(
    SELECT
         review_id
        ,txn_id
        ,customer_id
        ,customer_name
        ,product_id
        ,product_name
        ,rating
        ,rating_text

        ,CASE 
            WHEN review_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,review_date)
            WHEN review_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,review_date)
            WHEN review_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,review_date)
            WHEN review_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,review_date)
        
            WHEN review_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(review_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, review_date, 101)
            WHEN review_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(review_date, 2))         > 12 THEN TRY_CONVERT(DATE, review_date, 103)
            WHEN review_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(review_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, review_date, 110)
            WHEN review_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(review_date, 2))         > 12 THEN TRY_CONVERT(DATE, review_date, 105)
            ELSE TRY_CONVERT(DATE, review_date)
        END as review_date

        ,CASE 
            WHEN TRIM(LOWER(verified_purchase)) IN ('1', 'y', 'yes', 'true', 'verified') THEN 'Verified'
            WHEN TRIM(LOWER(verified_purchase)) IN ('0', 'n', 'no', 'false')             THEN 'Not Verified'    
            ELSE 'Unknown'
        END AS verified_purchase

        ,[helpful_votes]

        ,CASE 
            WHEN TRIM(LOWER(review_channel)) IN ('app', 'mobile app', 'mobile')   THEN 'Mobile App'
            WHEN TRIM(LOWER(review_channel)) IN ('in store', 'in-store', 'store') THEN 'In Store'
            WHEN TRIM(LOWER(review_channel)) IN ('online', 'web')                 THEN 'Online'
            WHEN TRIM(LOWER(review_channel)) = 'phone'                            THEN 'Phone Call'
            WHEN TRIM(LOWER(review_channel)) = 'catalog'                          THEN 'Catalog'
            ELSE 'Unknown'
        END AS review_channel

        ,CASE
            WHEN REPLACE(REPLACE(TRIM(dbo.TitleCase(review_title)), CHAR(13), ''), CHAR(10), '') = '' THEN 'Unknown'
            ELSE REPLACE(REPLACE(TRIM(dbo.TitleCase(review_title)), CHAR(13), ''), CHAR(10), '')
        END as review_title
    FROM [bronze].[reviews]
)t ;
