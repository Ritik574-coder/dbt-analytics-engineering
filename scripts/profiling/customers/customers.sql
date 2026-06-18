--#############################################################################################
--#################################### CUSTOEMR DATA ##########################################
--#############################################################################################

--=============================================================================================
--=========================== customers table overview ========================================
--=============================================================================================
SELECT TOP (1000) 
       [customer_id]
      ,[title]
      ,[first_name]
      ,[last_name]
      ,[full_name]
      ,[gender]
      ,[date_of_birth]
      ,[age]
      ,[email]
      ,[phone]
      ,[address]
      ,[city]
      ,[state]
      ,[state_abbr]
      ,[state_full]
      ,[zip_code]
      ,[country]
      ,[region]
      ,[customer_segment]
      ,[loyalty_points]
      ,[is_active]
      ,[account_created_date]
      ,[preferred_channel]
      ,[annual_income_usd]
      ,[company]
FROM [bronze].[customers]

--=============================================================================================
--========================= customers id NULL and buplicate count =============================
--=============================================================================================
SELECT 
    customer_id,
    COUNT(*) customer_count
FROM 
bronze.customers 
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL ;

--=============================================================================================
--============================== null and duplicate hendling ==================================
--=============================================================================================
SELECT 
    *
FROM(
    SELECT 
        *,
    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY customer_id DESC) AS last_flag
    FROM bronze.customers 
    WHERE customer_id IS NOT NULL 
)t WHERE last_flag = 1 ;

--=============================================================================================
--=========================== customers is_active cleaning ====================================
--=============================================================================================
-- unique value check 
SELECT DISTINCT 
    TRIM(LOWER(is_active)) as is_active
FROM bronze.customers ;


SELECT DISTINCT
CASE TRIM(LOWER(is_active))
    WHEN '0'        THEN 'False'
    WHEN '1'        THEN 'True'
    WHEN 'active'   THEN 'True'
    WHEN 'inactive' THEN 'False'
    WHEN 'false'    THEN 'False'
    WHEN 'true'     THEN 'True'
    WHEN 'n'        THEN 'False'
    WHEN 'y'        THEN 'True'
    WHEN 'no'       THEN 'False'
    WHEN 'yes'      THEN 'True'
    ELSE 'Unknown'
END AS is_active
FROM bronze.customers ;

--=============================================================================================
--=========================== customers preferred_channel cleaning ============================
--=============================================================================================
SELECT DISTINCT 
    TRIM(LOWER(preferred_channel)) AS preferred_channel
FROM bronze.customers ;

SELECT DISTINCT
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
        WHEN 'phone'      THEN 'Phone'
        ELSE 'Unknown'
    END as preferred_channel
FROM bronze.customers ;

--=============================================================================================
--=============================== customers gender column cleaning ============================
--=============================================================================================
SELECT DISTINCT 
    TRIM(LOWER(gender)) AS gender
FROM bronze.customers ;


SELECT 
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
    END as gender
FROM bronze.customers ;

--=============================================================================================
--=============================== customers company column cleaning ===========================
--=============================================================================================

SELECT DISTINCT
CASE 
    WHEN company IS NULL THEN 'Unknown'
    WHEN TRIM(REPLACE(REPLACE(company, CHAR(13), ''), CHAR(10), '')) = '' THEN 'Unknown'
    ELSE TRIM(REPLACE(REPLACE(company, CHAR(13), ''), CHAR(10), ''))
END AS company
FROM bronze.customers;

--=============================================================================================
--=============================== customers country column cleaning ===========================
--=============================================================================================
SELECT DISTINCT 
    TRIM(LOWER(country)) AS country
FROM bronze.customers ;

SELECT DISTINCT
CASE TRIM(LOWER(country))
    WHEN 'u.s.a'         THEN 'United States'
    WHEN 'us'            THEN 'United States'
    WHEN 'usa'           THEN 'United States'
    WHEN 'united states' THEN 'United States'
    ELSE 'Unknown'
END as country
FROM bronze.customers;

--=============================================================================================
--=============================== customers customer_segment cleaning =========================
--=============================================================================================
SELECT DISTINCT 
    customer_segment
FROM bronze.customers

SELECT DISTINCT
CASE 
    WHEN customer_segment IS NULL THEN 'Unknown'
    ELSE customer_segment
END as customer_segment
FROM bronze.customers

--=============================================================================================
--================================== customers rigion cleaning ================================
--=============================================================================================
SELECT DISTINCT
    region
FROM bronze.customers ;

SELECT DISTINCT
    CASE 
        WHEN TRIM(region) IS NULL THEN 'Unknown'
        ELSE TRIM(region)
    END as region
FROM bronze.customers ;

--=============================================================================================
--============================ customers annual_income_usd cleaning ===========================
--=============================================================================================
--total count
SELECT COUNT(*) FROM bronze.customers ;

-- null value count 
SELECT 
    annual_income_usd,
    COUNT(*) as null_count
FROM bronze.customers 
WHERE annual_income_usd IS NULL
GROUP BY annual_income_usd;

-- Diagnose NULLs
SELECT 
    COUNT(*) as total_row,
    COUNT(annual_income_usd) as non_null,
    COUNT(*) - COUNT(annual_income_usd) as total_null
FROM bronze.customers

--check pattern
SELECT * 
FROM bronze.customers
WHERE annual_income_usd IS NULL ;

-- handling null value with using median
SELECT 
customer_segment,
COALESCE(
    annual_income_usd,
    PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY annual_income_usd)
    OVER(PARTITION BY customer_segment)
) as annual_income_usd
FROM bronze.customers ; 
--=============================================================================================
--============================ customers loyalty_points cleaning ==============================
--=============================================================================================

-- root cause analysis to understood why loyalty_points some value are null
SELECT 
    TOP 100 *
