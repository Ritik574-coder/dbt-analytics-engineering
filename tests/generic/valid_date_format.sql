{% test valid_date_format(model, column_name) %}

SELECT 
    *
FROM {{ model }}
WHERE {{ column_name }} NOT LIKE '____-__-__'
    OR {{ column_name }} IS NULL 
    
{% endtest %}