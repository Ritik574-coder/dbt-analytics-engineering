--#############################################################################################
--#################################### TRANSACTION DATA #######################################
--#############################################################################################

--=============================================================================================
--================================== transactions table overview ==============================
--=============================================================================================
SELECT [transaction_id]
      ,[order_id]
      ,[order_line_number]
      ,[order_date]
      ,[order_year]
      ,[order_month]
      ,[order_month_name]
      ,[order_quarter]
      ,[order_day_of_week]
      ,[ship_date]
      ,[delivery_date]

      ,[customer_id]          -- customer 
      ,[customer_full_name]   -- customer
      ,[customer_first_name]  -- customer
      ,[customer_last_name]   -- customer
      ,[customer_email]       -- customer
      ,[customer_phone]       -- customer
      ,[customer_city]        -- customer
      ,[customer_state]       -- customer
      ,[customer_zip]         -- customer
      ,[customer_region]      -- custoemr
      ,[customer_segment]     -- customer
      ,[customer_gender]      -- customer
      ,[customer_age]         -- customer
      ,[customer_age_group]   -- customer

      ,[product_id]           -- product
      ,[product_name]         -- prodcut
      ,[sku]                  -- product
      ,[brand]                -- product
      ,[category]             -- product
      ,[sub_category]         -- product
      ,[department]           -- product
      ,[quantity_ordered]     
      ,[unit_list_price]      
      ,[discount_pct]         
      ,[unit_selling_price]   
      ,[line_total_before_tax]
      ,[tax_rate_pct]
      ,[tax_amount]
      ,[line_total_with_tax]

      ,[store_id]
      ,[store_name]
      ,[store_city]
      ,[store_state]
      ,[store_region]
      ,[store_type]

      ,[employee_id]
      ,[employee_name]
      ,[employee_job_title]

      ,[promo_id]
      ,[promo_name]
      ,[sales_channel]
      ,[payment_method]
      ,[shipping_method]
      ,[order_status]
      ,[is_returned]
      ,[cost_price]
      ,[gross_profit]
      ,[data_source]
      ,[record_created_ts]
      ,[last_modified_ts]
  FROM .[bronze].[sales_transactions]

--=============================================================================================
--####################################### SELECTING COLUMN  ###################################
--=============================================================================================
SELECT st.transaction_id
      ,st.order_id
      ,st.order_line_number
      ,st.order_date
      ,st.order_year
      ,st.order_month
      ,st.order_month_name
      ,st.order_quarter
      ,st.order_day_of_week
      ,st.ship_date
      ,st.delivery_date

      ,st.customer_id     as customer_id          -- customer 
      ,c.first_name       as customer_first_name  -- customer
      ,c.last_name        as customer_last_name   -- customer
      ,c.email            as customer_email       -- customer
      ,c.phone            as customer_phone       -- customer
      ,c.city             as customer_city        -- customer
      ,c.state            as customer_state       -- customer
      ,c.zip_code         as customer_zip         -- customer
      ,c.region           as customer_region      -- custoemr
      ,c.customer_segment as customer_segment     -- customer
      ,c.gender           as customer_gender      -- customer
      ,c.date_of_birth    as birth_date           -- customer

      ,st.product_id                              -- product
      ,P.product_name as product_name             -- prodcut
      ,P.sku          as prodcut_sku              -- product
      ,P.brand        as prodcut_brand            -- product
      ,P.category     as prodcut_category         -- product
      ,P.sub_category as prodcut_sub_category     -- product
      ,P.department   as prodcut_department       -- product

      ,st.quantity_ordered     
      ,st.unit_list_price      
      ,st.discount_pct         
      ,st.unit_selling_price   
      ,st.line_total_before_tax
      ,st.tax_rate_pct
      ,st.tax_amount
      ,st.line_total_with_tax

      ,s.store_id   as store_id                  -- store
      ,s.store_name as store_name                -- store
      ,s.city       as store_city                -- store   
      ,s.state_full as store_state               -- store    
      ,s.region     as store_region              -- store   
      ,s.store_type as store_type                -- store   

      ,st.employee_id                            -- employees
      ,CONCAT(e.first_name,
       ' ',
        e.last_name
        ) as employee_name                       -- employees 
      ,e.job_title as employee_job_title         -- employees 

      ,st.promo_id
      ,st.promo_name
      ,st.sales_channel
      ,st.payment_method
      ,st.shipping_method
      ,st.order_status
      ,st.is_returned
      ,st.cost_price
      ,st.gross_profit
      ,st.data_source
      ,st.record_created_ts
      ,st.last_modified_ts
FROM .bronze.sales_transactions as st 
LEFT JOIN silver.customers as c  
ON st.customer_id = c.customer_id 
LEFT JOIN silver.stores AS s
ON st.store_id = s.store_id 
LEFT JOIN silver.employees as e  
ON st.employee_id = e.employee_id 
LEFT JOIN silver.products as p  
ON st.product_id = p.product_id 
; 


--=============================================================================================
--#################################### FINAL COLUMN SELECTION #################################
--=============================================================================================
SELECT 
       st.transaction_id
      ,st.order_id
      ,st.customer_id
      ,st.product_id 
      ,st.store_id 
      ,st.employee_id 
      ,st.promo_id

      ,st.promo_name
      ,st.sales_channel
      ,st.payment_method
      ,st.shipping_method
      ,st.order_status
      ,st.is_returned
      
      ,st.order_line_number
      ,st.quantity_ordered     
      ,st.unit_list_price      
      ,st.discount_pct         
      ,st.unit_selling_price   
      ,st.line_total_before_tax
      ,st.tax_rate_pct
      ,st.tax_amount
      ,st.line_total_with_tax

      ,st.data_source
      ,st.cost_price
      ,st.gross_profit


      ,st.order_date
      ,st.order_year
      ,st.order_month
      ,st.order_month_name
      ,st.order_quarter
      ,st.order_day_of_week
      ,st.ship_date
      ,st.delivery_date
      ,st.record_created_ts
      ,st.last_modified_ts
