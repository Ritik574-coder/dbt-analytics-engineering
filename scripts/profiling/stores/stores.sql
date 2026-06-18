--#############################################################################################
--#################################### STORES DATA ############################################
--#############################################################################################

--=============================================================================================
--================================== stores table overview ====================================
--=============================================================================================

SELECT 
       [store_id]
      ,[store_name]
      ,[store_type]
      ,[address]
      ,[city]
      ,[state]
      ,[state_full]
      ,[zip_code]
      ,[country]
      ,[region]
      ,[district]
      ,[phone]
      ,[manager_name]
      ,[opened_date]
      ,[sq_footage]
      ,[num_employees]
      ,[annual_rent_usd]
      ,[is_active]
      ,[has_parking]
      ,[has_cafe]
FROM [bronze].[stores]

--=============================================================================================
--================================== store_id column cleaning =================================
--=============================================================================================
-- store_id data overview 
SELECT 
store_id 
FROM bronze.stores ;

-- store_id data type check 
SELECT 
    store_id 
FROM bronze.stores 
WHERE TRY_CONVERT(INT, store_id) IS NULL ; 

-- store_id data profiling 
SELECT 
      store_id 
FROM  bronze.stores 
WHERE store_id IS NULL 
   OR store_id < 1 ;

-- store_id duplicate chck 
SELECT 
    *
FROM 
(
    SELECT 
        store_id,
        ROW_NUMBER() OVER(PARTITION BY store_id ORDER BY store_id DESC) as flag 
    FROM bronze.stores 
)t WHERE flag != 1 ; 

--=============================================================================================
--================================== store_name column cleaning ===============================
--=============================================================================================
-- store_name data overview 
SELECT 
    store_name
FROM bronze.stores ;

-- store_name data profiling 
SELECT 
      store_name 
FROM  bronze.stores 
WHERE store_name IS NULL
   OR store_name != store_name
   OR store_name != dbo.TitleCase(store_name)
   OR TRIM(store_name) = ''
   OR LEN(TRIM(store_name)) < 3 ; 

-- duplicate check in store_name 
SELECT 
    *
FROM 
(
    SELECT 
        store_name,
        ROW_NUMBER() OVER(PARTITION BY store_name ORDER BY store_name DESC) as flag 
    FROM bronze.stores 
)t WHERE flag != 1 ; 

-- store_name cleaning and standardization
WITH clean_store_name AS 
(
    SELECT 
        CASE 
            WHEN store_name IS NULL OR LEN(TRIM(store_name)) < 3 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(store_name))
        END as store_name
    FROM bronze.stores 
)
SELECT
    *
FROM clean_store_name 
WHERE store_name = 'Unknown'; 

--=============================================================================================
--================================== store_type column cleaning ===============================
--=============================================================================================
-- store_type data overview 
SELECT 
    store_type 
FROM bronze.stores ;

-- store_type data profiling 
SELECT 
      store_type 
FROM  bronze.stores 
WHERE store_type IS NULL 
   OR store_type != store_type
   OR store_type != dbo.TitleCase(store_type)
   OR TRIM(store_type) = ''
   OR LEN(TRIM(store_type)) < 3 ; 

-- store type count 
SELECT 
    store_type ,
    COUNT(*) type_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM bronze.stores 
    GROUP BY store_type 
    ORDER BY type_count DESC ; 

-- store_type cleaning and standardization
WITH clean_store_type AS 
(
    SELECT 
        CASE 
            WHEN store_type IS NULL OR LEN(TRIM(store_type)) < 3 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(store_type))
        END as store_type
    FROM bronze.stores 
)
SELECT
    *
FROM clean_store_type 
WHERE store_type = 'Unknown'; 

--=============================================================================================
--================================== address column cleaning ==================================
--=============================================================================================
-- address data overview 
SELECT 
    address 
FROM bronze.stores ;

-- address column data profiling 
SELECT 
      address 
FROM  bronze.stores 
WHERE address IS NULL 
   OR address != TRIM(address)
   OR address != TRIM(dbo.TitleCase(address))
   OR TRIM(address) = ''
   OR LEN(address) < 5 ;

