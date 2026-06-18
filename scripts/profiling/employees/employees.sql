--#############################################################################################
--#################################### EMPLOYEE DATA ##########################################
--#############################################################################################


--=============================================================================================
--=========================== employees table overview ========================================
--=============================================================================================
SELECT TOP (1000) 
       [employee_id]
      ,[first_name]
      ,[last_name]
      ,[full_name]
      ,[email]
      ,[phone]
      ,[job_title]
      ,[department]
      ,[store_id]
      ,[store_name]
      ,[store_city]
      ,[hire_date]
      ,[years_employed]
      ,[annual_salary_usd]
      ,[commission_rate_pct]
      ,[is_active]
      ,[performance_rating]
      ,[manager_id]
  FROM [TestDB].[bronze].[employees]

--=============================================================================================
--=========================== employees_id cleaning ===========================================
--=============================================================================================
-- data profiling employee id  
SELECT 
    employee_id 
FROM bronze.employees 
WHERE employee_id IS NULL 
   OR employee_id < 0
   OR employee_id = '';

-- check those employee id they are successfully convert into int 
SELECT 
    employee_id 
FROM bronze.employees 
WHERE TRY_CONVERT(INT, employee_id) IS NOT NULL;

-- employee_id data type check 
SELECT 
    employee_id 
FROM bronze.employees 
WHERE TRY_CONVERT(INT, employee_id) IS NULL 
    AND employee_id IS NOT NULL; 

-- employee id duplicate check 
SELECT 
    * 
FROM
(
    SELECT 
        employee_id,
        ROW_NUMBER() OVER(PARTITION BY employee_id ORDER BY employee_id) as flag 
    FROM bronze.employees 
    WHERE employee_id IS NOT NULL 
)t WHERE flag != 1 

--=============================================================================================
--================================= name cleaning =============================================
--=============================================================================================
-- employee first_name overview 
SELECT TOP 100
    first_name
FROM bronze.employees ;

-- employee first_name data profiling
SELECT 
      first_name
FROM bronze.employees 
WHERE TRIM(first_name) != first_name 
   OR first_name = ''
   OR first_name IS NULL 

-- employee last_name overview 
SELECT TOP 100
    last_name
FROM bronze.employees ;

-- employee last name data profiling 
SELECT 
      last_name
FROM bronze.employees 
WHERE TRIM(last_name) != last_name 
   OR last_name = ''
   OR last_name IS NULL  ;


-- employee full_name overview 
SELECT TOP 100
    full_name
FROM bronze.employees ;
 
-- employee full_name data profiling 
SELECT 
      full_name 
FROM bronze.employees 
WHERE full_name != TRIM(full_name)
   OR full_name = ''
   OR full_name IS NULL ;

-- checking those first and last name they are not equel to full_name
SELECT 
    TRIM(LOWER(first_name)) as first_name ,
    TRIM(LOWER(last_name)) as last_name ,
    TRIM(LOWER(full_name)) as full_name ,
CONCAT(TRIM(LOWER(first_name)),' ', TRIM(LOWER(last_name))) as full_name_e
FROM bronze.employees
WHERE TRIM(LOWER(full_name)) != CONCAT(TRIM(LOWER(first_name)),' ', TRIM(LOWER(last_name))) ;

-- string parsing to get first and last name from full name
WITH clean_full_name AS 
(
    SELECT 
        CASE 
            WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ','')) = 1 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
        END as first_name,
            PARSENAME(REPLACE(TRIM(full_name),' ','.'),1) as last_name
    FROM bronze.employees
)
SELECT 
    *
FROM clean_full_name

--=============================================================================================
--================================= phone column cleaning =====================================
--=============================================================================================
-- employee phone overview
SELECT 
phone
FROM bronze.employees

-- employee phone data profiling
SELECT 
phone
FROM bronze.employees 
WHERE phone IS NULL 
   OR phone = '' 
   OR TRIM(phone) != phone 
   OR LEN(phone) < 10 ;