FROM .bronze.sales_transactions as st 
; 

--=============================================================================================
--####################################### ID'S VALIDATION  ####################################
--=============================================================================================
-- duplicate check in transction_id 
SELECT 
transaction_id ,
COUNT(*)
FROM bronze.sales_transactions 
GROUP BY transaction_id 
HAVING COUNT(*) > 1 ;

-- duplicate id data check 
SELECT 
      *
FROM bronze.sales_transactions 
WHERE transaction_id 
IN (
      'TXN-10003964-10552'
      ,'TXN-10000103-267'
      ,'TXN-10003529-9364'
      ,'TXN-10003869-10285'
      ,'TXN-10000562-1502'
      ,'TXN-10004449-11885'
);

-- duplicate heandling 
SELECT
    transaction_id,
    product_id,
    customer_id,
    customer_first_name
FROM
(
    SELECT
        transaction_id,
        product_id,
        customer_id,
        customer_first_name,
        ROW_NUMBER() OVER(
            PARTITION BY transaction_id
            ORDER BY transaction_id
        ) AS rn
    FROM bronze.sales_transactions
) t
WHERE rn = 1;

-- transaction and foreign key null validation
SELECT 
      transaction_id,
      order_id,
      customer_id,
      product_id,
      store_id,
      employee_id,
      promo_id
FROM bronze.sales_transactions 
WHERE transaction_id IS NULL
OR order_id IS NULL
OR customer_id IS NULL
OR product_id IS NULL
OR store_id IS NULL
OR employee_id IS NULL; 

-- customer foreign key validation
SELECT 
      st.customer_id,
      c.customer_id as customer_id_silver
FROM bronze.sales_transactions st 
LEFT JOIN silver.customers c
ON st.customer_id = c.customer_id
WHERE st.customer_id IS NULL
OR c.customer_id IS NULL;

-- customer orphan key validation
SELECT 
      st.customer_id
FROM bronze.sales_transactions as st 
WHERE st.customer_id IS NOT NULL 
AND NOT EXISTS(
      SELECT 1 FROM silver.customers c
      WHERE st.customer_id = c.customer_id
) ;

-- product foreign key validation
SELECT 
      st.product_id,
      p.product_id as product_id_silver
FROM bronze.sales_transactions st 
LEFT JOIN silver.products as p
      ON st.product_id = p.product_id
WHERE st.product_id IS NULL
      OR p.product_id IS NULL;

-- product orphan key validation
SELECT 
      st.product_id
FROM bronze.sales_transactions as st 
WHERE st.product_id IS NOT NULL 
AND NOT EXISTS(
      SELECT 1 FROM silver.products p
      WHERE st.product_id = p.product_id
) ;

-- store foreign key validation
SELECT 
      st.store_id,
      s.store_id as store_id_silver
FROM bronze.sales_transactions st 
LEFT JOIN silver.stores as s
      ON st.store_id = s.store_id
WHERE st.store_id IS NULL
      OR s.store_id IS NULL;

-- store orphan key validation
SELECT 
      st.store_id
FROM bronze.sales_transactions as st 
WHERE st.store_id IS NOT NULL 
AND NOT EXISTS(
      SELECT 1 FROM silver.stores s
      WHERE st.store_id = s.store_id
) ;

-- employee foreign key validation 
SELECT 
      st.employee_id,
      e.employee_id as employee_id_silver
FROM bronze.sales_transactions st 
LEFT JOIN silver.employees as e
      ON st.employee_id = e.employee_id
WHERE st.employee_id IS NULL
      OR e.employee_id IS NULL;

-- employee orphan key validation
SELECT 
      st.employee_id
FROM bronze.sales_transactions as st 
WHERE st.employee_id IS NOT NULL 
AND NOT EXISTS(
      SELECT 1 FROM silver.employees e
      WHERE st.employee_id = e.employee_id
) ;

--#############################################################################################
--################################### promo_name validation  ##################################
--#############################################################################################
-- promo_name data profiling 
SELECT DISTINCT 
TRIM(LOWER(promo_name)) as promo_name
FROM bronze.sales_transactions ; 

-- promo_name data validation and cleaning 
with promo_name_analysis as 
(
SELECT
CASE TRIM(LOWER(promo_name))
    WHEN 'winter clearance' THEN 'Winter Clearance'
    WHEN 'bundle deal' THEN 'Bundle Deal'
    WHEN 'no promo' THEN 'No Promo'
    WHEN 'flash sale' THEN 'Flash Sale'
    WHEN 'black friday' THEN 'Black Friday'
    WHEN 'holiday special' THEN 'Holiday Special'
    WHEN 'weekend deal' THEN 'Weekend Deal'
    WHEN 'loyalty reward' THEN 'Loyalty Reward'
    WHEN 'cyber monday' THEN 'Cyber Monday'
    ELSE TRIM(promo_name)
END AS promo_name
FROM bronze.sales_transactions 
)
SELECT 
      promo_name,
      COUNT(*) as promo_name_count,
      CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) as nvarchar) + '%' as percentages
FROM promo_name_analysis
      GROUP BY promo_name
      ORDER BY promo_name_count DESC ;

--#############################################################################################
--################################# sales_channel validation  #################################
--#############################################################################################
--sales_channel data profiling and opverview 
SELECT DISTINCT 
TRIM(LOWER(sales_channel)) as sales_channel
FROM bronze.sales_transactions ;

-- sales_chennel data cleaning and validation 
SELECT DISTINCT 
CASE 
    WHEN TRIM(LOWER(sales_channel)) IN ('app', 'mobile', 'mobile app')   THEN 'Mobile App'
    WHEN TRIM(LOWER(sales_channel)) IN ('store', 'in store', 'in-store') THEN 'In Store'
    WHEN TRIM(LOWER(sales_channel)) IN ('online', 'web')                 THEN 'Website'
    WHEN TRIM(LOWER(sales_channel)) IN ('phone')                         THEN 'Phone Call'
    WHEN TRIM(LOWER(sales_channel)) IN ('catalog')                       THEN 'Catalog'
    ELSE 'Unknown'