-- address cleaning and standardization
WITH clean_address AS 
(
    SELECT 
        CASE 
            WHEN address IS NULL OR TRIM(address) = '' OR LEN(address) < 5 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(address))
        END address
    FROM bronze.stores 
)
SELECT 
    *
FROM clean_address 
WHERE address = 'Unknown' ;

--=============================================================================================
--===================================== city column cleaning ==================================
--=============================================================================================
-- city column data overview 
SELECT 
    city
FROM bronze.stores ;

-- city column data profiling 
SELECT 
      city
FROM  bronze.stores 
WHERE city IS NULL 
   OR TRIM(city) = ''
   OR TRIM(dbo.TitleCase(city)) != city 
   OR TRIM(city) != city
   OR LEN(TRIM(city)) < 3 ;

-- city column data Distribution Analysis
SELECT 
    city ,
    COUNT(*) city_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM bronze.stores 
    GROUP BY city 
    ORDER BY city_count DESC ; 

-- city column cleaning and standardization
WITH clean_city AS 
(
    SELECT 
        CASE 
            WHEN city IS NULL OR TRIM(city) = '' OR LEN(TRIM(city)) < 3 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(city))
        END as city 
    FROM bronze.stores 
) 
SELECT 
    city 
FROM clean_city 
WHERE city = 'Unknown' ;

--=============================================================================================
--===================================== state column cleaning =================================
--=============================================================================================
-- state column data overview 
SELECT 
    state
FROM bronze.stores;

-- state column data profiling 
SELECT 
      [state],
      state_full,
      city
FROM  bronze.stores 
WHERE [state] IS NULL 
   OR TRIM([state]) != [state] 
   OR TRIM(dbo.TitleCase([state])) != [state]
   OR TRIM([state]) = ''
   OR LEN(TRIM([state])) < 4 ;

-- state column data profiling 
SELECT DISTINCT 
      [state]
FROM  bronze.stores 
WHERE [state] IS NULL 
   OR LEN(TRIM([state])) > 4 ;

-- state cleaning and standardization
WITH clean_state_abbr AS 
(
    SELECT 
        CASE 
            WHEN TRIM(state) = 'California'  THEN 'CA'
            WHEN TRIM(state) = 'Texas'       THEN 'TX'
            WHEN TRIM(state) = 'Arizona'     THEN 'AZ'
            WHEN TRIM(state) = 'Colorado'    THEN 'CO'
            WHEN TRIM(state) = 'Maryland'    THEN 'MD'
            WHEN TRIM(state) = 'Wisconsin'   THEN 'WI'
            WHEN TRIM(state) = 'Illinois'    THEN 'IL'
            WHEN TRIM(state) = 'Georgia'     THEN 'GA'
            WHEN TRIM(state) = 'Tennessee'   THEN 'TN'
            WHEN TRIM(state) = 'New Mexico'  THEN 'NM'
            WHEN TRIM(state) = 'Ohio'        THEN 'OH'
            WHEN state IS NULL OR TRIM(state) = '' OR LEN(TRIM(state))  < 2 THEN 'Unknown'
            ELSE state
        END AS state
    FROM bronze.stores
)
SELECT 
    state
FROM clean_state_abbr
WHERE state = 'Unkonwn' ;
--=============================================================================================
--===================================== state_full column cleaning ============================
--=============================================================================================
-- state_full column data overview 
SELECT 
    state_full
FROM bronze.stores;

-- state_full column data profiling
SELECT 
      state_full
FROM  bronze.stores 
WHERE state_full IS NULL 
   OR TRIM(state_full) != state_full
   OR TRIM(dbo.TitleCase(state_full)) != state_full
   OR TRIM(state_full) = ''
   OR LEN(TRIM(state_full)) < 4 ;

-- state_full column data Distribution Analysis
SELECT 
    state_full ,
    COUNT(*) state_full_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM bronze.stores 
    GROUP BY state_full 
    ORDER BY state_full_count DESC ;

-- state_full column cleaning and standardization
WITH clean_state_full AS 
(
    SELECT 
        CASE 
            WHEN state_full IS NULL OR TRIM(state_full) = '' OR LEN(TRIM(state_full)) < 4 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(state_full))
        END as state_full
    FROM bronze.stores 
)
SELECT 
    state_full ,
    COUNT(*) state_full_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM clean_state_full
    GROUP BY state_full 
    ORDER BY state_full_count DESC ;
