--#############################################################################################
--#################################### EMPLOYEE DATA ##########################################
--#############################################################################################

--=============================================================================================
--=========================== inventory_snapshots table overview ==============================
--=============================================================================================
SELECT 
       [snapshot_date]
      ,[product_id]
      ,[product_name]
      ,[sku]
      ,[category]
      ,[stock_on_hand]
      ,[stock_reserved]
      ,[stock_available]
      ,[reorder_level]
      ,[unit_cost]
      ,[unit_price]
      ,[inventory_value]
      ,[warehouse_location]
      ,[store_id]
  FROM [bronze].[inventory_snapshots]  

--=============================================================================================
--============================== snapshot_date column cleaning ================================
--=============================================================================================
-- snapshot_date overview 
SELECT 
    snapshot_date
FROM bronze.inventory_snapshots ;

-- snapshot_date pattern analysis 
WITH date_pattern_analysis AS 
(
    SELECT 
        TRANSLATE(
            TRIM(LOWER(snapshot_date)), 
            '0123456789abcdefghijklmnopqrstuvwxyz',
            '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
        ) AS date_pattern 
    FROM bronze.inventory_snapshots 
)
SELECT 
    date_pattern,
    COUNT(*) AS pattern_count,
    CAST(
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS NVARCHAR
    ) + '%' AS percentage 
FROM date_pattern_analysis 
GROUP BY date_pattern
ORDER BY pattern_count DESC ;

-- MM/DD/YYYY format analysis 
SELECT
    snapshot_date
FROM bronze.inventory_snapshots
WHERE snapshot_date LIKE '__/__/____' ;

-- MM/DD/YYYY month validation check 
SELECT
    snapshot_date
FROM bronze.inventory_snapshots
WHERE snapshot_date LIKE '__/__/____' 
    AND SUBSTRING(snapshot_date, 4, 2) > 12;

-- DD/MM/YYYY day validation check 
SELECT
    snapshot_date
FROM bronze.inventory_snapshots
WHERE snapshot_date LIKE '__/__/____' 
    AND LEFT(snapshot_date, 2) > 12;

-- Mon DD, YYYY format analysis 
SELECT
    snapshot_date
FROM bronze.inventory_snapshots
WHERE snapshot_date LIKE '[A-Z][a-z][a-z] __, ____' ;  -- DONE

-- YYYY/MM/DD format analysis 
SELECT
    snapshot_date
FROM bronze.inventory_snapshots
WHERE snapshot_date LIKE '____/__/__' ;  -- DONE

-- MM-DD-YYYY format analysis 
SELECT
    snapshot_date
FROM bronze.inventory_snapshots
WHERE snapshot_date LIKE '__-__-____' ;

-- MM-DD-YYYY month validation check 
SELECT
    snapshot_date
FROM bronze.inventory_snapshots
WHERE snapshot_date LIKE '__-__-____' 
    AND SUBSTRING(snapshot_date, 4, 2) > 12;

-- DD-MM-YYYY day validation check 
SELECT
    snapshot_date
FROM bronze.inventory_snapshots
WHERE snapshot_date LIKE '__-__-____' 
    AND LEFT(snapshot_date, 2) > 12;

-- YYYY-MM-DD format analysis 
SELECT
    snapshot_date
FROM bronze.inventory_snapshots
WHERE snapshot_date LIKE '____-__-__' ;  -- DONE

-- Month DD, YYYY format analysis 
SELECT
    snapshot_date
FROM bronze.inventory_snapshots
WHERE snapshot_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' ;  -- DONE