END AS sales_channel
FROM bronze.sales_transactions ;

--#############################################################################################
--################################# payment_method validation  ################################
--#############################################################################################
-- payment_method validation check and profiling 
SELECT DISTINCT 
TRIM(payment_method) as payment_method
FROM bronze.sales_transactions ;

--payment_method data cleaning and validation 
SELECT DISTINCT 
CASE TRIM(LOWER(payment_method))
    WHEN 'debit card'        THEN 'Debit Card'
    WHEN 'credit card'       THEN 'Credit Card'
    WHEN 'google pay'        THEN 'Google Pay'
    WHEN 'apple pay'         THEN 'Apple Pay'
    WHEN 'bank transfer'     THEN 'Bank Transfer'
    WHEN 'buy now pay later' THEN 'Buy Now Pay Later'
    WHEN 'bnpl'              THEN 'Buy Now Pay Later'
    WHEN 'gift card'         THEN 'Gift Card'
    WHEN 'paypal'            THEN 'PayPal'
    WHEN 'cash'              THEN 'Cash'
    ELSE TRIM(payment_method)
END AS payment_method
FROM bronze.sales_transactions ;

--#############################################################################################
--################################# shipping_method validation  ###############################
--#############################################################################################
-- Profiling Raw Shipping Method Values
SELECT DISTINCT
TRIM(LOWER(shipping_method)) as shipping_method
FROM bronze.sales_transactions ;

-- Standardized Shipping Method Values
SELECT DISTINCT
CASE 
    WHEN TRIM(LOWER(shipping_method)) IN ('pickup', 'in-store pickup')       THEN 'Store Pickup'
    WHEN TRIM(LOWER(shipping_method)) IN ('overnight', 'overnight shipping') THEN 'Overnight Shipping'
    WHEN TRIM(LOWER(shipping_method)) IN ('same day', 'same day delivery')   THEN 'Same Day Delivery'
    WHEN TRIM(LOWER(shipping_method)) IN ('express', 'express shipping')     THEN 'Express Shipping'
    WHEN TRIM(LOWER(shipping_method)) IN ('standard', 'standard shipping')   THEN 'Standard Shipping'
    WHEN TRIM(LOWER(shipping_method)) IN ('free ship', 'free shipping')      THEN 'Free Shipping'
    ELSE TRIM(shipping_method)
END AS shipping_method
FROM bronze.sales_transactions ;

--#############################################################################################
--#################################### order_status validation  ###############################
--#############################################################################################
-- Priling Row Order statsu Values 
SELECT DISTINCT
order_status as order_status
FROM bronze.sales_transactions ;

-- Standardized Order Status Values
SELECT DISTINCT 
      CASE TRIM(LOWER(order_status))
            WHEN 'pending'    THEN 'Pending'
            WHEN 'processing' THEN 'Processing'
            WHEN 'shipped'    THEN 'Shipped'
            WHEN 'delivered'  THEN 'Delivered'
            WHEN 'returned'   THEN 'Returned'
            WHEN 'cancelled'  THEN 'Cancelled'
            ELSE TRIM(order_status)
      END AS order_status
FROM bronze.sales_transactions ;

--#############################################################################################
--#################################### is_return validation  ##################################
--#############################################################################################
-- Profiling Row is_returned values 
SELECT DISTINCT
      is_returned
FROM bronze.sales_transactions ;

-- Standardized is_returned Values
SELECT DISTINCT
CASE 
    WHEN TRIM(LOWER(is_returned)) IN ('yes', 'y', 'true', '1') THEN 'True'
    WHEN TRIM(LOWER(is_returned)) IN ('no', 'n', 'false', '0') THEN 'False'
    ELSE 'Unknown'
END AS is_returned
FROM bronze.sales_transactions ;

--#############################################################################################
--#################################### data_source validation  ################################
--#############################################################################################
-- Profiling Row data Source values 
SELECT DISTINCT 
      data_source
FROM bronze.sales_transactions ;

-- Standardized and mapping correct Values and cleaning data 
SELECT DISTINCT
CASE TRIM(LOWER(data_source))
    WHEN 'crm'    THEN 'CRM'
    WHEN 'web'    THEN 'Web'
    WHEN 'pos'    THEN 'POS'
    WHEN 'manual' THEN 'Manual'
    WHEN 'erp'    THEN 'ERP'
    ELSE 'Unknown'
END AS data_source
FROM bronze.sales_transactions ;

--#############################################################################################
--################################# order_line_number validation  #############################
--#############################################################################################
-- prifiling order_line_number row value 
SELECT DISTINCT 
      order_line_number
FROM bronze.sales_transactions

-- validating order_line_number column 
SELECT 
      order_id,
      customer_id,
      COUNT(*) as order_line
FROM bronze.sales_transactions
GROUP BY 
      order_id, 
      customer_id
ORDER BY 
      COUNT(*) DESC;

-- Standardized order_line_number  Values
WITH order_line_analysis AS 
(
SELECT 
      CASE 
            WHEN order_line_number < 1 THEN NULL 
            WHEN order_line_number > 20 THEN NULL
            ELSE order_line_number
      END as order_line_number
FROM bronze.sales_transactions
)
SELECT 
      order_line_number,
      COUNT(*) as order_line_number_count,
      CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) as nvarchar) + '%' as percentages
FROM order_line_analysis
GROUP BY order_line_number
ORDER BY order_line_number_count DESC ;

--#############################################################################################
--################################# quantity_ordered validation  #############################
--#############################################################################################
-- quantity_ordered row value profiling 
SELECT
      DISTINCT quantity_ordered
FROM bronze.sales_transactions ;

-- quantity_ordered row data validating
SELECT
      quantity_ordered
FROM bronze.sales_transactions
WHERE TRY_CONVERT(INT, quantity_ordered) IS NULL
AND quantity_ordered IS NOT NULL ;