--=============================================================================================
--===================================== zip_code column cleaning ==============================
--=============================================================================================
-- zip_code column data overview 
SELECT 
    zip_code
FROM bronze.stores;

-- zip_code column data profiling
SELECT 
      zip_code
FROM  bronze.stores 
WHERE zip_code IS NULL 
   OR TRY_CONVERT(INT, zip_code) IS NULL 
   OR LEN(zip_code) < 5 ;

-- zip_code column data Distribution Analysis
SELECT 
    zip_code ,
    COUNT(*) zip_code_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM bronze.stores 
    GROUP BY zip_code
    ORDER BY zip_code_count DESC ; 

-- zip_code column cleaning and standardization
WITH clean_zip_code AS 
(
    SELECT 
        CASE 
            WHEN zip_code IS NULL OR TRY_CONVERT(INT, zip_code) IS NULL OR LEN(zip_code) < 5 THEN NULL 
            ELSE TRY_CONVERT(INT, zip_code)
        END as zip_code
    FROM bronze.stores 
)
SELECT
    *
FROM clean_zip_code 
WHERE zip_code IS NULL ;

--=============================================================================================
--=================================== country column cleaning =================================
--=============================================================================================
-- country column data overview 
SELECT 
    country
FROM bronze.stores;

-- country column data profiling 
SELECT 
      country
FROM  bronze.stores 
WHERE country IS NULL 
   OR TRIM(country) = ''
   OR TRIM(dbo.TitleCase(country)) != country 
   OR TRIM(country) != country
   OR LEN(TRIM(country)) < 2 ;

-- country column data Distribution Analysis
SELECT 
    country ,
    COUNT(*) country_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM bronze.stores 
    GROUP BY country 
    ORDER BY country_count DESC ; 

-- country column cleaning and standardization
WITH clean_country AS 
(
    SELECT 
        CASE 
            WHEN TRIM(LOWER(country)) IN ('us', 'usa', 'united states', 'u.s.a', 'u.s') THEN 'United States'
            WHEN country IS NULL OR TRIM(country) = '' OR LEN(TRIM(country)) < 2        THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(country))
        END as country 
    FROM bronze.stores 
)  
SELECT 
    country ,
    COUNT(*) country_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM clean_country
    GROUP BY country 
    ORDER BY country_count DESC ; 
  
--=============================================================================================
--===================================== region column cleaning ================================
--=============================================================================================
-- region column data overview 
SELECT 
    region
FROM bronze.stores;

-- region column data profiling 
SELECT 
      region
FROM  bronze.stores 
WHERE region IS NULL 
   OR region != TRIM(region)
   OR TRIM(region) = ''
   OR LEN(TRIM(region)) < 2 ;

-- region column data Distribution Analysis 
SELECT 
    TRIM(dbo.TitleCase(region)) as region ,
    COUNT(*) as region_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages 
FROM bronze.stores 
    GROUP BY TRIM(dbo.TitleCase(region))
    ORDER BY region_count DESC ;

-- region column cleaning and standardization
WITH clean_region AS 
(
    SELECT 
        CASE 
            WHEN region IS NULL OR TRIM(region) = '' OR LEN(TRIM(region)) < 2 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(region))
        END as region
    FROM bronze.stores 
)
SELECT 
    region ,
    COUNT(*) as region_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages 
FROM clean_region
    GROUP BY region 
    ORDER BY region_count DESC ;
    
--=============================================================================================
--===================================== district column cleaning ==============================
--=============================================================================================
-- district column data overview 
SELECT 
    district
FROM bronze.stores;
    
-- district column data profiling
SELECT 
      district
FROM  bronze.stores 
WHERE district IS NULL 
   OR district != TRIM(district)
   OR TRIM(district) = ''
   OR LEN(TRIM(district)) < 2 ; 

-- district column data Distribution Analysis
SELECT 
    TRIM(dbo.TitleCase(district)) as district ,
    COUNT(*) as district_count, 
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages
FROM bronze.stores 
    GROUP BY TRIM(dbo.TitleCase(district))
    ORDER BY district_count DESC ;

