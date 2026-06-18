--#############################################################################################
--#################################### PRODUCTS DATA ##########################################
--#############################################################################################

--=============================================================================================
--================================== product table overview ===================================
--=============================================================================================

SELECT TOP (1000) 
       [product_id]
      ,[sku]
      ,[product_name]
      ,[brand]
      ,[category]
      ,[sub_category]
      ,[department]
      ,[base_price_usd]
      ,[cost_price_usd]
      ,[gross_margin_pct]
      ,[weight_kg]
      ,[is_available]
      ,[stock_quantity]
      ,[reorder_level]
      ,[supplier_name]
      ,[supplier_country]
      ,[warranty_years]
      ,[rating_avg]
      ,[review_count]
      ,[launched_date]
      ,[product_url]
  FROM [bronze].[products]

/*
-- creating custom function taht help me to convert string into title case 
CREATE FUNCTION dbo.TitleCase (@text VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @result VARCHAR(255) = ''
    DECLARE @word VARCHAR(255)

    ;WITH words AS (
        SELECT value
        FROM STRING_SPLIT(LOWER(@text), ' ')
    )
    SELECT @result = @result +
        UPPER(LEFT(value,1)) +
        SUBSTRING(value,2,LEN(value)) + ' '
    FROM words

    RETURN RTRIM(@result)
END;

SELECT dbo.TitleCase('hello world') AS TitleCasedText ; */

--=============================================================================================
--================================= product_id  column cleaning ===============================
--=============================================================================================
-- Check for duplicates in product_id
SELECT 
    product_id, 
    COUNT(*) AS count
FROM bronze.products 
GROUP BY product_id
HAVING COUNT(*) > 1 ;

-- product_id data profiling
SELECT 
    product_id 
FROM bronze.products 
WHERE product_id IS NULL 
    OR product_id = ''
    OR product_id LIKE '%[^0-9]%' ; 

-- product_id cleaning and standardization
SELECT 
    CASE 
        WHEN TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, product_id)
    END as product_id
FROM bronze.products ;

--=============================================================================================
--=================================== sku  column cleaning ====================================
--=============================================================================================
-- sku data overview 
SELECT 
    sku
FROM bronze.products ; 

-- sku data profiling 
SELECT 
      sku 
FROM  bronze.products
WHERE sku IS NULL 
   OR sku = ''
   OR sku != TRIM(sku)
   OR sku != UPPER(sku)
   OR LEN(sku) != 13 ;

-- sku cleaning and standardization
SELECT 
    CASE 
        WHEN sku = '' OR sku IS NULL OR LEN(sku) != 13 THEN 'Unknown'
        ELSE TRIM(UPPER(sku))
    END as sku
FROM bronze.products ;

--=============================================================================================
--================================ product_name  column cleaning ==============================
--=============================================================================================
-- product_name data overview 
SELECT 
    product_name
FROM bronze.products ;

-- product_name data profiling 
SELECT 
      product_name
FROM  bronze.products 
WHERE product_name IS NULL 
   OR product_name = '' 
   OR product_name != TRIM(product_name) 
   OR product_name != dbo.TitleCase(product_name) ;

-- product_name distribution analysis
SELECT 
      product_name,
      COUNT(*) product_count
FROM  bronze.products 
    GROUP BY product_name
    HAVING COUNT(*) > 1 ;

-- product_name cleaning and standardization
SELECT 
    CASE 
        WHEN product_name = '' OR product_name IS NULL THEN 'Unknown'
        ELSE dbo.TitleCase(TRIM(product_name))
    END as product_name
FROM bronze.products ;

--=============================================================================================
--================================ brand  column cleaning =====================================
--=============================================================================================
-- brand data overview 
SELECT 
    brand
FROM bronze.products ;

-- brand data profiling 
SELECT 
      brand
FROM  bronze.products 
WHERE brand IS NULL 
   OR brand = '' 
   OR brand != TRIM(brand) 
   OR brand != dbo.TitleCase(brand) ;

-- brand distribution analysis
SELECT 
      brand,
      COUNT(*) brand_count
FROM  bronze.products 
    GROUP BY brand
    HAVING COUNT(*) > 1 ;

-- brand cleaning and standardization
SELECT 
    CASE 
        WHEN brand = '' OR brand IS NULL THEN 'Unknown'
        ELSE dbo.TitleCase(TRIM(brand))
    END as brand
FROM bronze.products ;

--=============================================================================================
--================================ category  column cleaning ==================================
--=============================================================================================
-- category data overview 
SELECT 
    category