-- Performed phone number format profiling using pattern normalization and distribution analysis.
WITH phone_patterns AS 
(
    SELECT 
        TRANSLATE(
            phone,
            '0123456789',
            '9999999999'
        ) as patterns
    FROM bronze.employees
)
SELECT 
     patterns,
     LEN(patterns) AS len_count,
     COUNT(*) as pattern_count,
     CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' AS percentage 
FROM phone_patterns
     GROUP BY patterns
     ORDER BY pattern_count DESC ;

-- Does the phone number start with '+' and contain exactly 11 characters after it?
SELECT 
    phone 
FROM bronze.employees 
WHERE phone LIKE '+___________' ;

-- Dot-Separated Phone Format
SELECT 
    phone 
FROM bronze.employees 
WHERE phone LIKE '___.___.____' ;

-- Plain 10-Digit Phone Format
SELECT 
    phone 
FROM bronze.employees 
WHERE phone LIKE '__________' ;

-- Parenthesized US Phone Format
SELECT 
    phone 
FROM bronze.employees 
WHERE phone LIKE '(___) ___-____' ;

-- Hyphen-Separated Phone Format
SELECT 
    phone 
FROM bronze.employees 
WHERE phone LIKE '___-___-____' ;

-- Phone Format Normalization and Standardization
SELECT 
    CASE 
        WHEN phone LIKE '+___________'   THEN  CONCAT('+1 (', SUBSTRING(phone, 3, 3), ') ', SUBSTRING(phone, 6, 3), '-', SUBSTRING(phone, 9,4))
        WHEN phone LIKE '___.___.____'   THEN  CONCAT('+1 (', SUBSTRING(phone, 1,3), ') ' ,  SUBSTRING(phone,5, 3), '-',  SUBSTRING(phone,9,4))
        WHEN phone LIKE '__________'     THEN  CONCAT('+1 (', SUBSTRING(phone, 1,3), ') ' ,  SUBSTRING(phone, 4,3), '-',  SUBSTRING(phone,7,4))
        WHEN phone LIKE '___-___-____'   THEN  CONCAT('+1 (', SUBSTRING(phone,1, 3), ') ' ,  SUBSTRING(phone, 5,8))
        WHEN phone LIKE '(___) ___-____' THEN CONCAT('+1 ',   SUBSTRING(phone, 1, 14))
    END as phone
FROM bronze.employees  ;

--=============================================================================================
--================================= job_title column cleaning =================================
--=============================================================================================
-- No obvious spelling inconsistencies or naming mismatches detected in job titles.
SELECT 
    job_title,
    COUNT(*) as job_title_count
FROM bronze.employees
GROUP BY job_title
ORDER BY job_title_count DESC ;

-- -- Job Title Null Handling and Standardization
SELECT 
    CASE 
        WHEN job_title IS NULL OR job_title = '' THEN 'Unknown'
        ELSE TRIM(job_title) 
    END as job_title
FROM bronze.employees  ;

--=============================================================================================
--================================= job_title column cleaning =================================
--=============================================================================================
-- No department naming inconsistencies detected.
SELECT
     department ,
     COUNT(*) as department_count
FROM bronze.employees 
     GROUP BY department
     ORDER BY department_count DESC ;

-- Department Null Handling and Standardization
SELECT 
    CASE 
        WHEN department IS NULL OR department = '' THEN 'Unknown'
        ELSE TRIM(department)
    END as department
FROM bronze.employees ;

--=============================================================================================
--================================= department column cleaning ================================
--=============================================================================================
-- Store ID Data Validation
SELECT 
      store_id 
FROM  bronze.employees 
WHERE store_id IS NULL 
   OR store_id = ''
   OR TRY_CONVERT(INT, store_id) IS NULL ;

-- Store ID Distribution Analysis
SELECT 
      store_id ,
      COUNT(*) as store_id_count
FROM  bronze.employees 
GROUP BY store_id 
ORDER BY store_id_count DESC ;