-- district column cleaning and standardization
WITH clean_district AS 
(
    SELECT 
        CASE 
            WHEN district IS NULL OR TRIM(district) = '' OR LEN(TRIM(district)) < 2 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(district))
        END as district
    FROM bronze.stores 
)
SELECT 
    district ,
    COUNT(*) as district_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages 
FROM clean_district
    GROUP BY district 
    ORDER BY district_count DESC ;

--=============================================================================================
--===================================== phone column cleaning =================================
--=============================================================================================
-- phone column data overview 
SELECT 
    phone
FROM bronze.stores;

-- Phone Structure Validation 
WITH clean_phone AS 
(
    SELECT
        TRANSLATE(
            phone,
            '0123456789',
            '9999999999'
        ) as phone
    FROM bronze.stores 
)
SELECT 
      phone,
      LEN(phone) as lengthas,
      COUNT(*) as count,
      CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() , 2)as nvarchar) + '%' as percentage
FROM clean_phone
      GROUP BY phone
      ORDER BY count DESC;

-- '(___) ___-____' pattern analysis 
SELECT 
    phone ,
    CONCAT('+1 ', SUBSTRING(phone, 1, 14)) as phone
FROM bronze.stores 
WHERE phone LIKE '(___) ___-____';

-- '+___________' pattern analysis 
SELECT 
    phone ,
    CONCAT('+1 (', SUBSTRING(phone, 3, 3), ') ', SUBSTRING(phone, 6, 3),'-', SUBSTRING(phone, 9,4))
FROM bronze.stores 
WHERE phone LIKE '+___________';

-- '___-___-____' pattern analysis 
SELECT 
    phone ,
    CONCAT('+1 (', SUBSTRING(phone, 1, 3), ') ', SUBSTRING(phone, 5, 8))
FROM bronze.stores 
WHERE phone LIKE '___-___-____';

-- '___.___.____' pattern analysis 
SELECT 
    phone ,
    CONCAT('+1 (', SUBSTRING(phone, 1, 3), ') ', SUBSTRING(phone, 5, 3), '-', SUBSTRING(phone, 9, 4))
FROM bronze.stores 
WHERE phone LIKE '___.___.____';

-- '__________' pattern analysis 
SELECT 
    phone ,
    CONCAT('+1 (', SUBSTRING(phone, 1, 3), ') ', SUBSTRING(phone, 4, 3), '-', SUBSTRING(phone, 7, 4))
FROM bronze.stores 
WHERE phone LIKE '__________';

-- phone column cleaning and standardization - pattern analysis after cleaning
WITH clean_phone AS 
(
    SELECT 
        CASE 
            WHEN TRIM(phone) LIKE '(___) ___-____' THEN CONCAT('+1 ',  SUBSTRING(TRIM(phone), 1, 14))
            WHEN TRIM(phone) LIKE '+___________'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 3, 3), ') ', SUBSTRING(TRIM(phone), 6, 3),'-',  SUBSTRING(TRIM(phone), 9,4))
            WHEN TRIM(phone) LIKE '___-___-____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 8))
            WHEN TRIM(phone) LIKE '___.___.____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3), '-', SUBSTRING(TRIM(phone), 9, 4))
            WHEN TRIM(phone) LIKE '__________'     THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 4, 3), '-', SUBSTRING(TRIM(phone), 7, 4))
            ELSE TRIM(phone)
        END as phone
    FROM bronze.stores 
)
SELECT
    TRANSLATE(
        phone,
        '0123456789',
        '9999999999'
    ) as phone,
      cOUNT(*) as count,
      CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() , 2)as nvarchar) + '%' as percentages
FROM clean_phone  
GROUP BY 
    TRANSLATE(
        phone,
        '0123456789',
        '9999999999'
    )
ORDER BY count DESC ;
--=============================================================================================
--================================= manager_name column cleaning ==============================
--=============================================================================================
-- manager_name column data overview 
SELECT 
    manager_name
FROM bronze.stores;

-- manager_name column data profiling
SELECT 
      manager_name
