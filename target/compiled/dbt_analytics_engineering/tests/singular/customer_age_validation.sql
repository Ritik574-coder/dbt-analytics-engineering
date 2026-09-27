SELECT
    * 
FROM "RetailDB"."bronze"."int_customer_profile"
WHEREdate_of_birth NOT LIKE '____-__-__' 
    OR date_of_birth IS NULL  ;