-- Standardized quantity_ordered  Values
WITH quantity_ordered_analysis AS 
(
SELECT 
      CASE 
            WHEN quantity_ordered < 1 THEN NULL 
            WHEN quantity_ordered > 100 THEN NULL
            ELSE quantity_ordered
      END as quantity_ordered
FROM bronze.sales_transactions 
)
SELECT 
      quantity_ordered,
      COUNT(*) as quantity_ordered_count,
      CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) as nvarchar) + '%' as percentages
FROM quantity_ordered_analysis
GROUP BY quantity_ordered
ORDER BY quantity_ordered_count DESC ;

--#############################################################################################
--################################### unit_list_price validation  #############################
--#############################################################################################
-- unit_list_price row values profiling 
SELECT DISTINCT 
      unit_list_price
FROM bronze.sales_transactions 
WHERE unit_list_price like '$%' or unit_list_price like '%,%' ;

-- unit_list_price row data validating 
SELECT
      unit_list_price
FROM bronze.sales_transactions 
WHERE unit_list_price IS NULL 
      OR TRY_CONVERT(DECIMAL(10,2), unit_list_price) < 1 
      OR TRY_CONVERT(DECIMAL(10,2), unit_list_price) IS NULL; 

-- unit_list_price Standardized and validating and cleaning data 
WITH list_price_analysis AS 
(
      SELECT 
            CASE 
                  WHEN unit_list_price IS NULL THEN NULL 
                  ELSE TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(unit_list_price, '$', ''), ',', '')) 
            END as unit_list_price
      FROM bronze.sales_transactions 
)
SELECT 
      unit_list_price
FROM list_price_analysis 
WHERE unit_list_price IS NULL 
OR unit_list_price like '$%' or unit_list_price like '%,%' ;

--#############################################################################################
--################################### discount_pct validation  ################################
--#############################################################################################
-- Discount Percentage Data Profiling
SELECT DISTINCT 
      ROUND(discount_pct, 0) as discount_pct
FROM bronze.sales_transactions ; 

-- Discount Percentage Validation And Cleaning
SELECT 
      CASE 
            WHEN discount_pct IS NULL OR discount_pct < 0 THEN NULL 
            ELSE ROUND(discount_pct, 0)
      END as discount_pct
FROM bronze.sales_transactions ;

--#############################################################################################
--################################### unit_selling_price validation  ##########################
--#############################################################################################
-- Review And Identify Issues In Unit Selling Price Data
SELECT 
      unit_selling_price 
FROM bronze.sales_transactions 
WHERE TRIM(unit_selling_price) != unit_selling_price
      OR unit_selling_price IS NULL 
      OR unit_selling_price LIKE '%,%'
      OR unit_selling_price LIKE '$%'; 

--Clean And Standardize Unit Selling Price Values
WITH unit_selling_price_analysis AS 
(
      SELECT 
            CASE 
                  WHEN unit_selling_price IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_selling_price, '$', ''), ',', '')) < 0 THEN NULL 
                  ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_selling_price, '$', ''), ',', ''))
            END as unit_selling_price
      FROM bronze.sales_transactions 
)
SELECT 
      unit_selling_price
FROM unit_selling_price_analysis 
WHERE TRY_CONVERT(DECIMAL(10,2), unit_selling_price) IS NULL 
OR unit_selling_price IS NULL  ; 

--#############################################################################################
--################################### line_total_before_tax validation  #######################
--#############################################################################################
--   Check Line Total Before Tax Data Quality
SELECT 
      line_total_before_tax 
FROM bronze.sales_transactions 
WHERE TRIM(line_total_before_tax) != line_total_before_tax
      OR line_total_before_tax IS NULL 
      OR line_total_before_tax LIKE '%,%'
      OR line_total_before_tax LIKE '$%'; 

--  Clean And Standardize Line Total Before Tax Values
WITH line_total_before_tax_analysis AS 
(
      SELECT 
            CASE 
                  WHEN line_total_before_tax IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_before_tax, '$', ''), ',', '')) < 0 THEN NULL 
                  ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_before_tax, '$', ''), ',', ''))
            END as line_total_before_tax
      FROM bronze.sales_transactions 
)
SELECT 
      line_total_before_tax
FROM line_total_before_tax_analysis 
WHERE TRY_CONVERT(DECIMAL(10,2), line_total_before_tax) IS NULL 
OR line_total_before_tax IS NULL  ; 

--#############################################################################################
--################################### tax_rate_pct validation  ################################
--#############################################################################################
SELECT 
      ROUND(tax_rate_pct, 0) as tax_rate_pct
FROM bronze.sales_transactions ; 

SELECT 
      tax_rate_pct
FROM bronze.sales_transactions 
WHERE TRY_CONVERT(INT, ROUND(tax_rate_pct, 0)) IS NULL ; 

SELECT 
      CASE 
            WHEN tax_rate_pct IS NULL OR TRY_CONVERT(INT, ROUND(tax_rate_pct, 0)) < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, ROUND(tax_rate_pct, 0))
      END as tax_rate_pctl
FROM bronze.sales_transactions ;

--#############################################################################################
--################################### tax_amount validation  ##################################
--#############################################################################################
--  Review Tax Rate Percentage Values
SELECT 
      tax_amount 
FROM bronze.sales_transactions 
WHERE TRIM(tax_amount) != tax_amount
      OR tax_amount IS NULL 
      OR tax_amount LIKE '%,%'
      OR tax_amount LIKE '$%'; 

--Clean And Standardize Tax Rate Percentage Values
WITH tax_amount_analysis AS 
(
      SELECT 
            CASE 
                  WHEN tax_amount IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(tax_amount, '$', ''), ',', '')) < 0 THEN NULL 
                  ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(tax_amount, '$', ''), ',', ''))
            END as tax_amount
      FROM bronze.sales_transactions 
)
SELECT 
      tax_amount
FROM tax_amount_analysis 
WHERE TRY_CONVERT(DECIMAL(10,2), tax_amount) IS NULL 
OR tax_amount IS NULL  ; 

