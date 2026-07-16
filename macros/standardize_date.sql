{% macro standardize_date(column_name) %}

CASE
    WHEN TRIM({{ column_name }}) LIKE '[A-Z][a-z][a-z][a-z]% __, ____'
        THEN TRY_CONVERT(DATE, TRIM({{ column_name }}))

    WHEN TRIM({{ column_name }}) LIKE '[A-Z][a-z][a-z] __, ____'
        THEN TRY_CONVERT(DATE, TRIM({{ column_name }}))

    WHEN TRIM({{ column_name }}) LIKE '____-__-__'
        THEN TRY_CONVERT(DATE, TRIM({{ column_name }}))

    WHEN TRIM({{ column_name }}) LIKE '____/__/__'
        THEN TRY_CONVERT(DATE, TRIM({{ column_name }}))

    WHEN TRIM({{ column_name }}) LIKE '__/__/____'
         AND TRY_CONVERT(INT, SUBSTRING(TRIM({{ column_name }}), 4, 2)) > 12
        THEN TRY_CONVERT(DATE, TRIM({{ column_name }}), 101)

    WHEN TRIM({{ column_name }}) LIKE '__/__/____'
         AND TRY_CONVERT(INT, LEFT(TRIM({{ column_name }}), 2)) > 12
        THEN TRY_CONVERT(DATE, TRIM({{ column_name }}), 103)

    ELSE TRY_CONVERT(DATE, TRIM({{ column_name }}), 101)

END

{% endmacro %}