FROM bronze.customers 
WHERE loyalty_points IS NULL ;

-- loyalty_points data profiling
SELECT 
    customer_id ,
    TRIM(full_name) as full_name,
    TRIM(city) as city,
    TRIM(state_full) as state_name,
    zip_code,
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
    END as preferred_channel,
    customer_segment,
    loyalty_points
FROM bronze.customers 
WHERE loyalty_points IS NULL;

-- Semantic validation: checking NULL loyalty points by customer segment
SELECT 
    customer_segment,
    COUNT(*) loyalty_points_null_count
FROM bronze.customers
WHERE loyalty_points IS NULL
GROUP BY customer_segment
ORDER BY customer_segment ;

-- Semantic validation: checking NULL loyalty points by region
SELECT 
    region,
    COUNT(*) loyalty_points_null_count
FROM bronze.customers
WHERE loyalty_points IS NULL 
GROUP BY region 
ORDER BY region ;

-- Semantic validation: checking NULL loyalty points by region
WITH cl_gender AS (
    SELECT 
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
        END as st_gender,
        loyalty_points
    FROM bronze.customers
)
SELECT 
    st_gender,
    COUNT(*) loyalty_points_null_count
FROM cl_gender 
WHERE loyalty_points IS NULL 
GROUP BY st_gender
ORDER BY st_gender ;

-- null percentage  check 
SELECT 
    customer_segment,
    COUNT(
        CASE 
            WHEN loyalty_points IS NULL THEN 1
        END
    ) AS null_count,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(
            CASE 
                WHEN loyalty_points IS NULL THEN 1
            END
        ) * 100.0 / COUNT(*),2
    ) AS null_percentage
FROM bronze.customers
GROUP BY customer_segment
ORDER BY null_percentage DESC;

-- this is only for gold layer
SELECT 
    customer_segment,
    CAST(COALESCE(
        loyalty_points,
        PERCENTILE_CONT(0.5)
        WITHIN GROUP(ORDER BY loyalty_points)
        OVER(PARTITION BY customer_segment)
    )AS INT) as loyalty_points
FROM bronze.customers ;

--=============================================================================================
--============================== customers zip_code cleaning ==================================
--=============================================================================================
-- customer zip_code data profiling
SELECT DISTINCT
    zip_code,
    LEN(zip_code) as zip_length
FROM bronze.customers 
WHERE LEN(zip_code) != 5 
OR zip_code IS NULL ;

-- customer zip_code data type profiling
SELECT 
    *
FROM bronze.customers
WHERE TRY_CAST(zip_code AS INT) IS NULL
    AND zip_code IS NOT NULL ;
    
-- data type check 
SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE 
TABLE_SCHEMA = 'bronze'
    AND TABLE_NAME = 'customers'
    AND COLUMN_NAME = 'zip_code'
;

-- fineal query after Semantic validation
WITH clean_zip AS 
(
    SELECT 
        CASE 
            WHEN zip_code IS NULL THEN 0
            WHEN LEN(zip_code) != 5 THEN 0
            WHEN TRY_CAST(zip_code AS INT) IS NULL THEN 0
            ELSE zip_code
        END as zip_code
    FROM bronze.customers
)
SELECT 
    *
FROM clean_zip
WHERE zip_code IS NULL 
    OR zip_code = 0 
    OR zip_code = 0;
--=============================================================================================
--============================== customers state_full cleaning ================================
--=============================================================================================
-- csutomer data profiling
SELECT 
    * 
FROM bronze.customers 
WHERE state_full IS NULL

-- unique state check 
SELECT DISTINCT 
    state_full
FROM bronze.customers ;

-- state repation count
SELECT DISTINCT 
    state_full,
COUNT(*) as total_state 
FROM bronze.customers 
    GROUP BY state_full 
    HAVING COUNT(*) >= 1 
    ORDER BY COUNT(*) DESC ;

-- fineal query after Semantic validation
SELECT DISTINCT
    CASE 
        WHEN TRIM(state_full) IS NULL OR TRIM(state_full) = '' THEN 'Unknown'
        ELSE TRIM(state_full)
    END as state_full
FROM bronze.customers ;

--=============================================================================================
--=================================== customers state cleaning ================================
--=============================================================================================
--raw data inspection
SELECT DISTINCT 
    TRIM([state]) state, 
    TRIM(state_abbr) as state_abbr,
    TRIM(state_full) as state_full
FROM bronze.customers ;

-- column check where it countain state abber in state column 
SELECT DISTINCT 
    TRIM(UPPER(state)) as state_abber 
FROM bronze.customers
WHERE LEN(TRIM(state)) = 2 ;

-- column check where it contain state_full column in state column 
SELECT DISTINCT 
    TRIM(state) as state_full
FROM bronze.customers
WHERE LEN(TRIM(state)) != 2 ;

-- finding root cause of state column contain state_full value
SELECT DISTINCT 
    TRIM(state) as state_full,
    state_full as state_full_r
FROM bronze.customers
WHERE LEN(TRIM(state))!=  2;

-- finding root cause of state column contain state_abber value
SELECT DISTINCT 
    TRIM(state) as state_abber_w ,
    state_abbr as state_abber_r
FROM bronze.customers
WHERE LEN(TRIM(state)) = 2;

-- finding root cause of state column contain state_abber value but not match with state_abbr column
SELECT DISTINCT 
    TRIM(state) as state_abber_w ,
    state_abbr as state_abber_r
FROM bronze.customers
WHERE LEN(TRIM(state)) = 2
AND TRIM(UPPER(state)) != TRIM(UPPER(state_abbr)) ;

-- finding root cause of state column contain state_full value but not match with state_full column
SELECT DISTINCT 
    TRIM(state) as state_full_w ,
    state_full as state_full_r