FROM bronze.products ;

-- category data profiling 
SELECT 
      category
FROM  bronze.products 
WHERE category IS NULL 
   OR category = '' 
   OR category != TRIM(category) 
   OR category != dbo.TitleCase(category) ;

-- category unique value analysis
SELECT DISTINCT 
    category
FROM bronze.products ;

-- category case-sensitivity analysis
SELECT  
    category COLLATE Latin1_General_CI_AS as category,
    COUNT(*) category_count
FROM bronze.products 
GROUP BY category COLLATE Latin1_General_CI_AS
ORDER BY category_count DESC ;

-- category distribution analysis
SELECT 
      category,
      COUNT(*) category_count
FROM  bronze.products 
    GROUP BY category
    HAVING COUNT(*) >= 1 ;

-- category cleaning and standardization
SELECT 
    CASE 
        WHEN category IS NULL OR category = '' THEN 'Unknown'
        ELSE TRIM(dbo.titleCase(category))
    END AS category
FROM bronze.products ;

--=============================================================================================
--================================ sub_category  column cleaning ==============================
--=============================================================================================
--  sub_category data overview
SELECT  
    sub_category
FROM bronze.products ;

--  sub_category data profiling
SELECT 
      sub_category
FROM  bronze.products 
WHERE sub_category IS NULL 
   OR sub_category = ''
   OR sub_category != TRIM(sub_category) 
   OR sub_category != dbo.TitleCase(sub_category) ;

-- sub_category distribution analysis
SELECT 
      TRIM(LOWER(sub_category)) as sub_category,
      COUNT(*) sub_category_count
FROM  bronze.products 
    GROUP BY TRIM(LOWER(sub_category))
    HAVING COUNT(*) > 1 
    ORDER BY sub_category_count DESC ;

-- sub_category unique value analysis
SELECT DISTINCT 
    TRIM(LOWER(sub_category)) as sub_category
FROM bronze.products ;

-- sub_category cleaning and standardization
SELECT 
    CASE 
        WHEN sub_category IS NULL OR sub_category = '' THEN 'Unknown'
        ELSE dbo.TitleCase(TRIM(sub_category))
    END AS sub_category
FROM bronze.products ;

--=============================================================================================
--================================ department  column cleaning ================================
--=============================================================================================
-- department data overview
SELECT 
    department
FROM bronze.products ;

-- department data profiling
SELECT 
      department
FROM  bronze.products 
WHERE department IS NULL 
   OR department = ''
   OR department != TRIM(department)
   OR department != dbo.TitleCase(department) ;

-- department distribution analysis
SELECT 
      department,
      COUNT(*) department_count,
      CAST(ROUND(COUNT(*) * 100.0 /SUM(COUNT(*)) OVER(), 2) AS nvarchar) AS department_percentage
FROM  bronze.products 
    GROUP BY department
    ORDER BY department_count DESC ;

-- department cleaning and standardization
SELECT 
    CASE 
        WHEN department IS NULL OR department = '' THEN 'Unknown'
        ELSE dbo.TitleCase(TRIM(department))
    END AS department
FROM bronze.products ;

--=============================================================================================
--================================ base_price_usd  column cleaning ============================
--=============================================================================================
-- data profiling for base_price_usd
SELECT 
    base_price_usd 
FROM bronze.products 
WHERE base_price_usd IS NULL 
   OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', '')) IS NULL ;

-- base_price_usd cleaning and standardization
WITH CleanBasePrice AS 
(
    SELECT 
        CASE 
            WHEN base_price_usd IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', '')) IS NULL THEN NULL
            WHEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', ''))
        END AS base_price_usd
    FROM bronze.products 
)
SELECT 
    *
FROM CleanBasePrice
WHERE base_price_usd IS NULL ;

--=============================================================================================
--================================ cost_price_usd  column cleaning ============================
--=============================================================================================
-- data profiling for cost_price_usd
SELECT 
    cost_price_usd 
FROM bronze.products 
WHERE cost_price_usd IS NULL 
   OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', '')) IS NULL ;

-- cost_price_usd cleaning and standardization
WITH CleanCostPrice AS 
(
    SELECT 
        CASE 
            WHEN cost_price_usd IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', '')) IS NULL THEN NULL
            WHEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', ''))
        END AS cost_price_usd
    FROM bronze.products 
)
SELECT 
    *
FROM CleanCostPrice
WHERE cost_price_usd IS NULL ;