--#############################################################################################
--################################ line_total_with_tax validation  ############################
--#############################################################################################
-- Check Line Total With Tax Data Quality
SELECT 
      line_total_with_tax 
FROM bronze.sales_transactions 
WHERE TRIM(line_total_with_tax) != line_total_with_tax
      OR line_total_with_tax IS NULL 
      OR line_total_with_tax LIKE '%,%'
      OR line_total_with_tax LIKE '$%'; 

-- Clean And Standardize Line Total With Tax Values
WITH line_total_with_tax_analysis AS 
(
      SELECT 
            CASE 
                  WHEN line_total_with_tax IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_with_tax, '$', ''), ',', '')) < 0 THEN NULL 
                  ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_with_tax, '$', ''), ',', ''))
            END as line_total_with_tax
      FROM bronze.sales_transactions 
)
SELECT 
      line_total_with_tax
FROM line_total_with_tax_analysis 
WHERE TRY_CONVERT(DECIMAL(10,2), line_total_with_tax) IS NULL 
OR line_total_with_tax IS NULL  ; 

--#############################################################################################
--################################ cost_price validation  #####################################
--#############################################################################################
-- Check Cost Price Data Quality
SELECT 
      cost_price 
FROM bronze.sales_transactions 
WHERE TRIM(cost_price) != cost_price
      OR cost_price IS NULL 
      OR cost_price LIKE '%,%'
      OR cost_price LIKE '$%'; 

-- Count Missing Cost Price Values
SELECT 
      count(*)
FROM bronze.sales_transactions 
WHERE cost_price IS NULL ;

--  Clean And Standardize Cost Price Values
WITH cost_price_analysis AS 
(
      SELECT 
            CASE 
                  WHEN cost_price IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price, '$', ''), ',', '')) < 0 THEN NULL 
                  ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price, '$', ''), ',', ''))
            END as cost_price
      FROM bronze.sales_transactions 
)
SELECT 
      cost_price
FROM cost_price_analysis 
WHERE TRY_CONVERT(DECIMAL(10,2), cost_price) IS NULL 
OR cost_price IS NULL  ; 


--#############################################################################################
--################################ gross_profit validation  ###################################
--#############################################################################################
-- Gross Profit Data Profiling
SELECT 
      gross_profit 
FROM bronze.sales_transactions 
WHERE TRIM(gross_profit) != gross_profit
      OR gross_profit IS NULL 
      OR gross_profit LIKE '%,%'
      OR gross_profit LIKE '$%'; 

-- Gross Profit Completeness Analysis
SELECT 
      count(*)
FROM bronze.sales_transactions 
WHERE gross_profit IS NULL ;

--Gross Profit Data Validation And Standardization
WITH gross_profit_analysis AS 
(
      SELECT 
            CASE 
                  WHEN gross_profit IS NULL THEN NULL 
                  ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(gross_profit, '$', ''), ',', ''))
            END as gross_profit
      FROM bronze.sales_transactions 
)
SELECT 
      gross_profit
FROM gross_profit_analysis 
WHERE TRY_CONVERT(DECIMAL(10,2), gross_profit) IS NULL 
OR gross_profit IS NULL  ; 


--#############################################################################################
--################################# ORDER_DATE CLEAINING DATA #################################
--#############################################################################################
-- Date Attribute Consistency Assessment
SELECT
      order_date,
      order_month,
      order_day_of_week,
      order_year,
      order_month_name,
      order_quarter
FROM bronze.sales_transactions ; 

-- Date Reconstruction And Validation
SELECT 
CONCAT(order_year, '-', order_month_name,'-', order_day_of_week) as order_date
FROM bronze.sales_transactions ;

-- Order Month Reference Validation
SELECT DISTINCT
      order_month,
      order_month_name
FROM bronze.sales_transactions 
ORDER BY order_month ; 

-- Order Date Format Pattern Analysis
WITH pattern_analysis AS 
(
SELECT 
      TRANSLATE(
            order_date,
            '0123456789abcdefghijklmnopqrstuvwxyz',
            '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
      ) as date_pattern 
FROM bronze.sales_transactions 
)
SELECT 
      date_pattern ,
      COUNT(*) as pattern_count,
      CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM pattern_analysis 
GROUP BY date_pattern
ORDER BY pattern_count DESC ;
 
-- Slash-Separated Date Format Standardization
SELECT 
      CASE 
            WHEN order_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(order_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 101)
            WHEN order_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(order_date, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 103) 
            ELSE TRY_CONVERT(DATE, order_date, 101)
      END as order_date
FROM bronze.sales_transactions 
WHERE order_date LIKE '__/__/____' ;

-- Hyphen-Separated Date Format Standardization
SELECT 
CASE
      WHEN order_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(order_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 110)
      WHEN order_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(order_date, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 105) 
      ELSE TRY_CONVERT(DATE, order_date, 101)
END as order_date
FROM bronze.sales_transactions 
WHERE order_date LIKE '__-__-____';

-- Order Date Parsing And Standardization
WITH wrong_format_analysis AS 
(
      SELECT 
            order_month,
            CASE 
                  WHEN order_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE , order_date)
                  WHEN order_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE , order_date)
                  WHEN order_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE , order_date)
                  WHEN order_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE , order_date)

                  WHEN order_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(order_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 101)
                  WHEN order_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(order_date, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 103) 

                  WHEN order_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(order_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 110)
                  WHEN order_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(order_date, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 105) 

                  ELSE order_date
            END as order_date
      FROM bronze.sales_transactions 

) --Order Date Quality Assessment
SELECT 
      order_date,
      order_month,
      MONTH(order_date) new_month
FROM wrong_format_analysis 
WHERE order_date NOT LIKE '____-__-__' 
OR MONTH(order_date) != order_month ;