FROM  bronze.stores 
WHERE manager_name IS NULL 
   OR manager_name != TRIM(manager_name)
   OR TRIM(manager_name) = ''
   OR LEN(TRIM(manager_name)) < 3 ;

-- manager_name column cleaning and standardization
WITH clean_manager_name AS 
(
    SELECT 
        CASE 
            WHEN manager_name IS NULL OR TRIM(manager_name) = '' OR LEN(TRIM(manager_name)) < 2 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(manager_name))
        END as manager_name
    FROM bronze.stores 
)
SELECT 
    manager_name
FROM clean_manager_name
WHERE manager_name = 'Unknown' ;

--=============================================================================================
--===================================== opened_date column cleaning ===========================
--=============================================================================================
-- opened_date column data overview 
SELECT 
    opened_date
FROM bronze.stores;

-- opened_date Structure Validation
WITH opened_date_analysis AS 
(
      SELECT
            TRANSLATE(
                  TRIM(LOWER(opened_date)),
                  '0123456789abcdefghijklmnopqrstuvwxyz',
                  '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
            ) as opened_date_pattern
      FROM bronze.stores
)
SELECT 
      opened_date_pattern,
      COUNT(*) as count,
      CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() , 2)as nvarchar) + '%' as percentage
FROM opened_date_analysis
      GROUP BY opened_date_pattern
      ORDER BY count DESC;

-- opened_date cleaning and standardization
WITH opened_date_date AS 
(
    SELECT 
        CASE 
            WHEN opened_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,opened_date)
        
            WHEN opened_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(opened_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, opened_date, 101)
            WHEN opened_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(opened_date, 2))         > 12 THEN TRY_CONVERT(DATE, opened_date, 103)
            WHEN opened_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(opened_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, opened_date, 110)
            WHEN opened_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(opened_date, 2))         > 12 THEN TRY_CONVERT(DATE, opened_date, 105)
            ELSE TRY_CONVERT(DATE, opened_date)
        END as opened_date
    FROM bronze.stores
)
SELECT 
    opened_date
FROM opened_date_date
WHERE  TRY_CONVERT(DATE, opened_date) IS NULL
    OR TRY_CONVERT(DATE, opened_date) > GETDATE() ;


-- opened_date column cleaning and standardization - pattern analysis after cleaning
WITH opened_date_date AS 
(
    SELECT 
        CASE 
            WHEN opened_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,opened_date)
        
            WHEN opened_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(opened_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, opened_date, 101)
            WHEN opened_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(opened_date, 2))         > 12 THEN TRY_CONVERT(DATE, opened_date, 103)
            WHEN opened_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(opened_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, opened_date, 110)
            WHEN opened_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(opened_date, 2))         > 12 THEN TRY_CONVERT(DATE, opened_date, 105)
            ELSE TRY_CONVERT(DATE, opened_date)
        END as opened_date
    FROM bronze.stores
)
SELECT
      TRANSLATE(
            TRIM(LOWER(opened_date)),
            '0123456789abcdefghijklmnopqrstuvwxyz',
            '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
      ) as opened_date_pattern,
      cOUNT(*) as count,
      CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() , 2)as nvarchar) + '%' as percentage
FROM opened_date_date 
GROUP BY 
      TRANSLATE(
            TRIM(LOWER(opened_date)),
            '0123456789abcdefghijklmnopqrstuvwxyz',
            '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
      )
ORDER BY count DESC ;

--=============================================================================================
--=================================== sq_footage column cleaning ==============================
--=============================================================================================
-- sq_footage column data overview 
SELECT 
    sq_footage
FROM bronze.stores;

-- sq_footage column data profiling
SELECT 
      sq_footage
FROM  bronze.stores 
WHERE sq_footage IS NULL 
   OR sq_footage < 0 ;

-- sq_footage column cleaning and standardization
WITH clean_sq_footage AS 
(
    SELECT 
        CASE 
            WHEN sq_footage IS NULL OR sq_footage < 0 THEN NULL
            ELSE TRY_CONVERT(INT, sq_footage)
        END as sq_footage
    FROM bronze.stores 
)
SELECT 
    sq_footage
FROM clean_sq_footage
WHERE sq_footage IS NULL ;