--=============================================================================================
--================================ gross_margin_pct  column cleaning ==========================
--=============================================================================================
-- data profiling for gross_margin_pct
SELECT 
    gross_margin_pct
FROM bronze.products 
WHERE gross_margin_pct IS NULL 
   OR TRY_CONVERT(DECIMAL(5,1), gross_margin_pct) IS NULL
   OR TRY_CONVERT(DECIMAL(5,1), gross_margin_pct) > 100 ;

-- gross_margin_pct cleaning and standardization
WITH CleanGrossMargin AS 
(
    SELECT 
        CASE 
            WHEN gross_margin_pct IS NULL OR TRY_CONVERT(DECIMAL(5,2), gross_margin_pct) IS NULL THEN NULL
            WHEN TRY_CONVERT(DECIMAL(5,1), gross_margin_pct) > 100 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(5,1), gross_margin_pct)
        END AS gross_margin_pct
    FROM bronze.products 
)
SELECT 
    *
FROM CleanGrossMargin
WHERE gross_margin_pct IS NULL ;

--=============================================================================================
--================================== weight_kg  column cleaning ===============================
--=============================================================================================
-- data profiling for weight_kg
SELECT 
    weight_kg
FROM bronze.products 
WHERE weight_kg IS NULL 
    OR TRY_CONVERT(DECIMAL(5,2), weight_kg) IS NULL 
    OR TRY_CONVERT(DECIMAL(5,2), weight_kg) <= 0;

-- weight_kg cleaning and standardization 
WITH CleanWeightKG AS 
(
    SELECT 
        CASE 
            WHEN TRY_CONVERT(DECIMAL(5,2), weight_kg) IS NULL THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(5,2), weight_kg)
        END as weight_kg
    FROM bronze.products   
)
SELECT 
    *
FROM CleanWeightKG 
WHERE weight_kg IS NULL ;

--=============================================================================================
--================================== is_available  column cleaning ============================
--=============================================================================================
-- data profiling for is_available
SELECT 
    is_available
FROM bronze.products 
WHERE is_available IS NULL 
    OR is_available = '' ;

-- is_available distribution analysis
SELECT 
    is_available,
    COUNT(*) value_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages 
FROM bronze.products
    GROUP BY is_available
    ORDER BY value_count DESC ;

-- is_available cleaning and standardazition 
WITH is_av_analysis AS 
(
    SELECT 
        CASE
            WHEN LOWER(TRIM(is_available)) IN ('a','y','ye','1','t','tr','in','i') THEN 'Available'
            WHEN LOWER(TRIM(is_available)) IN ('n','no','o','ou') THEN 'Not Available'
            WHEN LOWER(TRIM(is_available)) IN ('d','di') THEN 'Discontinued'
            ELSE 'Unknown'
        END AS availability_status
    FROM bronze.products
)
SELECT 
    availability_status,
    COUNT(*) as value_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages 
FROM is_av_analysis 
GROUP BY availability_status
ORDER BY value_count DESC ;

--=============================================================================================
--================================== stock_quantity  column cleaning ===========================
--=============================================================================================
-- stock_quentory data profiling 
SELECT 
    stock_quantity
FROM bronze.products
WHERE stock_quantity IS NULL 
    OR TRY_CONVERT(INT , stock_quantity) IS NULL
    OR TRY_CONVERT(INT , stock_quantity) < 0 ;

-- stock_quantity NULL distribution across availability status
SELECT 
    is_available,
    COUNT(*) AS total_count
FROM bronze.products
WHERE stock_quantity IS NULL
GROUP BY is_available;

-- stock_quantity NULL distribution across product categories
SELECT 
    category,
    COUNT(*) AS total_count
FROM bronze.products
WHERE stock_quantity IS NULL
GROUP BY category;

-- stock_quantity cleaning and standardazition
WITH CleanStockQuantity AS 
(
    SELECT 
        CASE 
            WHEN stock_quantity IS NULL OR TRY_CONVERT(INT , stock_quantity) IS NULL OR TRY_CONVERT(INT , stock_quantity) < 0 THEN NULL
            ELSE TRY_CONVERT(INT , stock_quantity)
        END AS stock_quantity
    FROM bronze.products 
)
SELECT 
    *
FROM CleanStockQuantity 
WHERE stock_quantity IS NULL ;
--=============================================================================================
--================================== reorder_level  column cleaning ===========================
--=============================================================================================
-- reorder_level data overview 
SELECT 
    stock_quantity ,
    reorder_level