--  Order Date Validation And Correction Using Reference Attributes
WITH order_date_analysis AS 
(
      SELECT 
            order_month,
            CASE 
                  WHEN order_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE , order_date)
                  WHEN order_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE , order_date)
                  WHEN order_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE , order_date)
                  WHEN order_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE , order_date)

                  WHEN order_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(order_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 101)
                  WHEN order_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(order_date, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 103) 

                  WHEN order_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(order_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 110)
                  WHEN order_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(order_date, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 105) 

                  ELSE TRY_CONVERT(DATE, TRIM(order_date), 101)
            END as order_date
      FROM bronze.sales_transactions 
      WHERE order_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____'
         OR order_date LIKE '[A-Z][a-z][a-z] __, ____'
         OR order_date LIKE '____/__/__'
         OR order_date LIKE '____-__-__'
         OR order_date LIKE '__/__/____'
         OR order_date LIKE '__-__-____'
)  
SELECT 
    CASE
        WHEN order_month != MONTH(order_date)
        THEN DATEFROMPARTS(
                YEAR(order_date),
                DAY(order_date),
                MONTH(order_date)
             )

        ELSE order_date
    END AS order_date,
    order_month
FROM order_date_analysis ;

--#############################################################################################
--################################# ORDER_DATE CLEAINING DATA #################################
--#############################################################################################
-- Source Data Exploration
SELECT * FROM bronze.sales_transactions_view ; 

--Date Column Assessment
SELECT 
      order_date,
      ship_date,
      delivery_date
FROM bronze.sales_transactions_view ;

-- Order Day Extraction Validation
SELECT 
      DAY(order_date) as day 
FROM bronze.sales_transactions_view ;

-- Order Month Consistency Validation
SELECT 
      order_month,
      MONTH(order_date) as ex_order_month
FROM bronze.new_sales
WHERE order_month != MONTH(order_date) ;

-- Valid Order Month Records
SELECT 
      order_month,
      MONTH(order_date) as ex_order_month
FROM bronze.new_sales
WHERE order_month = MONTH(order_date) ;
 
--#############################################################################################
--################################## SHIP DATE CLEAINING DATA #################################
--#############################################################################################
-- Ship Date Relationship Assessment
SELECT 
      MONTH(order_date) as order_month,
      MONTH(ship_date)  as ship_month ,
      DAY(order_date)   as order_day  ,
      DAY(ship_date)    as ship_day 
FROM bronze.sales_transactions_view 
WHERE MONTH(order_date) = MONTH(ship_date);

-- Ship Date Completeness Analysis
SELECT 
      ship_date
FROM bronze.sales_transactions_view 
WHERE ship_date IS NULL ;

-- Order To Ship Month Transition Analysis
SELECT 
      MONTH(order_date) as order_month,
      MONTH(ship_date)  as ship_month 
FROM bronze.sales_transactions_view 
WHERE MONTH(order_date) <  MONTH(ship_date);

-- Order To Ship Lead Time Analysis
SELECT 
DATEDIFF(DAY ,order_date, ship_date) as day_diff
FROM bronze.sales_transactions_view ;

--  Same Day Delivery Lead Time Validation
SELECT
      order_date,
      ship_date,
      DATEDIFF(DAY ,order_date, ship_date) as day_diff,
      shipping_method
FROM bronze.sales_transactions_view 
WHERE shipping_method = 'Same Day Delivery';

-- Missing Ship Date Impact Assessment
SELECT 
      ship_date
FROM bronze.sales_transactions_view 
WHERE ship_date IS NULL ;

-- Invalid Ship Date Sequence Analysis
SELECT 
DATEDIFF(DAY ,order_date, ship_date) as day_diff
FROM bronze.sales_transactions_view 
WHERE DATEDIFF(DAY ,order_date, ship_date) < 0 ;

-- Ship Date Correction And Validation
WITH date_cleaning AS 
(
      SELECT 
            order_date,
            ship_date,
            delivery_date,
      CASE
            WHEN DATEDIFF(DAY ,order_date, ship_date) < 0 THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
            WHEN DATEDIFF(DAY ,order_date, ship_date) > 15 THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
            ELSE ship_date 
      END as new_ship
FROM bronze.sales_transactions_view 
 ) 
SELECT 
      order_date,
      ship_date,
      delivery_date,
      new_ship,
      DATEDIFF(DAY, order_date, ship_date) as old_day,
      DATEDIFF(DAY, order_date, new_ship) as new_date
FROM date_cleaning 
WHERE new_ship IS NOT NULL 
OR DATEDIFF(DAY, order_date, new_ship) < 0 
OR DATEDIFF(DAY, order_date, new_ship) > 15 ;

-- Median Shipping Lead Time Analysis
WITH date_cleaning AS 
(
      SELECT 
            order_date,
            ship_date,
            delivery_date,
      CASE
            WHEN DATEDIFF(DAY ,order_date, ship_date) < 0 THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
            WHEN DATEDIFF(DAY ,order_date, ship_date) > 15 THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
      END as new_ship
FROM bronze.sales_transactions_view 
 ) 
SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (
    ORDER BY DATEDIFF(DAY, order_date, new_ship)
) OVER () AS median_ship_days
FROM date_cleaning
WHERE new_ship IS NOT NULL;

-- Monthly Shipping Lead Time Analysis
SELECT
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mn,
    AVG(DATEDIFF(DAY, order_date, ship_date) * 1.0) AS avg_ship_days
FROM bronze.sales_transactions_view
WHERE ship_date IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY YEAR(order_date),
    MONTH(order_date) DESC ;

-- Ship Date Imputation Using Monthly Lead Time
WITH monthly_avg AS (
    SELECT
        YEAR(order_date) AS yr,
        MONTH(order_date) AS mn,
        AVG(DATEDIFF(DAY, order_date, ship_date)) AS avg_ship_days
    FROM bronze.sales_transactions_view
    WHERE ship_date IS NOT NULL
      AND ship_date >= order_date
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)
SELECT
    t.order_date,
    t.ship_date,
    DATEADD(
        DAY,
        CAST(m.avg_ship_days AS INT),
        t.order_date
    ) AS cleaned_ship_date
FROM bronze.sales_transactions_view t
JOIN monthly_avg m
    ON YEAR(t.order_date) = m.yr
   AND MONTH(t.order_date) = m.mn