-- Final snapshot_date cleaning validation 
WITH snapshot_date_analysis AS 
(
    SELECT 
        CASE 
            WHEN snapshot_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE, snapshot_date)
            WHEN snapshot_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE, snapshot_date)
            WHEN snapshot_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE, snapshot_date)
            WHEN snapshot_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE, snapshot_date)

            WHEN snapshot_date LIKE '__/__/____' AND SUBSTRING(snapshot_date, 4, 2) > 12 THEN TRY_CONVERT(DATE, snapshot_date, 101)
            WHEN snapshot_date LIKE '__/__/____' AND LEFT(snapshot_date, 2) > 12         THEN TRY_CONVERT(DATE, snapshot_date, 103)
            WHEN snapshot_date LIKE '__-__-____' AND SUBSTRING(snapshot_date, 4, 2) > 12 THEN TRY_CONVERT(DATE, snapshot_date, 110)
            WHEN snapshot_date LIKE '__-__-____' AND LEFT(snapshot_date, 2) > 12         THEN TRY_CONVERT(DATE, snapshot_date, 105)
            ELSE TRY_CONVERT(DATE, snapshot_date)
        END AS snapshot_date
    FROM bronze.inventory_snapshots
)
SELECT 
    snapshot_date
FROM snapshot_date_analysis
WHERE snapshot_date IS NULL ;

--=============================================================================================
--================================= product_id column cleaning ================================
--=============================================================================================
-- product_id data profiling
SELECT 
    product_id
FROM bronze.inventory_snapshots 
WHERE product_id IS NULL 
OR product_id = ''
OR TRY_CONVERT(INT, product_id) IS NULL ;

-- product_id distribution analysis 
SELECT 
    product_id,
    COUNT(*) product_id_count,
    CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' as percentages
FROM bronze.inventory_snapshots 
    GROUP BY product_id 
    ORDER BY product_id_count ;

-- Final product_id cleaning validation 
SELECT 
    CASE 
        WHEN TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, product_id)
    END  as product_id
FROM bronze.inventory_snapshots  ;

--=============================================================================================
--================================= product_name column cleaning ==============================
--=============================================================================================
-- producnt_name data profiling 
SELECT 
      product_name 
FROM  bronze.inventory_snapshots 
WHERE product_name IS NULL 
   OR product_name = ''
   OR product_name != TRIM(product_name)
   OR LEN(product_name) < 4 ;

-- product_name distribution analysis 
SELECT 
    product_name,
    COUNT(*) product_name_count,
    CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' as percentages
FROM bronze.inventory_snapshots 
    GROUP BY product_name 
    ORDER BY product_name_count ;

-- Final Product_name cleaning validation
SELECT 
    CASE 
        WHEN product_name IS NULL OR product_name = '' THEN 'Unknown'
        ELSE TRIM(product_name)
    END as product_name
FROM bronze.inventory_snapshots 

--=============================================================================================
--==================================== sku column cleaning ====================================
--=============================================================================================
-- sku data profiling 
SELECT 
      sku
FROM  bronze.inventory_snapshots 
WHERE sku IS NULL 
   OR sku = ''
   OR sku != TRIM(product_name)
   OR LEN(sku) < 4 ;

-- product_name distribution analysis 
SELECT 
    sku,
    COUNT(*) sku_count,
    CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' as percentages
FROM bronze.inventory_snapshots 
    GROUP BY sku 
    ORDER BY sku_count ;

-- Final sku cleaning validation
SELECT 
    CASE 
        WHEN sku IS NULL OR sku = '' THEN 'Unknown'
        ELSE TRIM(sku)
    END as sku
FROM bronze.inventory_snapshots ;

--=============================================================================================
--=============================== category column cleaning ====================================
--=============================================================================================
-- category data profiling 
SELECT 
    category 
FROM bronze.inventory_snapshots 
WHERE category IS NULL 
    OR category = ''
    OR category != TRIM(category) ;

SELECT DISTINCT 
    category 
FROM bronze.inventory_snapshots

-- category distribution analysis 
SELECT 
    category,
    COUNT(*) category_count,
    CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' as percentages
FROM bronze.inventory_snapshots 
    GROUP BY category
    HAVING COUNT(*) > 1
    ORDER BY category_count DESC;