-- Store ID Integer Conversion and Validation
SELECT 
    CASE 
        WHEN store_id < 0 OR TRY_CONVERT(INT, store_id) IS NULL THEN NULL
        ELSE TRY_CONVERT(INT, store_id) 
    END as store_id 
FROM bronze.employees ;

--=============================================================================================
--================================= store_name column cleaning ================================
--=============================================================================================

-- Store Name Data Validation
SELECT 
     store_name 
FROM bronze.employees 
WHERE store_name IS NULL 
   OR store_name = ''
   OR LEN(store_name) < 4
   OR TRIM(store_name) != store_name  ;

-- Store Name Distribution Analysis
SELECT 
    store_name,
    COUNT(*) as store_count,
    CAST(ROUND(COUNT(*) * 100/SUM(COUNT(*)) OVER(),2) AS NVARCHAR) + '%' as percentage 
FROM bronze.employees
    GROUP BY store_name
    ORDER BY store_count DESC ;

-- Store Name Cleaning and Standardization
SELECT
    CASE 
        WHEN store_name IS NULL OR store_name = '' THEN 'Unknown'
        ELSE TRIM(store_name)
    END as store_name
FROM bronze.employees ;

--=============================================================================================
--================================= store_city column cleaning ================================
--=============================================================================================
-- Store City Data Validation
SELECT 
     store_city
FROM bronze.employees 
WHERE store_city IS NULL 
   OR store_city = ''
   OR LEN(store_city) < 4 
   OR TRIM(store_city) != store_city ;

-- Store City Distribution Analysis
SELECT 
     store_city,
     COUNT(*) AS store_city_count,
     CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' as percentage 
FROM bronze.employees 
    GROUP BY store_city 
    ORDER BY store_city_count DESC ;

-- Store City Cleaning and Standardization
SELECT 
    CASE 
        WHEN store_city IS NULL OR LEN(store_city) < 4 OR store_city = '' THEN 'Unknown'
        ELSE TRIM(store_city)
    END store_city
FROM bronze.employees ;

--=============================================================================================
--================================= hire_date column cleaning =================================
--=============================================================================================

-- Employee Hire Date Overview
SELECT 
    hire_date 
FROM bronze.employees ;

-- Employee Hire Date Data Validation
SELECT
      hire_date 
FROM bronze.employees 
WHERE hire_date IS NULL 
    OR hire_date = ''
    OR TRIM(hire_date) != hire_date 
    OR LEN(hire_date) < 8 ;

-- Hire Date Pattern Analysis
WITH date_pattern AS 
(
    SELECT
        TRANSLATE(
            TRIM(LOWER(hire_date)),
            '0123456789abcdefghijklmnopqrstuvwxyz',
            '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
        ) AS pattern 
    FROM bronze.employees
)
SELECT 
    pattern,
    COUNT(*) AS pattern_count,
    CAST(
        ROUND(
            COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),
            2
        ) AS NVARCHAR
    ) + '%' AS percentage 
FROM date_pattern 
GROUP BY pattern
ORDER BY pattern_count DESC; 

-- Full Month Name Date Format Validation
SELECT 
    hire_date
FROM bronze.employees 
WHERE hire_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' ;

-- Full Month Name Date Conversion
SELECT 
    CASE 
        WHEN hire_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' 
        THEN TRY_CONVERT(DATE, hire_date)
    END AS hire_date
FROM bronze.employees 
WHERE hire_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' ;

-- Short Month Name Date Format Validation
SELECT 
    hire_date
FROM bronze.employees  
WHERE hire_date LIKE '[A-Z][a-z][a-z] __, ____' ;

-- Short Month Name Date Conversion
SELECT 
    CASE 
        WHEN hire_date LIKE '[A-Z][a-z][a-z] __, ____' 
        THEN TRY_CONVERT(DATE, hire_date)
    END AS hire_date
FROM bronze.employees  
WHERE hire_date LIKE '[A-Z][a-z][a-z] __, ____' ;

