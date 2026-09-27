

SELECT 
    *
FROM "RetailDB"."bronze"."int_customer_profile"
WHERE date_of_birth > '1900-01-01'
    AND date_of_birth < '2100-01-01'
    