--=============================================================================================
--===================================== num_employees column cleaning =========================
--=============================================================================================
-- num_employees column data overview 
SELECT 
    num_employees
FROM bronze.stores;

-- num_employees column data profiling
SELECT 
      num_employees
FROM  bronze.stores 
WHERE num_employees IS NULL 
   OR num_employees < 0 ;

-- num_employees column cleaning and standardization
WITH clean_num_employees AS 
(
    SELECT 
        CASE 
            WHEN num_employees IS NULL OR num_employees < 0 THEN NULL
            ELSE TRY_CONVERT(INT, num_employees)
        END as num_employees
    FROM bronze.stores 
)
SELECT 
    num_employees
FROM clean_num_employees
WHERE num_employees IS NULL ;

--=============================================================================================
--================================== annual_rent_usd column cleaning ==========================
--=============================================================================================
-- annual_rent_usd column data overview 
SELECT 
    annual_rent_usd
FROM bronze.stores;

-- annual_rent_usd data type check 
SELECT 
      annual_rent_usd 
FROM  bronze.stores 
WHERE annual_rent_usd IS NULL 
   OR annual_rent_usd < 1 ;

-- annual_rent_usd column cleaning and standardization 
WITH clean_annual_rent_usd  AS 
(
    SELECT 
        CASE 
            WHEN annual_rent_usd < 1 OR annual_rent_usd  IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, annual_rent_usd)
        END as annual_rent_usd 
    FROM bronze.stores 
)
SELECT 
    annual_rent_usd  
FROM clean_annual_rent_usd 
WHERE annual_rent_usd  IS NULL ;

--=============================================================================================
--=================================== is_active column cleaning ===============================
--=============================================================================================
-- is_active column data overview 
SELECT 
    is_active
FROM bronze.stores ;

-- is_active column data profiling 
SELECT 
      is_active
FROM  bronze.stores 
WHERE is_active IS NULL 
   OR is_active != TRIM(is_active)
   OR TRIM(is_active) = ''
   OR LEN(TRIM(is_active)) < 2 ;

-- is_active column data Distribution Analysis 
SELECT 
    is_active ,
    COUNT(*) as is_active_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages 
FROM bronze.stores 
    GROUP BY is_active 
    ORDER BY is_active_count DESC ;

-- is_active column cleaning and standardization
WITH clean_is_active AS 
(
    SELECT 
        CASE 
            WHEN TRIM(LOWER(is_active)) IN ('true', 'yes', 'y', '1', 'active')     THEN 'True'
            WHEN TRIM(LOWER(is_active)) IN ('false', 'no', 'n', '0', 'not active') THEN 'False'
        ELSE 'Unknown'
    END as is_active
    FROM bronze.stores 
)
SELECT 
    is_active ,
    COUNT(*) as is_active_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages 
FROM clean_is_active
    GROUP BY is_active
    ORDER BY is_active_count DESC ;

--=============================================================================================
--=================================== has_parking column cleaning =============================
--=============================================================================================
-- has_parking column data overview
SELECT
    has_parking 
FROM bronze.stores ;

-- has_parking data profiling 
SELECT 
      has_parking 
FROM  bronze.stores 
WHERE has_parking IS NULL 
   OR has_parking != TRIM(has_parking)
   OR TRIM(has_parking) = ''
   OR LEN(TRIM(has_parking)) < 2 ;

-- has_parking column data Distribution Analysis 
SELECT 
    has_parking ,
    COUNT(*) as has_parking_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages 
FROM bronze.stores 
    GROUP BY has_parking 
    ORDER BY has_parking_count DESC ;

-- has_parking column cleaning and standardization
WITH clean_has_parking AS 
(
    SELECT 
        CASE 
            WHEN TRIM(LOWER(has_parking)) IN ('true', 'yes', 'y', '1') THEN 'True'
            WHEN TRIM(LOWER(has_parking)) IN ('false', 'no', 'n', '0') THEN 'False'
        ELSE 'Unknown'
    END as has_parking
    FROM bronze.stores 
)
SELECT 
    has_parking ,
    COUNT(*) as has_parking_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2) as NVARCHAR) + '%' as percentages 