FROM bronze.products ;

-- reorder_level data profiling 
SELECT 
reorder_level
FROM bronze.products 
WHERE reorder_level IS NULL 
    OR TRY_CONVERT(INT , reorder_level) IS NULL
    OR TRY_CONVERT(INT , reorder_level) < 0 ;

-- reorder_level cleaning and standardazition 
WITH CleanReorderLevel AS 
(
    SELECT 
        CASE 
            WHEN reorder_level IS NULL OR TRY_CONVERT(INT , reorder_level) IS NULL OR TRY_CONVERT(INT , reorder_level) < 0 THEN NULL
            ELSE TRY_CONVERT(INT , reorder_level)
        END AS reorder_level
    FROM bronze.products 
)
SELECT 
    *
FROM CleanReorderLevel 
WHERE reorder_level IS NULL ;

--=============================================================================================
--================================== supplier_name  column cleaning ===========================
--=============================================================================================
-- supplier_name data profiling 
SELECT 
    supplier_name 
FROM bronze.products 
WHERE supplier_name IS NULL 
   OR supplier_name = ''
   OR supplier_name != TRIM(dbo.TitleCase(supplier_name));

-- supplier_name cleaning and standardazition
WITH CleanSupplierName AS 
(
    SELECT 
        CASE 
            WHEN supplier_name IS NULL OR supplier_name = '' THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(supplier_name))
        END as supplier_name
    FROM bronze.products 
)
SELECT 
    supplier_name 
FROM CleanSupplierName 
WHERE supplier_name = 'Unknown' ;

--=============================================================================================
--================================ supplier_country  column cleaning ==========================
--=============================================================================================
-- supplier_country data profiling 
SELECT 
    supplier_country
FROM bronze.products
WHERE supplier_country IS NULL
   OR TRIM(supplier_country) = ''
   OR supplier_country != TRIM(dbo.TitleCase(supplier_country)) ;

-- supplier_country cleaning and standardazition
WITH CleanSupplierCountry AS 
(
    SELECT 
        CASE 
            WHEN supplier_country IS NULL OR supplier_country = '' THEN 'Unknown'
            WHEN supplier_country = 'USA' THEN 'United States'
            ELSE TRIM(dbo.TitleCase(supplier_country))
        END as supplier_country
    FROM bronze.products 
)
SELECT 
    supplier_country 
FROM CleanSupplierCountry
WHERE supplier_country = 'Unknown'
--=============================================================================================
--================================= warranty_years  column cleaning ===========================
--=============================================================================================
-- warranty_years data profiling
SELECT 
    warranty_years 
FROM bronze.products 
WHERE warranty_years IS NULL 
   OR TRY_CONVERT(INT, warranty_years) IS NULL 
   OR TRY_CONVERT(INT, warranty_years) < 0 ;

-- warranty_years cleaning and standardazition
WITH CleanWarrantyYear AS 
(
    SELECT 
        CASE 
            WHEN TRY_CONVERT(INT, warranty_years) IS NULL OR TRY_CONVERT(INT, warranty_years) < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, warranty_years)
        END as warranty_years
    FROM bronze.products 
)
SELECT 
    warranty_years 
FROM CleanWarrantyYear 
WHERE warranty_years IS NULL ;

--=============================================================================================
--================================== rating_avg  column cleaning ==============================
--=============================================================================================
-- rating_avg data overveiw 
SELECT 
    rating_avg 
FROM bronze.products ;

-- rating_avg data profiling 
SELECT 
    rating_avg
FROM bronze.products 
WHERE rating_avg IS NULL
OR TRY_CONVERT(DECIMAL(3,1), rating_avg) IS NULL ;

-- rating_avg cleaning and standardazition
WITH CleanRatingAvg AS 
(
    SELECT 
        CASE 
            WHEN TRY_CONVERT(DECIMAL(3,1), rating_avg) IS NULL THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(3,1), rating_avg)
        END as rating_avg
    FROM bronze.products 
)
SELECT 
    rating_avg
FROM CleanRatingAvg
WHERE rating_avg IS NULL ;

--=============================================================================================
--================================== review_count  column cleaning ============================
--=============================================================================================
-- review_count data overveiw 
SELECT 
    review_count 
FROM bronze.products ;

-- review_count data profiling 
SELECT 
    review_count
FROM bronze.products 
WHERE review_count IS NULL
OR TRY_CONVERT(INT, review_count) IS NULL ;

