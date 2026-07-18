{% macro standardize_date(column_name) %}
{% set col = "TRIM(" ~ column_name ~ ")" %}

    CASE
        WHEN {{ col }} LIKE '[A-Z][a-z][a-z][a-z]% __, ____'
            THEN TRY_CONVERT(DATE, {{ col }})

        WHEN {{ col }} LIKE '[A-Z][a-z][a-z] __, ____'
            THEN TRY_CONVERT(DATE, {{ col }})

        WHEN {{ col }} LIKE '__-__-____'
            AND TRY_CONVERT(INT, SUBSTRING({{ col }}, 4, 2)) > 12
            THEN TRY_CONVERT(DATE, {{ col }}, 110)

        WHEN {{ col }} LIKE '__-__-____'
            AND TRY_CONVERT(INT, LEFT({{ col }}, 2)) > 12
            THEN TRY_CONVERT(DATE, {{ col }}, 105)

        WHEN {{ col }} LIKE '____-__-__'
            THEN TRY_CONVERT(DATE, {{ col }})

        WHEN {{ col }} LIKE '____/__/__'
            THEN TRY_CONVERT(DATE, {{ col }})

        WHEN {{ col }} LIKE '__/__/____'
            AND TRY_CONVERT(INT, SUBSTRING({{ col }}, 4, 2)) > 12
            THEN TRY_CONVERT(DATE, {{ col }}, 101)

        WHEN {{ col }} LIKE '__/__/____'
            AND TRY_CONVERT(INT, LEFT({{ col }}, 2)) > 12
            THEN TRY_CONVERT(DATE, {{ col }}, 103)

        ELSE TRY_CONVERT(DATE, {{ col }}, 101)

    END

{% endmacro %}