-- category case-sensitive distribution analysis 
SELECT 
    category COLLATE Latin1_General_CS_AS as category ,
    COUNT(*) as total_count
FROM bronze.inventory_snapshots
    GROUP BY category COLLATE Latin1_General_CS_AS
    ORDER BY total_count DESC ;

-- category cleaning and standardization 
WITH category_analysis AS 
(
    SELECT
        CASE 
            WHEN TRIM(LOWER(category)) = 'electronics' THEN 'Electronics'
            WHEN TRIM(LOWER(category)) = 'clothing'    THEN 'Clothing'
            WHEN TRIM(LOWER(category)) = 'kitchen'     THEN 'Kitchen'
            WHEN TRIM(LOWER(category)) = 'office'      THEN 'Office'
            WHEN TRIM(LOWER(category)) = 'sports'      THEN 'Sports'
            WHEN TRIM(LOWER(category)) = 'health'      THEN 'Health'
            WHEN TRIM(LOWER(category)) = 'beauty'      THEN 'Beauty'
            WHEN TRIM(LOWER(category)) = 'footwear'    THEN 'Footwear'
            WHEN TRIM(LOWER(category)) = 'toys'        THEN 'Toys'
            WHEN TRIM(LOWER(category)) = 'bags'        THEN 'Bags'
            ELSE 'Unknown'
        END AS category
    FROM bronze.inventory_snapshots
)
SELECT 
    category COLLATE Latin1_General_CS_AS as category ,
    COUNT(*) as total_count
FROM category_analysis
    GROUP BY category COLLATE Latin1_General_CS_AS
    ORDER BY total_count DESC ;

--=============================================================================================
--=============================== stock_on_hand column cleaning ===============================
--=============================================================================================
-- stock_on_hand data overview 
SELECT 
stock_on_hand 
FROM bronze.inventory_snapshots ;

--stock_on_hand  data profiling 
SELECT 
      stock_on_hand 
FROM  bronze.inventory_snapshots 
WHERE stock_on_hand IS NULL
   OR stock_on_hand < 0 
   OR TRY_CONVERT(INT, stock_on_hand) IS NULL  ;

--Stock_on_hand cleaning and standardization 
SELECT 
    CASE 
        WHEN TRY_CONVERT(INT, stock_on_hand) IS NULL OR stock_on_hand < 0 THEN NULL 
        ELSE TRY_CONVERT(INT, stock_on_hand)
    END AS stock_on_hand
FROM bronze.inventory_snapshots
WHERE stock_on_hand IS NULL ;

--=============================================================================================
--=============================== stock_reserved column cleaning ==============================
--=============================================================================================
-- stock_reserved data overview 
SELECT 
     stock_reserved 
FROM bronze.inventory_snapshots ;

-- stock_reserved data profiling 
SELECT
      stock_reserved 
FROM  bronze.inventory_snapshots 
WHERE stock_reserved IS NULL 
   OR stock_reserved < 0 
   OR TRY_CONVERT(INT, stock_reserved) IS NULL ;

-- stock_reserved cleaning and standardization
SELECT 
    CASE 
        WHEN stock_reserved < 0 OR TRY_CONVERT(INT, stock_reserved) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, stock_reserved)
    END  as stock_reserved
    FROM bronze.inventory_snapshots 
WHERE stock_reserved IS NULL ;

--=============================================================================================
--============================= stock_available column cleaning ===============================
--=============================================================================================
-- stock_available data overview 
SELECT 
stock_available
FROM bronze.inventory_snapshots 

-- stock_available data profilint 
SELECT 
      stock_available 
FROM  bronze.inventory_snapshots 
WHERE stock_available IS NULL
   OR stock_available < 0
   OR TRY_CONVERT(INT, stock_available) IS NULL ;

-- null count in stock_available
SELECT 
      COUNT(*) as null_count