-- review_count cleaning and standardazition
WITH CleanReviewCount AS 
(
    SELECT 
        CASE 
            WHEN TRY_CONVERT(INT, review_count) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, review_count)
        END as review_count
    FROM bronze.products 
)
SELECT 
    review_count
FROM CleanReviewCount
WHERE review_count IS NULL ;

--=============================================================================================
--================================== launched_date  column cleaning ===========================
--=============================================================================================
-- launched_date data overview 
SELECT
    launched_date
FROM bronze.products ;

-- launched_date pattern analysis
WITH pattern_analysis AS 
(
SELECT 
TRANSLATE(
    TRIM(LOWER(launched_date)),
    '0123456789abcdefghijklmnopqrstuvwxyz',
    '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
) date_pattern
FROM bronze.products
)
SELECT 
    date_pattern,
    COUNT(*) as pattern_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages 
FROM pattern_analysis 
GROUP BY date_pattern
ORDER BY pattern_count DESC ;

-- launched_date data profiling
SELECT
    launched_date
FROM bronze.products
WHERE launched_date IS NULL
    OR TRY_CONVERT(DATE, launched_date) IS NULL
    OR TRY_CONVERT(DATE, launched_date) > GETDATE() ;

-- launched_date distribution analysis
WITH clean_date AS 
(
    SELECT 
        CASE 
            WHEN launched_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,launched_date)
            WHEN launched_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,launched_date)
            WHEN launched_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,launched_date)
            WHEN launched_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,launched_date)
        
            WHEN launched_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(launched_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, launched_date, 101)
            WHEN launched_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(launched_date, 2))         > 12 THEN TRY_CONVERT(DATE, launched_date, 103)
            WHEN launched_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(launched_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, launched_date, 110)
            WHEN launched_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(launched_date, 2))         > 12 THEN TRY_CONVERT(DATE, launched_date, 105)
            ELSE TRY_CONVERT(DATE, launched_date)
        END as launched_date
    FROM bronze.products 
)
SELECT 
    launched_date
FROM clean_date 
WHERE TRY_CONVERT(DATE, launched_date) IS NULL
    OR TRY_CONVERT(DATE, launched_date) > GETDATE() ;
    
--=============================================================================================
--================================== product_url  column cleaning =============================
--=============================================================================================
-- product_url data profiling 
SELECT 
      product_url 
FROM  bronze.products 
WHERE product_url IS NULL 
    OR product_url = ''
    OR product_url NOT LIKE 'https://%' 
    OR product_url != TRIM(LOWER(product_url)) 
    OR product_url != REPLACE(REPLACE(TRIM(LOWER(product_url)), CHAR(13), ''),CHAR(10), '') ;

-- product_url cleaning and standardazition 
WITH url_analysis AS 
(
SELECT 
    CASE 
        WHEN product_url IS NULL OR product_url = '' OR product_url NOT LIKE 'https://%' THEN 'Unknown'
        ELSE REPLACE(REPLACE(TRIM(LOWER(product_url)), CHAR(13), ''),CHAR(10), '')
    END as product_url
FROM bronze.products 
) 
SELECT 
    product_url 
FROM url_analysis ;

--#############################################################################################
--############################## PRODUCTS CLEAN DATA ##########################################
--#############################################################################################

SELECT 
     product_id
    ,sku
    ,product_name
    ,brand
    ,category
    ,sub_category
    ,department
    ,base_price_usd
    ,cost_price_usd
    ,gross_margin_pct
    ,weight_kg
    ,is_available
    ,stock_quantity
    ,reorder_level
    ,supplier_name
    ,supplier_country
    ,warranty_years
    ,rating_avg
    ,review_count
    ,launched_date
    ,product_url