FROM clean_has_parking
    GROUP BY has_parking 
    ORDER BY has_parking_count DESC ;

--=============================================================================================
--=================================== has_cafe column cleaning ================================
--=============================================================================================
-- has_cafe column data oveview 
SELECT 
    has_cafe
FROM bronze.stores ;

-- has_cafe column data profiling 
SELECT 
      has_cafe
FROM  bronze.stores 
WHERE has_cafe IS NULL 
   OR has_cafe != TRIM(has_cafe)
   OR LEN(TRIM(has_cafe)) < 3 ;

-- has_cafe column data Distribution Analysis
SELECT 
    REPLACE(REPLACE(TRIM(LOWER(has_cafe)), CHAR(13), ''),CHAR(10), '') as has_cafe ,
    COUNT(*) has_cafe_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM bronze.stores 
    GROUP BY has_cafe 
    ORDER BY has_cafe_count DESC ; 

-- has_cafe column cleaning and standardization
WITH clean_has_cafe AS 
(
    SELECT 
        CASE 
            WHEN REPLACE(REPLACE(TRIM(LOWER(has_cafe)), CHAR(13), ''),CHAR(10), '') IN ('1', 'yes', 'y','true') THEN 'True'
            WHEN REPLACE(REPLACE(TRIM(LOWER(has_cafe)), CHAR(13), ''),CHAR(10), '') IN ('0', 'no', 'n','false') THEN 'False'
            ELSE 'Unknown'
        END as has_cafe
    FROM bronze.stores 
) 
SELECT 
    has_cafe,
    COUNT(*) has_cafe_count,
    CAST(ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(), 2)as nvarchar) + '%' as percentages 
FROM clean_has_cafe
    GROUP BY has_cafe 
    ORDER BY has_cafe_count DESC ; 

--#############################################################################################
--############################## STORES CLEAN DATA ############################################
--#############################################################################################

SELECT
       store_id
      ,store_name
      ,store_type
      ,address
      ,city
      ,state
      ,state_full
      ,zip_code
      ,country
      ,region
      ,district
      ,phone
      ,manager_name
      ,opened_date
      ,sq_footage
      ,num_employees
      ,annual_rent_usd
      ,is_active
      ,has_parking
      ,has_cafe
