SELECT
    return_id,

      CASE 
          WHEN return_reason IS NULL OR TRIM(return_reason) = '' 
            THEN 'Unknown'

          ELSE TRIM(dbo.TitleCase(return_reason))
      END as return_reason,

      CASE 
          WHEN 
    LOWER(TRIM(return_channel))
 IN ('app', 'mobile app', 'mobile')   
            THEN 'Mobile App'

        WHEN 
    LOWER(TRIM(return_channel))
 IN ('in store', 'in-store', 'store') 
            THEN 'In Store'

        WHEN 
    LOWER(TRIM(return_channel))
 IN ('online', 'web')                 
            THEN 'Online'

        WHEN 
    LOWER(TRIM(return_channel))
 = 'phone'                            
            THEN 'Phone Call'

        WHEN 
    LOWER(TRIM(return_channel))
 = 'catalog'                          
            THEN 'Catalog'

        ELSE 'Unknown'
      END AS return_channel,
    
      CASE 
          WHEN 
    LOWER(TRIM(restocked))
 IN ('yes', 'y', '1') 
            THEN 'Yes'

          WHEN 
    LOWER(TRIM(restocked))
 IN ('no', 'n', '0')  
            THEN 'No'

          ELSE 'Unknown'
      END AS restocked,

      CASE 
          WHEN return_status IS NULL 
            THEN 'Unknown'

          ELSE TRIM(dbo.TitleCase(return_status))
      END as return_status,

      CASE 
          WHEN handled_by_emp_id IS NULL OR TRY_CONVERT(INT, handled_by_emp_id) IS NULL 
            THEN NULL 

          ELSE TRY_CONVERT(INT, handled_by_emp_id)
      END as handled_by_emp_id,

      CASE 
          WHEN notes IS NULL OR LEN(TRIM(notes)) < 3 OR TRIM(notes) = '' THEN 'Unknown'
          ELSE TRIM(dbo.TitleCase(REPLACE(REPLACE(notes, CHAR(10), ''), CHAR(13), '')))
      END as notes
FROM "RetailDB"."bronze"."stg_returns" ;