FROM bronze.customers
WHERE LEN(TRIM(state)) != 2
AND TRIM(UPPER(state)) != TRIM(UPPER(state_full)) ;

--=============================================================================================
--=================================== customers city cleaning =================================
--=============================================================================================
-- customer city raw data inspection
SELECT 
* 
FROM bronze.customers
WHERE city IS NULL ;

-- unique city check
SELECT DISTINCT 
    TRIM(LOWER(city)) as city
FROM bronze.customers ; 

-- final query after semantic validation
WITH city_clean AS 
(
    SELECT 
        CASE 
            WHEN TRIM(LOWER(city)) = ''             THEN 'Unknown'
            WHEN TRIM(LOWER(city)) IS NULL          THEN 'Unknown'
            WHEN TRIM(LOWER(city)) = 'an diego'     THEN 'san diego'
            WHEN TRIM(LOWER(city)) = 'chiago'       THEN 'chicago'
            WHEN TRIM(LOWER(city)) = 'chrlotte'     THEN 'charlotte'
            WHEN TRIM(LOWER(city)) = 'dalla'        THEN 'dallas'
            WHEN TRIM(LOWER(city)) = 'inneapolis'   THEN 'minneapolis'
            WHEN TRIM(LOWER(city)) = 'louiville'    THEN 'louisville'
            WHEN TRIM(LOWER(city)) = 'milwakee'     THEN 'milwaukee'
            WHEN TRIM(LOWER(city)) = 'mnneapolis'   THEN 'minneapolis'
            WHEN TRIM(LOWER(city)) = 'oklahoma cty' THEN 'oklahoma city'
            WHEN TRIM(LOWER(city)) = 'ortland'      THEN 'portland'
            WHEN TRIM(LOWER(city)) = 'sa diego'     THEN 'san diego'
            WHEN TRIM(LOWER(city)) = 'san ntonio'   THEN 'san antonio'
            WHEN TRIM(LOWER(city)) = 'sn antonio'   THEN 'san antonio'
            ELSE TRIM(LOWER(city))
        END as city
    FROM bronze.customers 
)
SELECT DISTINCT 
    city,
    COUNT(*) as city_count
FROM city_clean 
GROUP BY city
HAVING COUNT(*) >= 1
ORDER BY city_count DESC ;

--=============================================================================================
--================================ customers address cleaning =================================
--=============================================================================================
-- raw data inspection in address column
SELECT 
    address
FROM bronze.customers ;

-- final query after pattern validation
SELECT
    CASE 
        WHEN [address] IS NULL OR [address] = '' THEN 'Unknown'
        ELSE [address]
    END as address 
FROM bronze.customers ;

--=============================================================================================
--=========================== customers account_created_date cleaning =========================
--=============================================================================================

-- account_created_date raw data inspection
SELECT 
    account_created_date
FROM bronze.customers ;

-- account_created_date structural pattern profiling
SELECT DISTINCT
TRANSLATE(
    LOWER(TRIM(account_created_date)),
    '0123456789abcdefghijklmnopqrstuvwxyz',
    '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
) AS patter
FROM bronze.customers ;

-- account_created_date pattern frequency analysis and structural pattern profiling
WITH create_date_pattern AS 
(
    SELECT 
    TRANSLATE(
        LOWER(TRIM(account_created_date)),
        '0123456789abcdefghijklmnopqrstuvwxyz',
        '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
    ) AS pattern
    FROM bronze.customers
)
SELECT 
    pattern,
    COUNT(*) pattern_count
FROM create_date_pattern 
GROUP BY pattern 
ORDER BY COUNT(*) DESC ;

-- account_created_date format classification analysis
WITH patter_count AS 
(
SELECT 
    CASE
        WHEN account_created_date LIKE '[A-Z][a-z][a-z] __, ____' THEN 'Mon DD, YYYY'
        WHEN account_created_date LIKE '[A-Z][a-z]% __, ____'     THEN 'Month DD, YYYY'
        WHEN account_created_date LIKE '____-__-__'               THEN 'YYYY-MM-DD'
        WHEN account_created_date LIKE '____/__/__'               THEN 'YYYY/MM/DD'
        WHEN account_created_date LIKE '__-__-____'               THEN 'DD-MM-YYYY'
        WHEN account_created_date LIKE '__/__/____'               THEN 'MM/DD/YYYY or DD/MM/YYYY'
        ELSE 'Unknown_patter'
    END AS detected_pattern
FROM bronze.customers
)
SELECT 
detected_pattern,
COUNT(*) as patter_count
FROM patter_count
GROUP BY detected_pattern
ORDER BY COUNT(*) DESC ;

-- normalize Mon DD, YYYY dates into ISO standardization
SELECT 
    account_created_date,
    CONVERT(DATE,account_created_date) AS iso_date
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '[A-Z][a-z][a-z] __, ____';

-- normalize Month DD, YYYY dates into ISO standardization
SELECT 
    account_created_date,
    CONVERT(DATE,account_created_date) AS iso_date
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '[A-Z][a-z][a-z][a-z]% __, ____';

-- normalize YYYY/MM/DD dates into ISO standardization
SELECT 
    account_created_date,
    CONVERT(DATE,account_created_date) AS iso_date
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '____/__/__';

-- normalize DD-MM-YYYY dates into ISO standardization
SELECT 
    account_created_date,
    CONVERT(DATE,account_created_date) AS iso_date
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '____-__-__';

-- normalize MM-DD-YYYY dates into ISO standardization
SELECT 
    account_created_date,
    CONVERT(DATE,account_created_date) AS iso_date   -- Error --> Conversion failed when converting date and/or time from character string.
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '__-__-____';