-- ISO Date Format Validation
SELECT 
    hire_date
FROM bronze.employees 
WHERE hire_date LIKE '____-__-__' ;

-- ISO Date Format Conversion
SELECT 
    CASE 
        WHEN hire_date LIKE '____-__-__' 
        THEN TRY_CONVERT(DATE, hire_date)
    END AS hire_date
FROM bronze.employees 
WHERE hire_date LIKE '____-__-__' ;

-- Slash-Separated ISO Date Format Validation
SELECT 
    hire_date
FROM bronze.employees 
WHERE hire_date LIKE '____/__/__' ;

-- Slash-Separated ISO Date Format Conversion
SELECT 
    CASE 
        WHEN hire_date LIKE '____/__/__' 
        THEN TRY_CONVERT(DATE, hire_date)
    END AS hire_date
FROM bronze.employees 
WHERE hire_date LIKE '____/__/__' ;

-- Slash-Separated DD/MM/YYYY Format Validation
SELECT 
    hire_date
FROM bronze.employees 
WHERE hire_date LIKE '__/__/____' ;

-- DD/MM/YYYY Date Conversion
SELECT 
    CASE 
        WHEN hire_date LIKE '__/__/____' 
         AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 
        THEN TRY_CONVERT(DATE, hire_date, 103)
    END AS hire_date
FROM bronze.employees 
WHERE hire_date LIKE '__/__/____' 
  AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 ;

-- MM/DD/YYYY Date Conversion
SELECT 
    CASE 
        WHEN hire_date LIKE '__/__/____' 
         AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 
        THEN TRY_CONVERT(DATE, hire_date, 101)
    END AS hire_date
FROM bronze.employees 
WHERE hire_date LIKE '__/__/____' 
  AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 ;

-- Hyphen-Separated DD-MM-YYYY Format Validation
SELECT 
    hire_date
FROM bronze.employees 
WHERE hire_date LIKE '__-__-____' ;

-- DD-MM-YYYY Date Conversion
SELECT 
    CASE 
        WHEN hire_date LIKE '__-__-____' 
         AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 
        THEN TRY_CONVERT(DATE, hire_date, 105)
    END AS hire_date
FROM bronze.employees 
WHERE hire_date LIKE '__-__-____' 
  AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 ;

-- MM-DD-YYYY Date Conversion
SELECT 
    CASE 
        WHEN hire_date LIKE '__-__-____' 
         AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 
        THEN TRY_CONVERT(DATE, hire_date, 110)
    END AS hire_date
FROM bronze.employees 
WHERE hire_date LIKE '__-__-____' 
  AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 ;

-- Final Hire Date Cleaning and Standardization Query
WITH clean_hire_date AS 
(
    SELECT 
        CASE 
            WHEN hire_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE, hire_date)
            WHEN hire_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE, hire_date)
            WHEN hire_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE, hire_date)
            WHEN hire_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE, hire_date)

            WHEN hire_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 THEN TRY_CONVERT(DATE, hire_date, 103)
            WHEN hire_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 THEN TRY_CONVERT(DATE, hire_date, 105)

            WHEN hire_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, hire_date, 101)
            WHEN hire_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, hire_date, 110)
            ELSE TRY_CONVERT(DATE, hire_date)
        END AS hire_date
    FROM bronze.employees 
)

SELECT 
    *
FROM clean_hire_date
WHERE hire_date LIKE '____-__-__' ;

--=============================================================================================
--============================= is_active column profiling ====================================
--=============================================================================================
-- Raw is_active data overview
SELECT 
     is_active
FROM bronze.employees ;

-- is_active data quality validation
SELECT 
      is_active
FROM  bronze.employees 
WHERE is_active IS NULL 
   OR is_active = ''
   OR is_active != TRIM(is_active) ;

-- is_active value distribution analysis
SELECT 
    is_active,
    COUNT(*) as is_active_count,
    CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentage 