FROM 
(
    SELECT 
        store_id

        ,CASE 
            WHEN store_name IS NULL OR LEN(TRIM(store_name)) < 3 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(store_name))
        END as store_name

        ,CASE 
            WHEN store_type IS NULL OR LEN(TRIM(store_type)) < 3 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(store_type))
        END as store_type

        ,CASE 
            WHEN address IS NULL OR TRIM(address) = '' OR LEN(address) < 5 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(address))
        END address

        ,CASE 
            WHEN city IS NULL OR TRIM(city) = '' OR LEN(TRIM(city)) < 3 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(city))
        END as city 

        ,CASE 
            WHEN TRIM(state) = 'California'  THEN 'CA'
            WHEN TRIM(state) = 'Texas'       THEN 'TX'
            WHEN TRIM(state) = 'Arizona'     THEN 'AZ'
            WHEN TRIM(state) = 'Colorado'    THEN 'CO'
            WHEN TRIM(state) = 'Maryland'    THEN 'MD'
            WHEN TRIM(state) = 'Wisconsin'   THEN 'WI'
            WHEN TRIM(state) = 'Illinois'    THEN 'IL'
            WHEN TRIM(state) = 'Georgia'     THEN 'GA'
            WHEN TRIM(state) = 'Tennessee'   THEN 'TN'
            WHEN TRIM(state) = 'New Mexico'  THEN 'NM'
            WHEN TRIM(state) = 'Ohio'        THEN 'OH'
            WHEN state IS NULL OR TRIM(state) = '' OR LEN(TRIM(state))  < 2 THEN 'Unknown'
            ELSE state
        END as state    

        ,CASE 
            WHEN state_full IS NULL OR TRIM(state_full) = '' OR LEN(TRIM(state_full)) < 4 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(state_full))
        END as state_full

        ,CASE 
            WHEN zip_code IS NULL OR TRY_CONVERT(INT, zip_code) IS NULL OR LEN(zip_code) < 5 THEN NULL 
            ELSE TRY_CONVERT(INT, zip_code)
        END as zip_code

        ,CASE 
            WHEN TRIM(LOWER(country)) IN ('us', 'usa', 'united states', 'u.s.a', 'u.s') THEN 'United States'
            WHEN country IS NULL OR TRIM(country) = '' OR LEN(TRIM(country)) < 2        THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(country))
        END as country 

        ,CASE 
            WHEN region IS NULL OR TRIM(region) = '' OR LEN(TRIM(region)) < 2 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(region))
        END as region

        ,CASE 
            WHEN district IS NULL OR TRIM(district) = '' OR LEN(TRIM(district)) < 2 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(district))
        END as district

        ,CASE 
            WHEN TRIM(phone) LIKE '(___) ___-____' THEN CONCAT('+1 ',  SUBSTRING(TRIM(phone), 1, 14))
            WHEN TRIM(phone) LIKE '+___________'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 3, 3), ') ', SUBSTRING(TRIM(phone), 6, 3),'-',  SUBSTRING(TRIM(phone), 9,4))
            WHEN TRIM(phone) LIKE '___-___-____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 8))
            WHEN TRIM(phone) LIKE '___.___.____'   THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 5, 3), '-', SUBSTRING(TRIM(phone), 9, 4))
            WHEN TRIM(phone) LIKE '__________'     THEN CONCAT('+1 (', SUBSTRING(TRIM(phone), 1, 3), ') ', SUBSTRING(TRIM(phone), 4, 3), '-', SUBSTRING(TRIM(phone), 7, 4))
            ELSE TRIM(phone)
        END as phone

        ,CASE 
            WHEN manager_name IS NULL OR TRIM(manager_name) = '' OR LEN(TRIM(manager_name)) < 2 THEN 'Unknown'
            ELSE TRIM(dbo.TitleCase(manager_name))
        END as manager_name

        ,CASE 
            WHEN opened_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,opened_date)
            WHEN opened_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,opened_date)
        
            WHEN opened_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(opened_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, opened_date, 101)
            WHEN opened_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(opened_date, 2))         > 12 THEN TRY_CONVERT(DATE, opened_date, 103)
            WHEN opened_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(opened_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, opened_date, 110)
            WHEN opened_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(opened_date, 2))         > 12 THEN TRY_CONVERT(DATE, opened_date, 105)
            ELSE TRY_CONVERT(DATE, opened_date)
        END as opened_date

        ,CASE 
            WHEN sq_footage IS NULL OR sq_footage < 0 THEN NULL
            ELSE TRY_CONVERT(INT, sq_footage)
        END as sq_footage

        ,CASE 
            WHEN num_employees IS NULL OR num_employees < 0 THEN NULL
            ELSE TRY_CONVERT(INT, num_employees)
        END as num_employees

        ,CASE 
            WHEN annual_rent_usd < 1 OR annual_rent_usd  IS NULL THEN NULL 
            ELSE TRY_CONVERT(INT, annual_rent_usd)
        END as annual_rent_usd 

        ,CASE 
            WHEN TRIM(LOWER(is_active)) IN ('true', 'yes', 'y', '1', 'active')     THEN 'True'
            WHEN TRIM(LOWER(is_active)) IN ('false', 'no', 'n', '0', 'not active') THEN 'False'
            ELSE 'Unknown'
        END as is_active

        ,CASE 
            WHEN TRIM(LOWER(has_parking)) IN ('true', 'yes', 'y', '1') THEN 'True'
            WHEN TRIM(LOWER(has_parking)) IN ('false', 'no', 'n', '0') THEN 'False'
            ELSE 'Unknown'
        END as has_parking

        ,CASE 
            WHEN REPLACE(REPLACE(TRIM(LOWER(has_cafe)), CHAR(13), ''),CHAR(10), '') IN ('1', 'yes', 'y','true') THEN 'True'
            WHEN REPLACE(REPLACE(TRIM(LOWER(has_cafe)), CHAR(13), ''),CHAR(10), '') IN ('0', 'no', 'n','false') THEN 'False'
            ELSE 'Unknown'
        END as has_cafe
    FROM [bronze].[stores]
)t ; 