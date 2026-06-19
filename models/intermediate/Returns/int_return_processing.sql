SELECT
    return_id,
    return_reason,
    return_channel,
    restocked,
    return_status,
    handled_by_emp_id,
    notes
FROM {{ ref('stg_returns') }} ;