FROM bronze.employees
GROUP BY is_active
ORDER BY is_active_count DESC ;

--== Standardizing is_active values into boolean format
WITH clean_is_active AS 
(
    SELECT 
        CASE
            WHEN TRIM(LOWER(is_active)) IN ('active', 'y', 'yes', '1', 'true')     THEN 'True'
            WHEN TRIM(LOWER(is_active)) IN ('terminated', 'n', 'no', '0', 'false') THEN 'False'
            ELSE NULL
        END AS is_active
    FROM bronze.employees
)
-- Standardized is_active distribution analysis
SELECT 
     is_active,
     COUNT(*) as is_active_count,
     CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' AS percentage 
FROM clean_is_active 
GROUP BY is_active
ORDER BY is_active_count ;

--=============================================================================================
--============================= performance_rating column cleaning ============================
--=============================================================================================
-- Raw performance_rating data overview
SELECT 
performance_rating
FROM bronze.employees

-- performance_rating data quality validation
SELECT 
      performance_rating
FROM  bronze.employees 
WHERE performance_rating IS NULL 
   OR performance_rating = ''
   OR performance_rating != TRIM(performance_rating) ;

-- performance_rating value distribution analysis
SELECT 
    performance_rating,
    COUNT(*) as performance_rating_count,
    CAST(ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentage 
FROM bronze.employees
GROUP BY performance_rating
ORDER BY performance_rating_count DESC ;

-- Standardizing performance_rating values
WITH clean_performance_rating AS
(
    SELECT
        CASE
            WHEN TRIM(LOWER(performance_rating)) IN ('excellent', 'a', '5')     THEN 'Excellent'
            WHEN TRIM(LOWER(performance_rating)) IN ('good', 'b', '4')          THEN 'Good'
            WHEN TRIM(LOWER(performance_rating)) IN ('average', 'c', '3')       THEN 'Average'
            WHEN TRIM(LOWER(performance_rating)) IN ('below average', 'd', '2') THEN 'Below Average'
            WHEN performance_rating IS NULL OR TRIM(performance_rating) = ''    THEN 'Unknown'
            ELSE 'Unknown'
        END AS performance_rating
    FROM bronze.employees
)
-- Standardized performance_rating distribution analysis
SELECT
    performance_rating,
    COUNT(*) AS performance_rating_count,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS NVARCHAR) + '%' AS percentage
FROM clean_performance_rating
GROUP BY performance_rating
ORDER BY performance_rating_count DESC ;

--=============================================================================================
--============================= annual_salary_usd column cleaning =============================
--=============================================================================================
-- annual_salary_usd data profiling
SELECT 
    annual_salary_usd
FROM bronze.employees
WHERE annual_salary_usd IS NULL 
   OR annual_salary_usd = ''
   OR TRY_CONVERT(DECIMAL(18,2), annual_salary_usd) IS NULL 
   OR TRY_CONVERT(DECIMAL(18,2), annual_salary_usd) < 0 ;

-- Final annual_salary_usd Cleaning and Standardization Query
WITH salary_analysis AS 
(
SELECT 
    CASE 
        WHEN annual_salary_usd IS NULL 
        OR TRY_CONVERT(DECIMAL(18,2), annual_salary_usd) IS NULL 
        OR TRY_CONVERT(DECIMAL(18,2), annual_salary_usd) < 0 THEN NULL
        ELSE TRY_CONVERT(DECIMAL(18,2), annual_salary_usd)
    END AS annual_salary_usd
FROM bronze.employees 
)
SELECT 
    annual_salary_usd
FROM salary_analysis
WHERE annual_salary_usd IS NULL ;
--=============================================================================================
--================================= manager_id column cleaning ================================
--=============================================================================================
-- employee manager_id data profiling 
SELECT 
    manager_id
FROM bronze.employees 
WHERE manager_id IS NULL 
   OR manager_id = ''
   OR TRY_CONVERT(INT, manager_id) IS NULL 
   OR manager_id < 0 ;