-- normalize MM/DD/YYYY dates into ISO standardization
SELECT 
    account_created_date,
    CONVERT(DATE,account_created_date) AS iso_date   -- Error --> Conversion failed when converting date and/or time from character string.
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '__/__/____';

-- normalize MM/DD/YYYY dates into ISO standardization
SELECT 
    account_created_date,
    date_of_birth
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '__/__/____'
AND TRIM(date_of_birth) LIKE '__/__/____';

-- dash format date pattern classification with error handling
SELECT 
    account_created_date,
    CASE
        WHEN CAST(LEFT(account_created_date,2) AS INT) > 12
            THEN TRY_CONVERT(DATE, account_created_date, 105) -- DD-MM-YYYY
        WHEN CAST(SUBSTRING(account_created_date,4,2) AS INT) > 12
            THEN TRY_CONVERT(DATE, account_created_date, 110) -- MM-DD-YYYY
        ELSE NULL
    END AS iso_date
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '__-__-____';

-- slash format date pattern classification with error handling
SELECT 
    account_created_date,
    CASE
        WHEN CAST(LEFT(account_created_date,2) AS INT) > 12 THEN TRY_CONVERT(DATE, account_created_date, 103) 
        WHEN CAST(SUBSTRING(account_created_date,4,2) AS INT) > 12 THEN TRY_CONVERT(DATE, account_created_date, 101)
        ELSE NULL
    END AS iso_date
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '__/__/____';

-- slash-format date ambiguity detection and ISO standardization
SELECT 
    account_created_date,
    CASE
        WHEN CAST(LEFT(account_created_date,2) AS INT) > 12 THEN TRY_CONVERT(DATE, account_created_date, 103) 
        WHEN CAST(SUBSTRING(account_created_date,4,2) AS INT) > 12  THEN TRY_CONVERT(DATE, account_created_date, 101) 
        ELSE NULL
    END AS iso_date,
    CASE
        WHEN CAST(LEFT(account_created_date,2) AS INT) > 12 THEN 'DD/MM/YYYY'
        WHEN CAST(SUBSTRING(account_created_date,4,2) AS INT) > 12 THEN 'MM/DD/YYYY'
        ELSE 'AMBIGUOUS_DATE'
    END AS parsing_status
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '__/__/____';

-- slash-format date ambiguity distribution analysis
WITH format_catch AS 
(
    SELECT 
        CASE 
            WHEN CAST(LEFT(account_created_date,2)AS INT) > 12 THEN 'DD/MM/YYYY'
            WHEN CAST(SUBSTRING(account_created_date,4,2) AS INT) > 12 THEN 'MM/DD/YYYY'
            ELSE 'AMBIGUOUS_DATE'
        END  detected_format
    FROM bronze.customers
    WHERE TRIM(account_created_date) LIKE '__/__/____'
)
SELECT 
    detected_format,
    COUNT(*) as total_records,
    ROUND(COUNT(*) * 100/SUM(COUNT(*)) OVER(), 2) as percentage 
FROM format_catch
    GROUP BY detected_format
    ORDER BY total_records DESC ;

-- dash-format date parsing and ISO conversion analysis
WITH dash_format_catch AS 
(
    SELECT 
        CASE 
            WHEN TRIM(account_created_date) LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(account_created_date,2)) > 12
            THEN TRY_CONVERT(DATE, account_created_date, 105)

            WHEN TRIM(account_created_date) LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(account_created_date,4,2)) > 12
            THEN TRY_CONVERT(DATE, account_created_date, 110)
        END AS iso_date
    FROM bronze.customers
)
SELECT 
    iso_date,
    COUNT(*) as total_records,
    ROUND(COUNT(*) * 100/SUM(COUNT(*)) OVER(), 2) as percentage
FROM dash_format_catch
WHERE iso_date IS NOT NULL
    GROUP BY iso_date
    ORDER BY total_records DESC ;

-- slash-format date parsing and ISO conversion analysis
WITH slash_format_catch AS 
(
    SELECT
        CASE 
            WHEN TRIM(account_created_date) LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(account_created_date,2)) > 12
            THEN TRY_CONVERT(DATE, account_created_date, 103)
            WHEN TRIM(account_created_date) LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(account_created_date, 4, 2)) > 12
            THEN TRY_CONVERT(DATE, account_created_date, 101)
        END iso_date
    FROM bronze.customers
)
SELECT 
    iso_date,
    COUNT(*) as total_records,
    ROUND(COUNT(*) * 100/SUM(COUNT(*)) OVER(),2) as percentage 
FROM slash_format_catch
WHERE iso_date IS NOT NULL 
    GROUP BY iso_date 
    ORDER BY total_records DESC ;

-- final account_created_date ISO standardization pipeline
SELECT 
    CASE
        WHEN TRIM(account_created_date) LIKE '[A-Z][a-z][a-z] __, ____'       THEN CONVERT(DATE,account_created_date)
        WHEN TRIM(account_created_date) LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN CONVERT(DATE,account_created_date)
        WHEN TRIM(account_created_date) LIKE '____/__/__'                     THEN CONVERT(DATE,account_created_date)
        WHEN TRIM(account_created_date) LIKE '____-__-__'                     THEN CONVERT(DATE,account_created_date)
        WHEN TRIM(account_created_date) LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(account_created_date,2)) > 12 THEN TRY_CONVERT(DATE, account_created_date, 105)
        WHEN TRIM(account_created_date) LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(account_created_date,4,2)) > 12 THEN TRY_CONVERT(DATE, account_created_date, 110)
        WHEN TRIM(account_created_date) LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(account_created_date,2)) > 12 THEN TRY_CONVERT(DATE, account_created_date, 103)
        WHEN TRIM(account_created_date) LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(account_created_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, account_created_date, 101)
        ELSE TRY_CONVERT(DATE, account_created_date,101) -->> Ambiguous dates were standardized using MM/DD/YYYY fallback logic based on overall dataset directional pattern analysis, where month-first formatting represented the dominant ecosystem across the dataset.
    END as account_created_date 
