{% macro standardize_phone(column_name) %}
{% set col = "TRIM(" ~ column_name ~ ")" %}
    CASE 
        WHEN {{ col }} LIKE '+1__________'   
            THEN CONCAT('+1 (', SUBSTRING({{ col }}, 3, 3), ') ',
            SUBSTRING({{ col }}, 6, 3),'-',
            SUBSTRING({{ col }},9,4))

        WHEN {{ col }} LIKE '__________'     
            THEN CONCAT('+1 (', SUBSTRING({{ col }}, 1 ,3), ') ',
            SUBSTRING({{ col }}, 4 ,3), '-',
            SUBSTRING({{ col }}, 7, 4))

        WHEN {{ col }} LIKE '___-___-____'   
            THEN CONCAT('+1 (', SUBSTRING({{ col }}, 1, 3), ') ',
            SUBSTRING({{ col }}, 5, 3), '-',
            SUBSTRING({{ col }}, 9 ,4))

        WHEN {{ col }} LIKE '___.___.____'   
            THEN CONCAT('+1 (', SUBSTRING({{ col }}, 1, 3), ') ',
            SUBSTRING({{ col }}, 5, 3), '-',
            SUBSTRING({{ col }},9, 4))

        WHEN {{ col }} LIKE '(___) ___-____' 
            THEN CONCAT('+1 ',  SUBSTRING({{ col }}, 1, 14))

        WHEN {{ col }} IS NULL OR {{col }} = '' 
            THEN 'Unknown'

        ELSE 'Unknown'
    END
{% endmacro %}