-- manager_id value distribution analysis
SELECT 
    manager_id ,
    COUNT(*) manager_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) as percentage 
FROM bronze.employees 
    GROUP BY manager_id 
    ORDER BY manager_count DESC ;

-- Final manager_id Cleaning and Standardization Query
SELECT 
    CASE 
        WHEN TRY_CONVERT(INT ,manager_id) IS NULL THEN NULL 
        ELSE manager_id 
    END as manager_id
FROM bronze.employees 

--=============================================================================================
--============================= commission_rate_pct column cleaning ===========================
--=============================================================================================
-- commission_rate_pct data profiling
SELECT 
    commission_rate_pct
FROM bronze.employees
WHERE commission_rate_pct IS NULL 
   OR commission_rate_pct = ''
   OR TRY_CONVERT(DECIMAL(4,2), commission_rate_pct) IS NULL 
   OR TRY_CONVERT(DECIMAL(4,2), commission_rate_pct) < 0 ;

-- Final commission_rate_pct Cleaning and Standardization Query
WITH commission_analysis AS 
(
    SELECT 
        CASE 
            WHEN commission_rate_pct IS NULL 
            OR TRY_CONVERT(DECIMAL(4,2), commission_rate_pct) IS NULL 
            OR TRY_CONVERT(DECIMAL(4,2), commission_rate_pct) < 0 THEN NULL
            ELSE TRY_CONVERT(DECIMAL(4,2), commission_rate_pct)
        END AS commission_rate_pct
    FROM bronze.employees 
)
SELECT 
    commission_rate_pct
FROM commission_analysis
WHERE commission_rate_pct IS NULL ;

--=============================================================================================
--================================== years_employed column cleaning ===========================
--=============================================================================================
-- years_employed  data profiling 
SELECT 
       years_employed 
FROM   bronze.employees 
WHERE  years_employed IS NULL 
    OR years_employed < 0
    OR TRY_CONVERT(DECIMAL(4, 2), years_employed) IS NULL ;

-- Final years_employed Cleaning and Standardization Query
WITH clean_years_employed AS 
(
    SELECT 
        CASE 
            WHEN years_employed IS NULL 
            OR TRY_CONVERT(DECIMAL(4,2), years_employed) IS NULL 
            OR TRY_CONVERT(DECIMAL(4,2), years_employed) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(4,2), TRY_CONVERT(DECIMAL(4,2), years_employed))
        END years_employed
    FROM bronze.employees 
)
SELECT 
    *
FROM clean_years_employed 
WHERE years_employed IS NULL ;

--=============================================================================================
--================================== email column cleaning ====================================
--=============================================================================================
-- employees email data overvew 
SELECT 
    email 
FROM bronze.employees ;

-- employees email data profiling 
SELECT 
      email 
FROM  bronze.employees 
WHERE email IS NULL 
   OR email = '' ;

-- employees email value distribution analysis
SELECT 
    email ,
    COUNT(*) as email_count 
FROM bronze.employees
    GROUP BY email 
    HAVING COUNT(*) > 1 ;


-- checking those email they contain mere then one '@'
SELECT 
    email 
FROM bronze.employees 
WHERE PATINDEX('%@%@%', email) > 0 ;

-- checking those email they contain more then one '.'
SELECT 
    email 
FROM bronze.employees 
WHERE PATINDEX('%.%.%', email) > 0 ;

-- check email where '@' are messing 
SELECT 
    email 
FROM bronze.employees 
WHERE email NOT LIKE '%@%' ;

-- checking email whre suer_name are messing 
SELECT 
    email 
FROM bronze.employees 
WHERE email LIKE '@%' ;

-- checking email whre domain are messing 
SELECT 
    email 
FROM bronze.employees 
WHERE email LIKE '%@' ;
 
-- check email where dot are messing 
SELECT 
    email
FROM bronze.employees
WHERE email NOT LIKE '%.__%' ;