FROM bronze.customers
WHERE TRIM(account_created_date) LIKE '[A-Z][a-z][a-z] __, ____'
    OR TRIM(account_created_date) LIKE '[A-Z][a-z][a-z][a-z]% __, ____'
    OR TRIM(account_created_date) LIKE '____/__/__'
    OR TRIM(account_created_date) LIKE '____-__-__'
    OR CAST(LEFT(account_created_date,2)AS INT) > 12 
    OR CAST(SUBSTRING(account_created_date,4,2)AS INT) > 12
 ;

--=============================================================================================
--=============================== customers phone number cleaning =============================
--=============================================================================================
-- account_created_date raw data inspection
SELECT 
    phone
FROM bronze.customers ;

-- unique check 
SELECT DISTINCT 
    phone
FROM bronze.customers ;

-- null check 
SELECT 
    COUNT(*) phone_null_count
FROM bronze.customers 
WHERE phone IS NULL OR phone = '';

-- account_created_date structural pattern profiling
WITH phone_pattern AS 
(
    SELECT 
        TRANSLATE
        (
            TRIM(phone),
            '0123456789',
            '9999999999'
        ) as Patterns 
    FROM bronze.customers
)
SELECT 
    Patterns,
    LEN(Patterns) as pattern_length,
    COUNT(*) as pattern_count,
    CAST(ROUND(COUNT(*) * 100/SUM(COUNT(*)) OVER(),2)AS NVARCHAR) + '%' as percentage
FROM phone_pattern
    GROUP BY Patterns
    ORDER BY pattern_count DESC ;

-- identify +1 standardized US phone numbers
SELECT 
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '+1__________' ;

-- format canonical US phone numbers into readable display format
SELECT 
CONCAT
    (
        '+1 (', SUBSTRING(TRIM(phone),3, 3), ') ',
        SUBSTRING(TRIM(phone), 6, 3), '-',
        SUBSTRING(TRIM(phone), 9, 4)
    )
FROM bronze.customers
WHERE TRIM(phone) LIKE '+1__________';

-- identify raw 10-digit US phone numbers
SELECT 
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '__________' ;

-- format raw US phone numbers into standard display format
SELECT 
    CONCAT('+1 (', SUBSTRING(TRIM(phone), 1 ,3), ') ', SUBSTRING(TRIM(phone), 4 ,3), '-', SUBSTRING(TRIM(phone), 7, 4))
FROM bronze.customers
WHERE TRIM(phone) LIKE '__________' ;

-- identify dash-formatted US phone numbers
SELECT 
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '___-___-____' ;

-- standardize dash-formatted phone numbers into US display format
SELECT 
    CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3),SUBSTRING(TRIM(phone), 8 ,5))
FROM bronze.customers
WHERE TRIM(phone) LIKE '___-___-____' ;

-- identify dot-formatted US phone numbers
SELECT 
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '___.___.____' ;

-- standardize dot-formatted phone numbers into US display format
SELECT 
    CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3), '-', SUBSTRING(TRIM(phone),9, 4))
FROM bronze.customers
WHERE TRIM(phone) LIKE '___.___.____' ;

-- identify parenthesized US phone numbers
SELECT
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '(___) ___-____' ;

-- normalize parenthesized phone numbers into canonical US format
SELECT 
    CONCAT('+1 ', SUBSTRING(TRIM(phone), 1, 14))
FROM bronze.customers
WHERE TRIM(phone) LIKE '(___) ___-____' ;

-- identify invalid 9-digit phone numbers caused by incomplete or malformed source data
SELECT
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '_________' ; 

-- identify malformed international phone numbers with missing US country code structure
SELECT
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '+__________' ;

-- identify invalid parenthesized phone numbers with incomplete area codes
SELECT
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '(__) ___-____' ;

-- identify malformed dot-formatted phone numbers with incomplete area codes
SELECT
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '__.___.____' ;

-- identify suspicious dash-formatted values resembling non-standard US phone structures
SELECT
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '___-__-____' ;

-- identify suspicious dash-formatted values resembling non-standard US phone structures
SELECT
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '___-__-____' ;

-- identify malformed dot-formatted phone numbers with incomplete digit grouping
SELECT
    TRIM(phone)
FROM bronze.customers
WHERE TRIM(phone) LIKE '___.__.____' ;

-- final phone column in  usa phone standardization format
SELECT
    CASE 
        WHEN TRIM(phone) LIKE '+1__________'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 3, 3), ') ', SUBSTRING(TRIM(phone), 6, 3),'-',SUBSTRING(TRIM(phone),9,4))
        WHEN TRIM(phone) LIKE '__________'     THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1 ,3), ') ', SUBSTRING(TRIM(phone), 4 ,3), '-', SUBSTRING(TRIM(phone), 7, 4))
        WHEN TRIM(phone) LIKE '___-___-____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3),SUBSTRING(TRIM(phone), 8 ,5))
        WHEN TRIM(phone) LIKE '___.___.____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3), '-', SUBSTRING(TRIM(phone),9, 4))
        WHEN TRIM(phone) LIKE '(___) ___-____' THEN CONCAT('+1 ', SUBSTRING(TRIM(phone), 1, 14))
        WHEN TRIM(phone) IS NULL OR TRIM(phone) = '' THEN 'Unknown'
        ELSE 'Unknown'
    END  as usa_phone_pattern