FROM 
(
    SELECT
        CASE 
            WHEN TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, product_id)
        END as product_id

        ,CASE 
            WHEN TRIM(sku) = '' OR sku IS NULL OR LEN(TRIM(sku)) != 13 THEN 'Unknown'
            ELSE TRIM(UPPER(sku))
        END as sku

        ,CASE 
            WHEN TRIM(product_name) = '' OR product_name IS NULL THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(product_name))
        END as product_name

        ,CASE 
            WHEN TRIM(brand) = '' OR brand IS NULL THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(brand))
        END as brand

        ,CASE 
            WHEN category IS NULL OR TRIM(category) = '' THEN 'Unknown'
            ELSE TRIM(dbo.titleCase(category))
        END AS category

        ,CASE 
            WHEN sub_category IS NULL OR TRIM(sub_category) = '' THEN 'Unknown'
            ELSE dbo.TitleCase(TRIM(sub_category))
        END AS sub_category

        ,CASE 
            WHEN department IS NULL OR TRIM(department) = '' THEN 'Unknown'
            ELSE dbo.TitleCase(TRIM(department))
        END AS department

        ,CASE 
            WHEN base_price_usd IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', '')) IS NULL THEN NULL
            WHEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(base_price_usd, ',', ''),'$', ''))
        END AS base_price_usd

        ,CASE 
            WHEN cost_price_usd IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', '')) IS NULL THEN NULL
            WHEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price_usd, ',', ''),'$', ''))
        END AS cost_price_usd

        ,CASE 
            WHEN gross_margin_pct IS NULL OR TRY_CONVERT(DECIMAL(5,1), gross_margin_pct) IS NULL THEN NULL
            WHEN TRY_CONVERT(DECIMAL(5,1), gross_margin_pct) > 100 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(5,1), gross_margin_pct)
        END AS gross_margin_pct

        ,CASE 
            WHEN TRY_CONVERT(DECIMAL(5,2), weight_kg) IS NULL OR TRY_CONVERT(DECIMAL(5,2), weight_kg) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(5,2), weight_kg)
        END as weight_kg

        ,CASE
            WHEN LOWER(TRIM(is_available)) IN ('a','y','ye','1','t','tr','in','i') THEN 'Available'
            WHEN LOWER(TRIM(is_available)) IN ('n','no','o','ou') THEN 'Not Available'
            WHEN LOWER(TRIM(is_available)) IN ('d','di') THEN 'Discontinued'
            ELSE 'Unknown'
        END AS is_available

        ,CASE 
            WHEN stock_quantity IS NULL OR TRY_CONVERT(INT , stock_quantity) IS NULL OR TRY_CONVERT(INT , stock_quantity) < 0 THEN NULL
            ELSE TRY_CONVERT(INT , stock_quantity)
        END AS stock_quantity

        ,CASE 
            WHEN reorder_level IS NULL OR TRY_CONVERT(INT , reorder_level) IS NULL OR TRY_CONVERT(INT , reorder_level) < 0 THEN NULL
            ELSE TRY_CONVERT(INT , reorder_level)
        END AS reorder_level

        ,CASE 
            WHEN supplier_name IS NULL OR TRIM(supplier_name) = '' THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(supplier_name))
        END as supplier_name

        ,CASE 
            WHEN supplier_country IS NULL OR TRIM(supplier_country) = '' THEN 'Unknown'
            WHEN supplier_country = 'USA' THEN 'United States'
            ELSE TRIM(dbo.TitleCase(supplier_country))
        END as supplier_country

        ,CASE 
            WHEN TRY_CONVERT(INT, warranty_years) IS NULL OR TRY_CONVERT(INT, warranty_years) < 0  OR TRY_CONVERT(INT, warranty_years) > 20 THEN NULL 
            ELSE TRY_CONVERT(INT, warranty_years)
        END as warranty_years

        ,CASE 
            WHEN TRY_CONVERT(DECIMAL(3,1), rating_avg) IS NULL OR TRY_CONVERT(DECIMAL(3,1), rating_avg) < 0 OR TRY_CONVERT(DECIMAL(3,1), rating_avg) > 5 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(3,1), rating_avg)
        END as rating_avg

        ,CASE 
            WHEN TRY_CONVERT(INT, review_count) IS NULL OR TRY_CONVERT(INT, review_count) < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, review_count)
        END as review_count

        ,CASE 
            WHEN launched_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,launched_date)
            WHEN launched_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,launched_date)
            WHEN launched_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,launched_date)
            WHEN launched_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,launched_date)
        
            WHEN launched_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(launched_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, launched_date, 101)
            WHEN launched_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(launched_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, launched_date, 110)
            WHEN launched_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(launched_date, 2))         > 12 THEN TRY_CONVERT(DATE, launched_date, 103)
            WHEN launched_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(launched_date, 2))         > 12 THEN TRY_CONVERT(DATE, launched_date, 105)
            ELSE TRY_CONVERT(DATE, launched_date)
        END as launched_date

        ,CASE 
            WHEN product_url IS NULL OR TRIM(product_url) = '' OR product_url NOT LIKE 'https://%' THEN 'Unknown'
            ELSE REPLACE(REPLACE(TRIM(LOWER(product_url)), CHAR(13), ''),CHAR(10), '')
        END as product_url

    FROM [bronze].[products]
)t ;