WHERE t.ship_date IS NULL
   OR t.ship_date < t.order_date;

--Date Column Readiness Assessment
SELECT
      order_date,
      order_month,
      ship_date,
      delivery_date,
      record_created,
      last_modified
FROM bronze.new_sales;

--#############################################################################################
--####################### RECORD CREATE & MODIFIED DATE CLEAINING DATA ########################
--#############################################################################################
--  Record Creation Date Quality Assessment
SELECT 
    record_created
FROM bronze.sales_transactions_view 
WHERE record_created IS NULL 
   OR record_created NOT LIKE '____-__-__'
   OR TRY_CONVERT(DATE, record_created) IS NULL 
   OR YEAR(record_created) < 2019 ; 

-- record_created cleaning and validating 
WITH record_created_analysis AS 
(
SELECT 
      CASE 
            WHEN record_created IS NULL 
            OR record_created NOT LIKE '____-__-__' 
            OR TRY_CONVERT(DATE, record_created) IS NULL 
            OR YEAR(record_created) < 2019  THEN NULL 
            ELSE record_created
      END as record_created
FROM bronze.sales_transactions_view
)
SELECT 
      record_created
FROM record_created_analysis 
WHERE record_created IS NULL ; 

-- year analysis 
SELECT DISTINCT 
      YEAR(record_created) AS year 
FROM bronze.sales_transactions_view  
ORDER BY year ASC ;

-- Last Modified Date Quality Assessment
SELECT 
      last_modified
FROM bronze.sales_transactions_view 
WHERE last_modified IS NULL 
   OR last_modified NOT LIKE '____-__-__'
   OR TRY_CONVERT(DATE, last_modified) IS NULL 
   OR YEAR(last_modified) < 2019 ; 


-- last_modified cleaning and validating 
WITH last_modified_analysis AS 
(
SELECT 
      CASE 
            WHEN last_modified IS NULL 
            OR last_modified NOT LIKE '____-__-__' 
            OR TRY_CONVERT(DATE, last_modified) IS NULL 
            OR YEAR(last_modified) < 2019  THEN NULL 
            ELSE last_modified
      END as last_modified
FROM bronze.sales_transactions_view
)
SELECT 
      last_modified
FROM last_modified_analysis 
WHERE last_modified IS NULL ; 

-- data qulity check 
SELECT 
* 
FROM bronze.date_analysis 
WHERE last_modified < record_created ;

--#############################################################################################
--#################################### TRANSACTION CLEAN DATA #################################
--#############################################################################################
SELECT
       transaction_id
      ,order_id
      ,customer_id
      ,product_id
      ,store_id
      ,employee_id
      ,promo_id
      ,promo_name
      ,sales_channel
      ,payment_method
      ,shipping_method
      ,order_status
      ,is_returned
      ,data_source
      ,order_line_number
      ,quantity_ordered
      ,unit_list_price
      ,discount_pct
      ,unit_selling_price
      ,line_total_before_tax
      ,tax_rate_pct
      ,tax_amount
      ,line_total_with_tax
      ,cost_price
      ,gross_profit

      ,CASE 
            WHEN order_month != MONTH(order_date) THEN DATEFROMPARTS(YEAR(order_date), DAY(order_date), MONTH(order_date))
            ELSE order_date
      END AS order_date

      ,ship_date
      ,delivery_date
      ,record_created
      ,last_modified