FROM bronze.customers
WHERE TRIM(phone) LIKE '+1__________'
OR    TRIM(phone) LIKE '__________' 
OR    TRIM(phone) LIKE '___-___-____'
OR    TRIM(phone) LIKE '___.___.____'
OR    TRIM(phone) LIKE '(___) ___-____'
OR    TRIM(phone) = ''
OR    TRIM(phone) IS NULL;

--=============================================================================================
--=============================== customers phone number cleaning =============================
--=============================================================================================
-- customer email column data profiling
SELECT 
    email 
FROM bronze.customers ;

-- null check in email column 
SELECT 
    email 
FROM bronze.customers 
WHERE email IS NOT NULL 
OR email != '';

-- null count in email column 
SELECT 
    COUNT(*) null_count
FROM bronze.customers 
WHERE email IS NULL 
OR email = '';

-- email domain check 
SELECT 
email
FROM bronze.customers
WHERE PATINDEX('%@%@%', email) > 0

-- check email domain that contain email column  
SELECT DISTINCT 
SUBSTRING(email, CHARINDEX('@', email)+1, LEN(email)) as domain 
FROM bronze.customers

-- check email where  @ are messing 
SELECT 
    email
FROM bronze.customers
WHERE email NOT LIKE '%@%' ;

-- check email where username are messing 
SELECT 
    email
FROM bronze.customers
WHERE email LIKE '@%' ;

--check email where domain are messing 
SELECT 
    email
FROM bronze.customers
WHERE email LIKE '%@' ;

-- check email where dot are messing 
SELECT 
    email
FROM bronze.customers
WHERE email NOT LIKE '%.__%' 

-- at symbol repetition check in email column
SELECT
    email,
    CASE
        WHEN PATINDEX('%@%@%', TRIM(LOWER(email))) > 0
        THEN LEFT(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email)))) + REPLACE(SUBSTRING(TRIM(LOWER(email)),
        CHARINDEX('@', TRIM(LOWER(email))) + 1,LEN(email)),'@','')
    END AS cleaned_email
FROM bronze.customers
WHERE PATINDEX('%@%@%', email) > 0;

-- final email cleaning query after pattern validation
WITH customer_email AS 
(
    SELECT
        email,
        CASE
            WHEN PATINDEX('%@%@%', TRIM(LOWER(email))) > 0
            THEN LEFT(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email)))) + REPLACE(SUBSTRING(TRIM(LOWER(email)),
            CHARINDEX('@', TRIM(LOWER(email))) + 1,LEN(email)),'@','')
        END AS cleaned_email
    FROM bronze.customers
)
SELECT 
    *
FROM customer_email
WHERE PATINDEX('%@%@%', email) > 0 ;

--final email cleaning query after pattern validation
WITH clean_email AS 
(
SELECT
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
                    WHEN RIGHT(TRIM(LOWER(email)), LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'yahoocom' THEN 'yahoo.com'
                    WHEN RIGHT(TRIM(LOWER(email)), LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'iclod.com' THEN 'icloud.com'
                    WHEN RIGHT(TRIM(LOWER(email)), LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'outook.com' THEN 'outlook.com'
                    WHEN RIGHT(TRIM(LOWER(email)), LEN(TRIM(email)) - CHARINDEX('@', TRIM(email))) = 'ahoo.com' THEN 'yahoo.com'
                    ELSE RIGHT(TRIM(LOWER(email)), LEN(TRIM(email)) - CHARINDEX('@', TRIM(email)))
                END
            )
    END AS email

FROM bronze.customers
)
SELECT
    email
FROM clean_email
WHERE
    email NOT LIKE '%@%'
    OR email LIKE '@%'
    OR email LIKE '%@%@%'
    OR email LIKE '%.@%'
    OR email LIKE '%..%'
    OR email NOT LIKE '%@%.%'
--=============================================================================================
--=============================== customers date_of_birth cleaning ============================
--=============================================================================================
-- date of birth column data profiling 
SELECT 
    date_of_birth 
FROM bronze.customers ;

-- date_of_birth pattern check 
WITH date_of_birth AS 
(
    SELECT 
        TRANSLATE(
            TRIM(LOWER(date_of_birth)),
        '0123456789abcdefghijklmnopqrstuvwxyz' ,
        '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
        ) as birth_date_pattern
    FROM bronze.customers
)
SELECT
    birth_date_pattern,
    COUNT(*) AS total_count,
    CAST(ROUND(COUNT(*) * 100.0/SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' as percentage
FROM date_of_birth 
GROUP BY birth_date_pattern
ORDER BY total_count DESC ;

-- Detect DOB Records in DD/MM/YYYY Format
SELECT 
    TRIM(date_of_birth) as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE  '__/__/____' ;

-- Identify DD/MM/YYYY Records Where Day Value > 12
SELECT 
    TRIM(date_of_birth) as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(date_of_birth, 2)) > 12 ;

-- Convert DD/MM/YYYY Records to DATE Format Using Style 103
SELECT 
    CASE 
        WHEN TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(TRIM(date_of_birth), 2)) > 12 THEN TRY_CONVERT(DATE , date_of_birth, 103)
    END  as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(TRIM(date_of_birth), 2)) > 12;

-- Identify MM/DD/YYYY Records Where Month Value > 12
SELECT 
    TRIM(date_of_birth) as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(TRIM(date_of_birth), 4, 2)) > 12;

-- Convert MM/DD/YYYY Records to DATE Format Using Style 101
SELECT 
    CASE
        WHEN TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(TRIM(date_of_birth), 4, 2)) > 12 THEN TRY_CONVERT(DATE, TRIM(date_of_birth), 101)
    END as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(TRIM(date_of_birth), 4, 2)) > 12 ;

-- Detect DOB Records in YYYY/MM/DD Format
SELECT 
    TRIM(date_of_birth) as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '____/__/__' ;