--checking those email they contain empty space 
SELECT 
email
FROM bronze.employees 
WHERE email LIKE '% %' ;

-- checking user name 
SELECT 
    LEFT(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) -1)
FROM bronze.employees ;

-- checking employee email domain

WITH email_check AS 
(
    SELECT 
        SUBSTRING(email, CHARINDEX('@', email)+1, LEN(email)) as domain 
    FROM bronze.employees
)
SELECT 
    domain,
    COUNT(*) as domain_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)AS NVARCHAR) + '%' as percentage 
FROM email_check
    GROUP BY domain
    ORDER BY domain_count DESC;

-- employee domain check 
WITH email_domain AS 
(
    SELECT 
        CASE 
            WHEN email IS NULL OR TRIM(email) = '' THEN 'Unknown'
            WHEN email NOT LIKE '%@%' THEN 'Unknown'
            WHEN PATINDEX('%@%@%', TRIM(LOWER(email))) > 0 THEN 
            LEFT(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) -1)
            + '@' + REPLACE(SUBSTRING(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) +1,
            LEN(TRIM(LOWER(email)))), '@' ,'')
            ELSE TRIM(LOWER(email))
        END as email
    FROM bronze.employees
),
domain_analysis AS 
(
    SELECT
        SUBSTRING(email, CHARINDEX('@', email) + 1 , LEN(email)) as domain 
    FROM email_domain
)
SELECT 
    domain ,
    COUNT(*) as domain_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as nvarchar) + '%' as percentage 
FROM domain_analysis
    GROUP BY domain
    ORDER BY domain_count DESC;

-- Final email Cleaning and Standardization Query
SELECT
    CASE 
        WHEN email IS NULL OR TRIM(email) = '' THEN 'Unknown'
        WHEN email NOT LIKE '%@%' THEN 'Unknown'
        WHEN PATINDEX('%@%@%', TRIM(LOWER(email))) > 0 THEN 
        LEFT(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) -1)
        + '@' + REPLACE(SUBSTRING(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) +1,
        LEN(TRIM(LOWER(email)))), '@' ,'')
        ELSE TRIM(LOWER(email))
    END as email
FROM bronze.employees
WHERE PATINDEX('%@%@%', TRIM(LOWER(email))) > 0 


--#############################################################################################
--############################## EMPLOYEE CLEAN DATA ##########################################
--#############################################################################################