FROM 
(
SELECT
       transaction_id
      ,order_id
      ,customer_id
      ,product_id 
      ,store_id 
      ,employee_id 
      ,promo_id

      ,CASE TRIM(LOWER(promo_name))
            WHEN 'winter clearance' THEN 'Winter Clearance'
            WHEN 'bundle deal'      THEN 'Bundle Deal'
            WHEN 'no promo'         THEN 'No Promo'
            WHEN 'flash sale'       THEN 'Flash Sale'
            WHEN 'black friday'     THEN 'Black Friday'
            WHEN 'holiday special'  THEN 'Holiday Special'
            WHEN 'weekend deal'     THEN 'Weekend Deal'
            WHEN 'loyalty reward'   THEN 'Loyalty Reward'
            WHEN 'cyber monday'     THEN 'Cyber Monday'
            ELSE TRIM(promo_name)
      END AS promo_name

      ,CASE 
            WHEN TRIM(LOWER(sales_channel)) IN ('app', 'mobile', 'mobile app')   THEN 'Mobile App'
            WHEN TRIM(LOWER(sales_channel)) IN ('store', 'in store', 'in-store') THEN 'In Store'
            WHEN TRIM(LOWER(sales_channel)) IN ('online', 'web')                 THEN 'Website'
            WHEN TRIM(LOWER(sales_channel)) IN ('phone')                         THEN 'Phone Call'
            WHEN TRIM(LOWER(sales_channel)) IN ('catalog')                       THEN 'Catalog'
            ELSE 'Unknown'
      END AS sales_channel

      ,CASE TRIM(LOWER(payment_method))
            WHEN 'debit card'        THEN 'Debit Card'
            WHEN 'credit card'       THEN 'Credit Card'
            WHEN 'google pay'        THEN 'Google Pay'
            WHEN 'apple pay'         THEN 'Apple Pay'
            WHEN 'bank transfer'     THEN 'Bank Transfer'
            WHEN 'buy now pay later' THEN 'Buy Now Pay Later'
            WHEN 'bnpl'              THEN 'Buy Now Pay Later'
            WHEN 'gift card'         THEN 'Gift Card'
            WHEN 'paypal'            THEN 'PayPal'
            WHEN 'cash'              THEN 'Cash'
            ELSE TRIM(payment_method)
      END AS payment_method

      ,CASE 
            WHEN TRIM(LOWER(shipping_method)) IN ('pickup', 'in-store pickup')       THEN 'Store Pickup'
            WHEN TRIM(LOWER(shipping_method)) IN ('overnight', 'overnight shipping') THEN 'Overnight Shipping'
            WHEN TRIM(LOWER(shipping_method)) IN ('same day', 'same day delivery')   THEN 'Same Day Delivery'
            WHEN TRIM(LOWER(shipping_method)) IN ('express', 'express shipping')     THEN 'Express Shipping'
            WHEN TRIM(LOWER(shipping_method)) IN ('standard', 'standard shipping')   THEN 'Standard Shipping'
            WHEN TRIM(LOWER(shipping_method)) IN ('free ship', 'free shipping')      THEN 'Free Shipping'
            ELSE TRIM(shipping_method)
      END AS shipping_method

      ,CASE TRIM(LOWER(order_status))
            WHEN 'pending'    THEN 'Pending'
            WHEN 'processing' THEN 'Processing'
            WHEN 'shipped'    THEN 'Shipped'
            WHEN 'delivered'  THEN 'Delivered'
            WHEN 'returned'   THEN 'Returned'
            WHEN 'cancelled'  THEN 'Cancelled'
            ELSE TRIM(order_status)
      END AS order_status

      ,CASE 
            WHEN TRIM(LOWER(is_returned)) IN ('yes', 'y', 'true', '1') THEN 'True'
            WHEN TRIM(LOWER(is_returned)) IN ('no', 'n', 'false', '0') THEN 'False'
            ELSE 'Unknown'
      END AS is_returned

      ,CASE TRIM(LOWER(data_source))
            WHEN 'crm'    THEN 'CRM'
            WHEN 'web'    THEN 'Web'
            WHEN 'pos'    THEN 'POS'
            WHEN 'manual' THEN 'Manual'
            WHEN 'erp'    THEN 'ERP'
            ELSE 'Unknown'
      END AS data_source

      ,CASE 
            WHEN order_line_number < 1 THEN NULL 
            WHEN order_line_number > 20 THEN NULL
            ELSE order_line_number
      END as order_line_number

      ,CASE 
            WHEN quantity_ordered < 1 THEN NULL 
            WHEN quantity_ordered > 30 THEN NULL
            ELSE quantity_ordered
      END as quantity_ordered 

      ,CASE 
            WHEN unit_list_price IS NULL THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(unit_list_price, '$', ''), ',', '')) 
      END as unit_list_price 

      ,CASE 
            WHEN discount_pct IS NULL OR discount_pct < 0 THEN NULL 
            ELSE ROUND(discount_pct, 0)
      END as discount_pct

      ,CASE 
            WHEN unit_selling_price IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_selling_price, '$', ''), ',', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_selling_price, '$', ''), ',', ''))
      END as unit_selling_price

      ,CASE 
            WHEN line_total_before_tax IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_before_tax, '$', ''), ',', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_before_tax, '$', ''), ',', ''))
      END as line_total_before_tax

      ,CASE 
            WHEN tax_rate_pct IS NULL OR TRY_CONVERT(INT, ROUND(tax_rate_pct, 0)) < 0 THEN NULL 
            ELSE TRY_CONVERT(INT, ROUND(tax_rate_pct, 0))
      END as tax_rate_pct

      ,CASE 
            WHEN tax_amount IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(tax_amount, '$', ''), ',', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(tax_amount, '$', ''), ',', ''))
      END as tax_amount

      ,CASE 
            WHEN line_total_with_tax IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_with_tax, '$', ''), ',', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_with_tax, '$', ''), ',', ''))
      END as line_total_with_tax

      ,CASE 
            WHEN cost_price IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price, '$', ''), ',', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price, '$', ''), ',', ''))
      END as cost_price

      ,CASE 
            WHEN gross_profit IS NULL THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(gross_profit, '$', ''), ',', ''))
      END as gross_profit

      ,CASE 
            WHEN order_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE , order_date)
            WHEN order_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE , order_date)
            WHEN order_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE , order_date)
            WHEN order_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE , order_date)
            WHEN order_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(order_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 101)
            WHEN order_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(order_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 110)
            WHEN order_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(order_date, 2)) > 12         THEN TRY_CONVERT(DATE, order_date, 103) 
            WHEN order_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(order_date, 2)) > 12         THEN TRY_CONVERT(DATE, order_date, 105) 
            ELSE TRY_CONVERT(DATE, TRIM(order_date), 101)
      END as order_date

      ,order_month

      ,CASE 
            WHEN ship_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE , ship_date)
            WHEN ship_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE , ship_date)
            WHEN ship_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE , ship_date)
            WHEN ship_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE , ship_date)
            WHEN ship_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(ship_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, ship_date, 101)
            WHEN ship_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(ship_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, ship_date, 110)
            WHEN ship_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(ship_date, 2)) > 12         THEN TRY_CONVERT(DATE, ship_date, 103) 
            WHEN ship_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(ship_date, 2)) > 12         THEN TRY_CONVERT(DATE, ship_date, 105) 
            ELSE TRY_CONVERT(DATE, TRIM(ship_date), 101)
      END as ship_date

      ,CASE 
            WHEN delivery_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE , delivery_date)
            WHEN delivery_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE , delivery_date)
            WHEN delivery_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE , delivery_date)
            WHEN delivery_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE , delivery_date)
            WHEN delivery_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(delivery_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, delivery_date, 101)
            WHEN delivery_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(delivery_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, delivery_date, 110)
            WHEN delivery_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(delivery_date, 2)) > 12         THEN TRY_CONVERT(DATE, delivery_date, 103) 
            WHEN delivery_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(delivery_date, 2)) > 12         THEN TRY_CONVERT(DATE, delivery_date, 105) 
            ELSE TRY_CONVERT(DATE, TRIM(delivery_date), 101)
      END as delivery_date

      ,TRY_CONVERT(DATE, record_created_ts) as record_created
      ,TRY_CONVERT(DATE, last_modified_ts ) as last_modified
      ,ROW_NUMBER() OVER(
            PARTITION BY transaction_id
            ORDER BY transaction_id
        ) AS rn
FROM bronze.sales_transactions 
 )t WHERE rn = 1; 