FROM  bronze.inventory_snapshots
WHERE stock_available IS NULL ;

-- not null count in stock_available
SELECT 
      stock_available
FROM  bronze.inventory_snapshots 
WHERE stock_available IS NOT NULL ;

-- stock_available cleaning and standardization
SELECT 
    CASE 
        WHEN stock_available IS NULL THEN stock_on_hand - stock_reserved 
        WHEN TRY_CONVERT(INT, stock_available) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, stock_available)
    END as stock_available
FROM bronze.inventory_snapshots ;

--=============================================================================================
--=============================== reorder_level column cleaning ===============================
--=============================================================================================
-- reorder_level data overview 
SELECT 
    reorder_level
FROM bronze.inventory_snapshots ;

--reorder_level data profiling 
SELECT 
      reorder_level
FROM  bronze.inventory_snapshots 
WHERE reorder_level IS NULL 
   OR reorder_level < 0 
   OR TRY_CONVERT(INT, reorder_level) IS NULL ;

-- reorder_level cleaning and standardization
SELECT 
    CASE 
        WHEN reorder_level IS NULL OR reorder_level < 0 OR TRY_CONVERT(INT, reorder_level) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, reorder_level)
    END as reorder_level
FROM bronze.inventory_snapshots ;

--=============================================================================================
--=============================== unit_cost column cleaning ===================================
--=============================================================================================
-- unite_cost data overview 
SELECT 
    unit_cost
FROM bronze.inventory_snapshots ;

-- unite_cost data profiling 
SELECT 
      unit_cost
FROM  bronze.inventory_snapshots
WHERE unit_cost IS NULL 
   OR TRY_CONVERT(DECIMAL(10, 2), unit_cost) IS NULL ; 

-- unit_cost cleaning and standardization
SELECT 
    CASE 
        WHEN unit_cost LIKE '$%' THEN SUBSTRING(unit_cost, 2, LEN(unit_cost))
        ELSE TRY_CONVERT(DECIMAL(10, 2), unit_cost)
    END as unit_cost
FROM bronze.inventory_snapshots ;

--=============================================================================================
--================================== unit_price column cleaning ===============================
--=============================================================================================
-- unit_price data overview 
SELECT 
    unit_price
FROM bronze.inventory_snapshots ;

-- selecting those unite price they contani '$' symbol 
SELECT 
      unit_price
FROM  bronze.inventory_snapshots
WHERE unit_price LIKE '$%' ; 

-- selecting those unite price they contani ',' symbol 
SELECT 
      unit_price
FROM  bronze.inventory_snapshots
WHERE unit_price LIKE '%,%' ; 

-- finding those unit price they are 0
SELECT 
      unit_price
FROM  bronze.inventory_snapshots
WHERE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_price, '$', ''), ',', '')) < 1 ; 

-- unit_price data profiling 
SELECT 
      unit_price
FROM  bronze.inventory_snapshots
WHERE unit_price IS NULL 
   OR TRY_CONVERT(DECIMAL(10, 2), unit_price) IS NULL 
   OR unit_price LIKE '$%'
   OR unit_price LIKE '%,%' ;

-- unit_price data profiling 
SELECT 
      unit_price
FROM  bronze.inventory_snapshots
WHERE unit_price IS NULL 
  OR TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(unit_price, ',', ''), '$', '')) IS NULL  ;

-- unit_price cleaning and standardization
WITH unit_price_analysis AS 
(
    SELECT 
        CASE 
            WHEN TRY_CONVERT(DECIMAL(10,2), unit_price) IS NULL THEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_price, ',', ''), '$', ''))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_price)
        END as unit_price
    FROM bronze.inventory_snapshots 
)
SELECT 
unit_price
FROM unit_price_analysis
WHERE unit_price IS NULL ;

--=============================================================================================
--=============================== inventory_value  column cleaning ============================
--=============================================================================================
-- inventory_value data overview 
SELECT 
    inventory_value 
