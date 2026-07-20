{% macro trim_lower(column_name) %}
    LOWER(TRIM({{ column_name }}))
{% endmacro %}