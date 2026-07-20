-- ============================================================================
-- Model: int_customer_segmentation
--
-- Purpose:
--   Creates a standardized customer segmentation dataset by applying business
--   rules to customer profile and account attributes. This model normalizes
--   customer segments, imputes missing annual income using segment-level
--   median values, standardizes company names and account status values, and
--   converts inconsistent account creation dates into a reliable DATE format.
--   The resulting dataset serves as a trusted foundation for customer
--   segmentation, loyalty analysis, marketing analytics, and dimensional
--   modeling.
--
-- Maintainer: Ritik
-- ============================================================================
SELECT
    customer_id,
    CASE 
        WHEN customer_segment IS NULL OR customer_segment = '' THEN 'Unknown' 
        ELSE customer_segment
    END as customer_segment, -- distinct value is Bronze Gold Platinum Silver

    TRY_CAST(loyalty_points AS INT) as loyalty_points,

    COALESCE(
        annual_income_usd,
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY annual_income_usd)
        OVER (PARTITION BY customer_segment)
    ) as annual_income_usd,

    CASE 
        WHEN company IS NULL OR company = '' THEN 'Unknown'
        WHEN TRIM(REPLACE(REPLACE(company, CHAR(13), ''), CHAR(10), '')) = '' THEN 'Unknown'
        ELSE TRIM(REPLACE(REPLACE(company, CHAR(13), ''), CHAR(10), ''))
    END as company,

    CASE 
         WHEN {{ trim_lower('is_active') }} IN ('1', 'active', 'true', 'y', 'yes')   THEN 'True'
         WHEN {{ trim_lower('is_active') }} IN ('0', 'inactive', 'false', 'n', 'no') THEN 'False'
         ELSE 'Unknown'
    END AS is_active,

    {{ standardize_date('account_created_date') }} as account_created_date

FROM {{ ref('stg_customers') }} ;