FROM bronze.inventory_snapshots ;

-- inventory_value data profiling 
SELECT 
    inventory_value 
FROM bronze.inventory_snapshots 
WHERE inventory_value IS NULL ;

-- inventory_value null count
SELECT 
    inventory_value
FROM bronze.inventory_snapshots 
WHERE inventory_value IS NOT NULL ;

-- data prifiling and standardization
WITH calc_inventory_value AS 
(
    SELECT 
        CASE 
            WHEN TRY_CONVERT(INT, stock_on_hand) IS NULL OR stock_on_hand < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, stock_on_hand)
        END AS stock_on_hand

        ,CASE 
            WHEN TRY_CONVERT(DECIMAL(10,2), unit_price) IS NULL THEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_price, ',', ''), '$', ''))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_price)
        END as unit_price
    FROM bronze.inventory_snapshots 
)
SELECT 
    COUNT(*) AS total_rows,
    COUNT(stock_on_hand) AS valid_stock,
    COUNT(unit_price) AS valid_price
FROM calc_inventory_value;

-- unit_price cleaning and standardization
WITH calc_inventory_value AS 
(
    SELECT 
        CASE 
            WHEN TRY_CONVERT(INT, stock_on_hand) IS NULL OR stock_on_hand < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, stock_on_hand)
        END AS stock_on_hand

        ,CASE 
            WHEN TRY_CONVERT(DECIMAL(10,2), unit_price) IS NULL THEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_price, ',', ''), '$', ''))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_price)
        END as unit_price
    FROM bronze.inventory_snapshots 
)
SELECT 
stock_on_hand * unit_price as inventory_value
FROM calc_inventory_value ;

--=============================================================================================
--=============================== warehouse_location  column cleaning =========================
--=============================================================================================
-- warehouse_location data overview
SELECT 
    warehouse_location
FROM bronze.inventory_snapshots ;

-- warehouse_location unique data overview
SELECT DISTINCT 
    warehouse_location
FROM bronze.inventory_snapshots ;

-- warehouse_location case-sensitive data profiling
SELECT DISTINCT 
    UPPER(warehouse_location) COLLATE Latin1_General_CS_AS as warehouse_location
FROM bronze.inventory_snapshots ;

-- warehouse_location data profiling and standardization
SELECT 
    CASE 
        WHEN warehouse_location IS NULL OR warehouse_location = '' THEN 'Unknown'
        ELSE UPPER(warehouse_location)
    END as warehouse_location
FROM bronze.inventory_snapshots ;

--=============================================================================================
--================================= store_id  column cleaning =================================
--=============================================================================================
-- store_id data overview
SELECT 
    store_id
FROM bronze.inventory_snapshots ;

-- store_id data profiling
SELECT 
    store_id
FROM bronze.inventory_snapshots 
WHERE store_id IS NULL OR store_id = ''
    OR TRY_CONVERT(INT, store_id) IS NULL ;

-- store id distribution analysis
SELECT 
    store_id,
    COUNT(*) store_id_count,
    CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' as percentages
FROM bronze.inventory_snapshots 
    GROUP BY store_id
    ORDER BY store_id_count DESC ;

-- store_id cleaning and standardization
SELECT 
    CASE 
        WHEN store_id IS NULL OR store_id = '' THEN NULL
        ELSE TRY_CONVERT(INT, store_id)
    END as store_id
FROM bronze.inventory_snapshots ;

--#############################################################################################
--############################## INVENTORY CLEAN DATA ##########################################
--#############################################################################################

SELECT 
    snapshot_date
    ,product_id
    ,product_name
    ,sku
    ,category
    ,stock_on_hand
    ,stock_reserved
    ,stock_on_hand - stock_reserved as stock_available
    ,reorder_level
    ,unit_cost
    ,unit_price
    ,unit_price * stock_on_hand as inventory_value
    ,warehouse_location
    ,store_id
