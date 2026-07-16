{% test valid_date_of_birth(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} IS NOT NULL
  AND (
        {{ column_name }} < '1900-01-01'
        OR {{ column_name }} > CAST(GETDATE() AS DATE)
      )

{% endtest %}