-- Convert YYYY/MM/DD Records to DATE Format
SELECT 
    CASE 
        WHEN TRIM(date_of_birth) LIKE '____/__/__' THEN CONVERT(DATE, TRIM(date_of_birth))
    END  as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '____/__/__' ;

-- Detect DOB Records in YYYY-MM-DD Format
SELECT 
    TRIM(date_of_birth) as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '____-__-__' ;

-- Convert YYYY-MM-DD Records to DATE Format
SELECT 
    CASE 
        WHEN TRIM(date_of_birth) LIKE '____-__-__' THEN CONVERT(DATE, TRIM(date_of_birth))
    END  as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '____-__-__' ;

-- Detect DOB Records with Short Month Name Format (Mon DD, YYYY)
SELECT 
    TRIM(date_of_birth) as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z] __, ____' ;

-- Convert Short Month Name Format (Mon DD, YYYY) to DATE
SELECT 
    CASE 
        WHEN TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z] __, ____' THEN CONVERT(DATE, TRIM(date_of_birth))
    END  as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z] __, ____' ;

-- Detect DOB Records with Full Month Name Format (Month DD, YYYY)
SELECT 
    TRIM(date_of_birth) as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z][a-z]% __, ____' ;

-- Convert Full Month Name Format (Month DD, YYYY) to DATE
SELECT 
    CASE 
        WHEN TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN CONVERT(DATE, TRIM(date_of_birth))
    END  as date_of_birth
FROM bronze.customers
WHERE TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z][a-z]% __, ____' ;


-- fineal query 
WITH birth_date AS 
(
    SELECT 
        CASE
            WHEN TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE, TRIM(date_of_birth))
            WHEN TRIM(date_of_birth) LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE, TRIM(date_of_birth))
            WHEN TRIM(date_of_birth) LIKE '____-__-__'                     THEN TRY_CONVERT(DATE, TRIM(date_of_birth))
            WHEN TRIM(date_of_birth) LIKE '____/__/__'                     THEN TRY_CONVERT(DATE, TRIM(date_of_birth))

            WHEN TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(TRIM(date_of_birth), 4, 2)) > 12 THEN TRY_CONVERT(DATE,  TRIM(date_of_birth), 101)
            WHEN TRIM(date_of_birth) LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(TRIM(date_of_birth), 2)) > 12         THEN TRY_CONVERT(DATE , TRIM(date_of_birth), 103)

            WHEN TRIM(date_of_birth) LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(TRIM(date_of_birth), 4, 2)) > 12 THEN TRY_CONVERT(DATE,  TRIM(date_of_birth), 110)
            WHEN TRIM(date_of_birth) LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(TRIM(date_of_birth), 2)) > 12         THEN TRY_CONVERT(DATE , TRIM(date_of_birth), 105)
            ELSE TRY_CONVERT(DATE, TRIM(date_of_birth), 101)
        END date_of_birth
    FROM bronze.customers
)
SELECT 
    *
FROM birth_date ;

--=============================================================================================
--=============================== customers title cleaning ====================================
--=============================================================================================
-- custome name_title data profiling 
SELECT 
    title
FROM bronze.customers ;

-- profiling where title not equal to trim title 
SELECT 
    title 
FROM bronze.customers
WHERE title != TRIM(title) ;

-- title value chek in number and percentage 
SELECT 
    title ,
    COUNT(*) as title_count,
    CAST(ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' as percentage 
FROM bronze.customers 
    GROUP BY title 
    ORDER BY title_count DESC  ;

--=============================================================================================
--=================== customers full_name cleaning and validition  ============================
--=============================================================================================
-- data profiling 
SELECT 
    last_name
FROM bronze.customers ;

-- Full Name Mismatch Detection
SELECT 
    TRIM(LOWER(email)) as email ,
    TRIM(LOWER(full_name)) as full_name,
    TRIM(CONCAT(LOWER(title),' ',TRIM(LOWER(first_name)),' ', TRIM(LOWER(last_name))))  as full_name_ed 
FROM bronze.customers 
WHERE ISNULL(TRIM(full_name), '') != ISNULL(TRIM(CONCAT(LOWER(title),' ',TRIM(LOWER(first_name)),' ', TRIM(LOWER(last_name)))), '') ;

-- First and Last Name Extraction from Full Name
SELECT
    full_name,
    title,
    CASE
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ', '')) = 2 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ', '')) = 1 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
    END AS first_name,
   PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 1) AS last_name ,
   email
FROM bronze.customers ;