FROM 
(
    SELECT 
        CASE 
            WHEN snapshot_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,snapshot_date)
            WHEN snapshot_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,snapshot_date)
            WHEN snapshot_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,snapshot_date)
            WHEN snapshot_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,snapshot_date)
        
            WHEN snapshot_date LIKE '__/__/____' AND SUBSTRING(snapshot_date, 4, 2) > 12 THEN TRY_CONVERT(DATE, snapshot_date, 101)
            WHEN snapshot_date LIKE '__/__/____' AND LEFT(snapshot_date, 2) > 12         THEN TRY_CONVERT(DATE, snapshot_date, 103)
            WHEN snapshot_date LIKE '__-__-____' AND SUBSTRING(snapshot_date, 4, 2) > 12 THEN TRY_CONVERT(DATE, snapshot_date, 110)
            WHEN snapshot_date LIKE '__-__-____' AND LEFT(snapshot_date, 2) > 12         THEN TRY_CONVERT(DATE, snapshot_date, 105)
            ELSE TRY_CONVERT(DATE, snapshot_date)
        END as snapshot_date

        ,CASE 
            WHEN TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, product_id)
        END  as product_id

        ,CASE 
            WHEN product_name IS NULL OR product_name = '' THEN 'Unknown'
            ELSE TRIM(product_name)
        END as product_name

        ,CASE 
            WHEN sku IS NULL OR sku = '' THEN 'Unknown'
            ELSE TRIM(sku)
        END as sku

        ,CASE 
            WHEN TRIM(LOWER(category)) = 'electronics' THEN 'Electronics'
            WHEN TRIM(LOWER(category)) = 'clothing'    THEN 'Clothing'
            WHEN TRIM(LOWER(category)) = 'kitchen'     THEN 'Kitchen'
            WHEN TRIM(LOWER(category)) = 'office'      THEN 'Office'
            WHEN TRIM(LOWER(category)) = 'sports'      THEN 'Sports'
            WHEN TRIM(LOWER(category)) = 'health'      THEN 'Health'
            WHEN TRIM(LOWER(category)) = 'beauty'      THEN 'Beauty'
            WHEN TRIM(LOWER(category)) = 'footwear'    THEN 'Footwear'
            WHEN TRIM(LOWER(category)) = 'toys'        THEN 'Toys'
            WHEN TRIM(LOWER(category)) = 'bags'        THEN 'Bags'
            ELSE 'Unknown'
        END AS category
        
        ,CASE 
            WHEN TRY_CONVERT(INT, stock_on_hand) IS NULL OR stock_on_hand < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, stock_on_hand)
        END AS stock_on_hand

        ,CASE 
            WHEN stock_reserved < 0 OR TRY_CONVERT(INT, stock_reserved) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, stock_reserved)
        END  as stock_reserved

        ,CASE 
            WHEN reorder_level IS NULL OR reorder_level < 0 OR TRY_CONVERT(INT, reorder_level) IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, reorder_level)
        END as reorder_level

        ,CASE 
            WHEN unit_cost LIKE '$%' THEN TRY_CONVERT(DECIMAL(10, 2), SUBSTRING(unit_cost, 2, LEN(unit_cost)))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_cost)
        END as unit_cost

        ,CASE 
            WHEN TRY_CONVERT(DECIMAL(10,2), unit_price) IS NULL THEN TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_price, ',', ''), '$', ''))
            ELSE TRY_CONVERT(DECIMAL(10, 2), unit_price)
        END as unit_price

        ,CASE 
            WHEN warehouse_location IS NULL OR warehouse_location = '' THEN 'Unknown'
            ELSE UPPER(warehouse_location)
        END as warehouse_location

        ,CASE 
            WHEN store_id IS NULL OR store_id = '' THEN NULL
            ELSE TRY_CONVERT(INT, store_id)
        END as store_id

    FROM [bronze].[inventory_snapshots]  
)t;