SELECT
       [employee_id]

    ,CASE 
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), ' ','')) = 1 THEN PARSENAME(REPLACE(TRIM(full_name), ' ', '.'), 2)
    END as first_name,

        PARSENAME(REPLACE(TRIM(full_name),' ','.'),1) as last_name

    ,CASE 
        WHEN email IS NULL OR TRIM(email) = '' THEN 'Unknown'
        WHEN email NOT LIKE '%@%' THEN 'Unknown'
        WHEN PATINDEX('%@%@%', TRIM(LOWER(email))) > 0 THEN 
        LEFT(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) -1)
        + '@' + REPLACE(SUBSTRING(TRIM(LOWER(email)), CHARINDEX('@', TRIM(LOWER(email))) +1,
        LEN(TRIM(LOWER(email)))), '@' ,'')
        ELSE TRIM(LOWER(email))
    END as email

    ,CASE 
        WHEN phone LIKE '+___________'   THEN  CONCAT('+1 (', SUBSTRING(phone, 3, 3), ') ',  SUBSTRING(phone, 6, 3), '-', SUBSTRING(phone, 9,4))
        WHEN phone LIKE '___.___.____'   THEN  CONCAT('+1 (', SUBSTRING(phone, 1,3), ') ' ,  SUBSTRING(phone,5, 3), '-',  SUBSTRING(phone,9,4))
        WHEN phone LIKE '__________'     THEN  CONCAT('+1 (', SUBSTRING(phone, 1,3), ') ' ,  SUBSTRING(phone, 4,3), '-',  SUBSTRING(phone,7,4))
        WHEN phone LIKE '___-___-____'   THEN  CONCAT('+1 (', SUBSTRING(phone,1, 3), ') ' ,  SUBSTRING(phone, 5,8))
        WHEN phone LIKE '(___) ___-____' THEN  CONCAT('+1 ',  SUBSTRING(phone, 1,14))
    END as phone

    ,CASE 
        WHEN job_title IS NULL OR job_title = '' THEN 'Unknown'
        ELSE TRIM(job_title) 
    END as job_title

    ,CASE 
        WHEN department IS NULL OR department = '' THEN 'Unknown'
        ELSE TRIM(department)
    END as department

    ,CASE 
        WHEN store_id < 0 OR TRY_CONVERT(INT, store_id) IS NULL THEN NULL
        ELSE TRY_CONVERT(INT, store_id) 
    END as store_id 

    ,CASE 
        WHEN store_name IS NULL OR store_name = '' THEN 'Unknown'
        ELSE TRIM(store_name)
    END as store_name

    ,CASE 
        WHEN store_city IS NULL OR LEN(store_city) < 4 OR store_city = '' THEN 'Unknown'
        ELSE TRIM(store_city)
    END store_city

    ,CASE 
        WHEN hire_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE,hire_date )
        WHEN hire_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE, hire_date)
        WHEN hire_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE, hire_date)
        WHEN hire_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE, hire_date)

        WHEN hire_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 THEN  TRY_CONVERT(DATE, hire_date,103)
        WHEN hire_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(hire_date, 2)) > 12 THEN TRY_CONVERT(DATE, hire_date, 105)
        
        WHEN hire_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 THEN  TRY_CONVERT(DATE, hire_date,101)
        WHEN hire_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(hire_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, hire_date, 110)
        ELSE TRY_CONVERT(DATE, hire_date)
    END hire_date

    ,CASE 
        WHEN years_employed IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), years_employed) IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), years_employed) < 0 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(4,2), TRY_CONVERT(DECIMAL(4,2), years_employed))
    END years_employed

    ,CASE 
        WHEN annual_salary_usd IS NULL 
        OR TRY_CONVERT(DECIMAL(18,2), annual_salary_usd) IS NULL 
        OR TRY_CONVERT(DECIMAL(18,2), annual_salary_usd) < 0 THEN NULL
        ELSE TRY_CONVERT(DECIMAL(18,2), annual_salary_usd)
    END AS annual_salary_usd

    ,CASE 
        WHEN commission_rate_pct IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), commission_rate_pct) IS NULL 
        OR TRY_CONVERT(DECIMAL(4,2), commission_rate_pct) < 0 THEN NULL
        ELSE TRY_CONVERT(DECIMAL(4,2), commission_rate_pct)
    END AS commission_rate_pct

    ,CASE
        WHEN TRIM(LOWER(is_active)) IN ('active', 'y', 'yes', '1', 'true')     THEN 'True'
        WHEN TRIM(LOWER(is_active)) IN ('terminated', 'n', 'no', '0', 'false') THEN 'False'
        ELSE NULL
    END AS is_active

    ,CASE
        WHEN TRIM(LOWER(performance_rating)) IN ('excellent', 'a', '5')     THEN 'Excellent'
        WHEN TRIM(LOWER(performance_rating)) IN ('good', 'b', '4')          THEN 'Good'
        WHEN TRIM(LOWER(performance_rating)) IN ('average', 'c', '3')       THEN 'Average'
        WHEN TRIM(LOWER(performance_rating)) IN ('below average', 'd', '2') THEN 'Below Average'
        WHEN performance_rating IS NULL OR TRIM(performance_rating) = ''    THEN 'Unknown'
        ELSE 'Unknown'
    END AS performance_rating

    ,CASE 
        WHEN TRY_CONVERT(INT ,manager_id) IS NULL THEN NULL 
        ELSE manager_id 
    END as manager_id

  FROM [TestDB].[bronze].[employees]