--#############################################################################################
--############################## CUSTOEMR CLEAN DATA ##########################################
--#############################################################################################
SELECT
    customer_id
    ,TRIM(title) as title
    ,CASE
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ', '')) = 2 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ', '')) = 1 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
    END AS first_name,
        PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 1) AS last_name

    ,CASE TRIM(LOWER(gender))
        WHEN 'f' THEN 'Female'
        WHEN 'female' THEN 'Female'
        WHEN 'm' THEN 'Male'
        WHEN 'male' THEN 'Male'
        WHEN 'nb' THEN 'Non-Binary'
        WHEN 'non-binary' THEN 'Non-Binary'
        WHEN 'other' THEN 'Other'
        WHEN 'prefer not to say' THEN 'Other'
        ELSE 'Unknown'
    END as gender
        
    ,CASE
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

    ,CASE
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
    END AS email

    ,CASE 
        WHEN TRIM(phone) LIKE '+1__________'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 3, 3), ') ', SUBSTRING(TRIM(phone), 6, 3),'-',   SUBSTRING(TRIM(phone),9,4))
        WHEN TRIM(phone) LIKE '__________'     THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1 ,3), ') ', SUBSTRING(TRIM(phone), 4 ,3), '-',  SUBSTRING(TRIM(phone), 7, 4))
        WHEN TRIM(phone) LIKE '___-___-____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3),       SUBSTRING(TRIM(phone), 8 ,5))
        WHEN TRIM(phone) LIKE '___.___.____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3), '-',  SUBSTRING(TRIM(phone),9, 4))
        WHEN TRIM(phone) LIKE '(___) ___-____' THEN CONCAT('+1 ',  SUBSTRING(TRIM(phone), 1, 14))
        WHEN TRIM(phone) IS NULL OR TRIM(phone) = '' THEN 'Unknown'
        ELSE 'Unknown'
    END  as phone

    ,CASE 
        WHEN [address] IS NULL OR [address] = '' THEN 'Unknown'
        ELSE [address]
    END as address

    ,CASE 
        WHEN TRIM(LOWER(city)) = 'an diego'     THEN dbo.TitleCase('san diego')
        WHEN TRIM(LOWER(city)) = 'chiago'       THEN dbo.TitleCase('chicago')
        WHEN TRIM(LOWER(city)) = 'chrlotte'     THEN dbo.TitleCase('charlotte')
        WHEN TRIM(LOWER(city)) = 'dalla'        THEN dbo.TitleCase('dallas')
        WHEN TRIM(LOWER(city)) = 'inneapolis'   THEN dbo.TitleCase('minneapolis')
        WHEN TRIM(LOWER(city)) = 'louiville'    THEN dbo.TitleCase('louisville')
        WHEN TRIM(LOWER(city)) = 'milwakee'     THEN dbo.TitleCase('milwaukee')
        WHEN TRIM(LOWER(city)) = 'mnneapolis'   THEN dbo.TitleCase('minneapolis')
        WHEN TRIM(LOWER(city)) = 'oklahoma cty' THEN dbo.TitleCase('oklahoma city')
        WHEN TRIM(LOWER(city)) = 'ortland'      THEN dbo.TitleCase('portland')
        WHEN TRIM(LOWER(city)) = 'sa diego'     THEN dbo.TitleCase('san diego')
        WHEN TRIM(LOWER(city)) = 'san ntonio'   THEN dbo.TitleCase('san antonio')
        WHEN TRIM(LOWER(city)) = 'sn antonio'   THEN dbo.TitleCase('san antonio')
        WHEN TRIM(city) = ''                    THEN 'Unknown'
        WHEN city IS NULL                       THEN 'Unknown'
        ELSE dbo.TitleCase(TRIM(city))
    END AS city

    ,CASE 
        WHEN TRIM(UPPER(state_abbr)) IS NULL OR TRIM(UPPER(state_abbr)) = '' THEN 'Unknown'
        WHEN LEN(TRIM(UPPER(state_abbr))) != 2 THEN 'Unknown'
        ELSE TRIM(UPPER(state_abbr))
    END as state_abbr
      
    ,CASE 
        WHEN TRIM(state_full) IS NULL OR TRIM(state_full) = '' THEN 'Unknown'
        ELSE TRIM(state_full)
    END as state

    ,CASE 
        WHEN zip_code IS NULL THEN 0
        WHEN LEN(zip_code) != 5 THEN 0
        WHEN TRY_CAST(zip_code AS INT) IS NULL THEN 0
        ELSE zip_code
    END as zip_code

    ,CASE 
         WHEN TRIM(LOWER(country)) IN ('u.s.a', 'us', 'usa', 'united states') THEN 'United States'
         ELSE 'Unknown'
    END as country

    ,CASE 
         WHEN region IS NULL OR TRIM(region) = '' THEN 'Unknown'
         ELSE TRIM(region)
    END as region

    ,CASE 
        WHEN customer_segment IS NULL OR customer_segment = '' THEN 'Unknown'
        ELSE customer_segment
    END as customer_segment

        ,loyalty_points

    ,CASE 
         WHEN TRIM(LOWER(is_active)) IN ('1', 'active', 'true', 'y', 'yes')   THEN 'True'
         WHEN TRIM(LOWER(is_active)) IN ('0', 'inactive', 'false', 'n', 'no') THEN 'False'
         ELSE 'Unknown'
    END AS is_active

    ,CASE
        WHEN TRIM(account_created_date) LIKE '[A-Z][a-z][a-z] __, ____'       THEN CONVERT(DATE,account_created_date)
        WHEN TRIM(account_created_date) LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN CONVERT(DATE,account_created_date)
        WHEN TRIM(account_created_date) LIKE '____/__/__'                     THEN CONVERT(DATE,account_created_date)
        WHEN TRIM(account_created_date) LIKE '____-__-__'                     THEN CONVERT(DATE,account_created_date)

        WHEN TRIM(account_created_date) LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(account_created_date,2)) > 12          THEN TRY_CONVERT(DATE, account_created_date, 105)
        WHEN TRIM(account_created_date) LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(account_created_date,4,2)) > 12   THEN TRY_CONVERT(DATE, account_created_date, 110)
        WHEN TRIM(account_created_date) LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(account_created_date,2)) > 12          THEN TRY_CONVERT(DATE, account_created_date, 103)
        WHEN TRIM(account_created_date) LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(account_created_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, account_created_date, 101)
        ELSE TRY_CONVERT(DATE, account_created_date,101)
    END as account_created_date 

    ,CASE TRIM(LOWER(preferred_channel))
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
        
    ,COALESCE(
        annual_income_usd,
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY annual_income_usd)
        OVER (PARTITION BY customer_segment)
    ) as annual_income_usd

    ,CASE 
        WHEN company IS NULL OR company = '' THEN 'Unknown'
        WHEN TRIM(REPLACE(REPLACE(company, CHAR(13), ''), CHAR(10), '')) = '' THEN 'Unknown'
        ELSE TRIM(REPLACE(REPLACE(company, CHAR(13), ''), CHAR(10), ''))
    END as company
FROM [bronze].[customers]
