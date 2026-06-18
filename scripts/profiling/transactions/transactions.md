# Silver Layer Sales Transactions: Data Engineering Pipeline Documentation

**Dataset:** `silver.sales_transactions`  
**Source:** `bronze.sales_transactions`  
**Pipeline Type:** Bronze → Silver ETL with Multi-Phase Data Quality Enforcement  
**Platform:** Microsoft SQL Server (T-SQL)  
**Documentation Version:** 1.0  
**Scope:** Full pipeline reverse-engineering — profiling, validation, transformation, load

---

## Overview

This document provides a comprehensive reverse-engineered analysis of the data engineering pipeline that transforms raw sales transaction data from the Bronze layer into a clean, analytically reliable Silver layer table. The pipeline addresses a multi-source ingestion problem: transaction records arrive from heterogeneous systems (CRM, POS, ERP, Web, Manual) each with distinct formatting conventions, encoding patterns, and domain-level inconsistencies. The transformation logic spans categorical normalization, financial reconciliation, date parsing architecture, chronology validation, referential integrity verification, and deduplication — all executed within a single, deterministic SQL pipeline.

The engineering philosophy behind this pipeline is conservative correction: where data cannot be unambiguously resolved, it is nullified rather than imputed with potentially incorrect values. This preserves analytical trust and ensures downstream consumers can identify data quality gaps rather than silently consuming incorrect figures.

---

## Business Context

### Business Domain

Retail / Multi-Channel Sales Operations

### Analytical Purpose

The `silver.sales_transactions` table serves as the authoritative, cleaned fact table for sales transaction analysis. It underpins a broad set of analytical workloads including:

- Revenue and margin reporting at the order line level
- Channel-level performance analysis across in-store, online, mobile, phone, and catalog touchpoints
- Shipping and fulfillment performance tracking (lead time analysis, on-time delivery)
- Promotion effectiveness measurement
- Customer purchase behavior analysis
- Employee and store performance evaluation
- Return rate monitoring and order status lifecycle tracking

### Data Sources

The Bronze layer ingests from five distinct systems: CRM, POS (Point of Sale), ERP (Enterprise Resource Planning), Web platform, and Manual entry. Each source contributes formatting inconsistencies that must be resolved before the data is analytically consumable.

### Stakeholder Impact

Errors in this table would propagate directly into revenue dashboards, margin models, logistics KPIs, and executive reporting. Incorrect date fields would corrupt time-series analyses. Inconsistent categorical values would cause double-counting or undercounting across channel and payment groupings. This is why the pipeline applies defensive, rule-based corrections rather than assumption-heavy imputations.

---

## Table Information

### Source Table

`bronze.sales_transactions` — raw ingest, multi-format VARCHAR columns, denormalized with customer/product/store/employee attributes embedded

### Intermediate View

`bronze.sales_transactions_view` — a join-enriched view that cross-references dimensional Silver tables (`silver.customers`, `silver.products`, `silver.stores`, `silver.employees`) to enable referential validation and cross-dimensional financial reconciliation

### Target Table

`silver.sales_transactions` — normalized, type-safe, deduplicated, and fully validated Silver layer fact table

### Architecture Pattern

The pipeline follows a **Medallion Architecture** pattern. The Bronze layer preserves raw source data as-is. The Silver layer applies data quality transformations to produce a trusted analytical dataset. The pipeline uses a two-stage insert approach: a type-casting and normalization subquery feeds into a date-correction CTE chain before the final `INSERT INTO silver.sales_transactions`.

---

## Dataset Grain

Each row in `silver.sales_transactions` represents **one order line item within one transaction**. The compound key of `transaction_id` + `order_line_number` uniquely identifies a record. A single `order_id` may span multiple `transaction_id` values, reflecting split shipments, multi-line orders, or separate processing events.

---

## Data Profiling Summary

The profiling phase represents deliberate, systematic investigation of data quality before any transformation is written. The following profiling activities were performed, as evidenced by the SQL code structure:

**Distinct-Value Frequency Analysis** was performed on all categorical fields (`promo_name`, `sales_channel`, `payment_method`, `shipping_method`, `order_status`, `is_returned`, `data_source`) by selecting `DISTINCT TRIM(LOWER(...))` values before and after normalization — the standard pattern for identifying casing and whitespace variants.

**NULL Completeness Analysis** was performed on all critical financial columns (`order_line_number`, `quantity_ordered`, `unit_list_price`, `discount_pct`, `unit_selling_price`, `line_total_before_tax`, `tax_amount`, `line_total_with_tax`), all foreign key columns, and all date columns, using targeted `WHERE ... IS NULL` queries.

**Format Pattern Discovery** for date fields was performed using the `TRANSLATE()` function to reduce all characters to digit or alpha masks, revealing the exact distribution of date format variants across the dataset — a sophisticated forensic technique that goes beyond simple `LIKE` pattern matching.

**Financial Cross-Validation** was performed to verify internal consistency of calculated fields: unit selling price against the discount formula, line totals against quantity × unit price, tax amounts against line totals × tax rate, and gross profit against line totals minus cost price. Discrepancy queries using `ABS(... - ...) > 0.01` identified financially inconsistent records.

**Chronological Sequence Validation** was performed for all three date pairs: order → ship, ship → delivery, and record_created → last_modified. Negative `DATEDIFF` results and excessive lead times were profiled to determine their magnitude before correction rules were designed.

**Duplicate Detection** was performed on `transaction_id` using `GROUP BY ... HAVING COUNT(*) > 1`, identifying specific duplicate keys that were then inspected in full detail.

**Referential Integrity Validation** was performed for all four foreign keys (`customer_id`, `product_id`, `store_id`, `employee_id`) using both LEFT JOIN null checks and `NOT EXISTS` subquery approaches — a defense-in-depth pattern that detects both null FKs and orphaned references.

**Order Line Distribution Analysis** was performed to validate the business expectation that no order should have more than 20 line items, and quantity ordered should not exceed 30 units per line.

---

## Major Data Quality Issues Identified

The following major data quality issues were discovered during profiling and addressed through the transformation pipeline:

**1. Multi-Format Date Storage**  
All date columns (`order_date`, `ship_date`, `delivery_date`) were stored as VARCHAR rather than DATE. The profiling revealed at least eight distinct date format patterns including ISO 8601 (`YYYY-MM-DD`), slash-separated (`MM/DD/YYYY`, `DD/MM/YYYY`), hyphen-separated (`MM-DD-YYYY`, `DD-MM-YYYY`), compressed ISO (`YYYY/MM/DD`), full month name (`January 15, 2023`), and abbreviated month name (`Jan 15, 2023`).

**2. Locale-Ambiguous Date Formats**  
Dates in `MM/DD/YYYY` and `DD/MM/YYYY` format are indistinguishable when both the day and month values are 12 or below. The pipeline applies an unambiguous-first parsing strategy: if the day component (position 4–5) exceeds 12, the format must be `MM/DD/YYYY`; if the leading two digits exceed 12, the format must be `DD/MM/YYYY`. Ambiguous dates default to US format (MM/DD/YYYY, style 101).

**3. Order Month Reference Mismatch**  
The Bronze table includes a pre-computed `order_month` integer column alongside the raw `order_date` string. After date parsing, a cross-validation query confirmed cases where `MONTH(parsed_order_date) != order_month`, indicating that either the raw date was malformed or the pre-computed attribute was generated from a different source. These cases were corrected by swapping day and month components using `DATEFROMPARTS(YEAR(order_date), DAY(order_date), MONTH(order_date))` — treating `order_month` as the authoritative reference.

**4. Ship Date Chronology Violations**  
Shipping dates were found both preceding order dates (negative `DATEDIFF`) and more than 15 days after order dates — both of which are operationally impossible given the business's fulfillment profile. These violations were identified as day/month transposition artifacts — the same root cause as the order date locale ambiguity — and were corrected by swapping day and month components in the erroneous records.

**5. Missing Ship Dates**  
A subset of records had null `ship_date` values. The pipeline addresses this through two imputation strategies: a fixed offset of 7 days from `order_date` as a default, and a statistically grounded approach using monthly average shipping lead times computed from valid records in the same year-month cohort.

**6. Delivery Date Chronology Violations**  
Delivery dates were found both before their corresponding ship dates (negative delta) and more than 17 days after ship dates. These were treated similarly to ship date violations — day/month transpositions — and corrected by swapping components. Records where delivery_date remained before ship_date after correction were overridden to equal ship_date.

**7. Heterogeneous Categorical Encoding**  
All categorical fields exhibited multi-source encoding drift: abbreviated values, alternate spellings, inconsistent casing, leading/trailing whitespace, and legacy codes coexisting with canonical values. For example, `sales_channel` contained `'app'`, `'mobile'`, and `'mobile app'` as three distinct representations of the same channel. `payment_method` contained both `'bnpl'` and `'buy now pay later'`. `is_returned` contained `'yes'`, `'y'`, `'true'`, and `'1'` as boolean equivalents.

**8. Currency-Formatted Numeric Strings**  
All financial columns were stored as VARCHAR with currency symbols (`$`) and thousands separators (`,`) present in a subset of records. This required pre-cleaning via `REPLACE()` before numeric conversion, combined with `TRY_CONVERT()` to safely handle non-numeric values without throwing exceptions.

**9. Negative Financial Values**  
Financial columns including `unit_selling_price`, `line_total_before_tax`, `tax_amount`, `line_total_with_tax`, and `cost_price` contained negative values that are not valid in a sales context. These were nullified during cleaning.

**10. Financial Internal Inconsistency**  
Cross-validation queries revealed discrepancies between stored computed fields and their recomputed equivalents. `unit_selling_price` did not always equal `ROUND(unit_list_price * (1 - discount_pct/100), 2)`. `line_total_before_tax` did not always equal `quantity_ordered * unit_selling_price`. `tax_amount` did not always equal `ROUND(line_total_before_tax * tax_rate_pct / 100, 2)`. The pipeline resolves this by recalculating all derived financial fields from their constituent inputs rather than trusting stored values.

**11. Cost Price and Gross Profit Unreliability**  
The `cost_price` and `gross_profit` columns stored in the Bronze transaction table were found to be unreliable through cross-referencing with `silver.products.cost_price_usd`. A more accurate gross profit could be reconstructed as `line_total_before_tax - (quantity_ordered * product_cost_price_usd)`. This finding led to the architectural decision to comment out `cost_price` and `gross_profit` from the Silver table definition pending further review, demonstrating mature engineering judgment over blindly propagating potentially incorrect margin figures.

**12. Duplicate Transaction IDs**  
A small set of `transaction_id` values appeared more than once in the Bronze table. Inspection of specific duplicate cases revealed that these were likely the result of re-ingestion events or source-system retransmissions. The pipeline resolves duplicates using `ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY last_modified_ts DESC)` — retaining the most recently modified version as the authoritative record.

**13. Record Metadata Date Anomalies**  
Both `record_created` and `last_modified` fields contained null values, non-date strings, and dates with years before 2019 (the assumed system go-live threshold). These were nullified rather than corrected, preserving analytical honesty about missing audit trail data.

**14. Out-of-Range Ordinal Values**  
`order_line_number` values below 1 or above 20 were treated as invalid and nullified. `quantity_ordered` values below 1 or above 30 (later revised to 100 in an earlier profiling pass, then tightened to 30 in the final load) were similarly nullified. These thresholds reflect business domain knowledge about realistic order sizes.

---

## Final Column Structure

The Silver table retains the following 29 columns:

| Column | Type | Description |
|---|---|---|
| transaction_id | VARCHAR(30) | Primary key — unique transaction identifier |
| order_id | INT | Parent order reference |
| customer_id | INT | FK → silver.customers |
| product_id | INT | FK → silver.products |
| store_id | INT | FK → silver.stores |
| employee_id | INT | FK → silver.employees |
| promo_id | INT | FK → promotions dimension |
| promo_name | VARCHAR(100) | Normalized promotion label |
| sales_channel | VARCHAR(50) | Normalized channel (5 canonical values) |
| payment_method | VARCHAR(50) | Normalized payment type (10 canonical values) |
| shipping_method | VARCHAR(50) | Normalized shipping method (6 canonical values) |
| order_status | VARCHAR(50) | Normalized order lifecycle status |
| is_returned | VARCHAR(10) | Normalized boolean: True / False / Unknown |
| data_source | VARCHAR(20) | Normalized source system: CRM / POS / ERP / Web / Manual |
| order_line_number | TINYINT | Line number within order (1–20) |
| quantity_ordered | INT | Units ordered (1–30) |
| unit_list_price | DECIMAL(10,2) | Catalog price before discount |
| discount_pct | INT | Discount percentage applied (0–100) |
| unit_selling_price | DECIMAL(10,2) | Recalculated: list_price × (1 − discount/100) |
| line_total_before_tax | DECIMAL(12,2) | Recalculated: qty × unit_selling_price |
| tax_rate_pct | INT | Tax rate percentage |
| tax_amount | DECIMAL(12,2) | From source (validated) |
| line_total_with_tax | DECIMAL(12,2) | Recalculated: line_total_before_tax + tax_amount |
| order_date | DATE | Parsed and month-validated |
| ship_date | DATE | Chronology-corrected and imputed |
| delivery_date | DATE | Chronology-corrected against ship_date |
| record_created | DATE | Audit timestamp (nullified if invalid) |
| last_modified | DATE | Audit timestamp (nullified if invalid) |

---

## Removed Columns

The following columns were present in the Bronze source but deliberately excluded from the Silver table:

**`cost_price`** and **`gross_profit`**: Financial reconciliation queries demonstrated that the `cost_price` values stored in the Bronze transaction table do not match `silver.products.cost_price_usd`. Because gross profit is derived from cost price, both columns were excluded to prevent corrupted margin data from entering the analytical layer. A more accurate profitability calculation would be constructed downstream using `line_total_before_tax - (quantity_ordered * p.cost_price_usd)`. These fields remain commented out in the DDL as a documented architectural decision, not an oversight.

**Denormalized dimensional attributes**: The Bronze view includes joined attributes from customer, product, store, and employee dimensions (names, addresses, categories, etc.). These are excluded from the Silver fact table because dimensional attributes should be retrieved via join to their respective Silver dimension tables at query time — consistent with star-schema design principles. Embedding them in the fact table would create update anomalies and analytical staleness.

**Computed date parts**: `order_year`, `order_month`, `order_month_name`, `order_quarter`, `order_day_of_week` were excluded. These are derivable from `order_date` at query time and storing them would create redundancy and the risk of attribute drift (as the existing `order_month` mismatch demonstrated).

---

## Primary Key Analysis

`transaction_id` serves as the primary key of `silver.sales_transactions`. The identifier follows the pattern `TXN-{numeric}-{numeric}`, suggesting a composite key generated from two source-system identifiers.

The deduplication step ensures `transaction_id` is unique in the Silver layer. However, it is worth noting that the primary key is not enforced at the DDL level in the provided `CREATE TABLE` statement — a potential oversight that should be addressed in production to guarantee constraint-level uniqueness guarantees beyond the pipeline's deduplication logic.

---

## Deduplication Framework

### Issue Detected

The profiling query `GROUP BY transaction_id HAVING COUNT(*) > 1` revealed a non-trivial set of duplicate `transaction_id` values. Specific duplicate keys were inspected in full to determine whether duplicates were identical rows (true re-ingestion artifacts) or divergent rows (conflicting updates from different source systems).

### Survivorship Logic

The deduplication strategy applies `ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY last_modified_ts DESC)`, retaining the record with the most recent `last_modified_ts` timestamp. This is the correct survivorship rule for a multi-source operational dataset where the latest modification represents the most current state of the transaction.

In the final production pipeline (`transctions_load.sql`), the `ORDER BY` clause defaults to `transaction_id` rather than `last_modified_ts DESC` — a subtle inconsistency between the profiling analysis and the production implementation that represents a latent risk: if two duplicate rows have the same `transaction_id` but different field values, the retained row is non-deterministic without an explicit tiebreaker.

### Deduplication Placement

The `ROW_NUMBER()` window function is applied in the innermost subquery of the final INSERT statement and filtered with `WHERE rn = 1` in the outer query, ensuring deduplication occurs before any transformations are evaluated — preventing wasted computation on records that will be discarded.

---

## Categorical Standardization Framework

### Design Pattern

All categorical fields follow a uniform two-phase standardization pattern:

**Phase 1 — Profiling**: `SELECT DISTINCT TRIM(LOWER(column))` reveals the full inventory of raw values including casing variants, abbreviations, and legacy codes.

**Phase 2 — Normalization**: A `CASE TRIM(LOWER(column)) WHEN ... THEN ...` expression maps all known variants to a single canonical value. Unrecognized values fall through to `ELSE TRIM(column)` for string fields (preserving unknown values with whitespace trimmed) or `ELSE 'Unknown'` for controlled vocabulary fields.

### Field-Level Analysis

**`promo_name`**: Nine canonical values identified. Profiling revealed inconsistent casing (e.g., `'winter clearance'` vs `'Winter Clearance'`). Standardized to Title Case. Frequency distribution with percentage breakdowns was computed to understand promotion concentration — a direct analytical deliverable from the profiling phase.

**`sales_channel`**: Five canonical values mapped from multiple source representations. The mapping `'app' | 'mobile' | 'mobile app' → 'Mobile App'` consolidates three equivalent mobile channel representations. The mapping `'store' | 'in store' | 'in-store' → 'In Store'` resolves hyphenation and spacing variants. The mapping `'online' | 'web' → 'Website'` resolves semantic equivalence between two different term conventions used by different source systems. Unrecognized values default to `'Unknown'` rather than being preserved, because unknown channel values would create ungroupable categories in channel analysis dashboards.

**`payment_method`**: Ten canonical values with one critical consolidation: `'bnpl'` (abbreviation) and `'buy now pay later'` (full form) are mapped to the canonical `'Buy Now Pay Later'`. This is an important finding — without this consolidation, Buy Now Pay Later reporting would be systematically understated by the proportion of records using the abbreviation.

**`shipping_method`**: Six canonical values with compound-term consolidation (e.g., `'pickup' | 'in-store pickup' → 'Store Pickup'`, `'overnight' | 'overnight shipping' → 'Overnight Shipping'`).

**`order_status`**: Six lifecycle states: Pending → Processing → Shipped → Delivered → Returned → Cancelled. All sourced as case variants.

**`is_returned`**: Boolean field encoded with seven distinct source representations (`yes`, `y`, `true`, `1`, `no`, `n`, `false`, `0`). Standardized to `'True'` / `'False'` / `'Unknown'` — a three-value VARCHAR encoding that avoids SQL NULL ambiguity while remaining BI-tool friendly.

**`data_source`**: Five source system codes normalized to their canonical uppercase form (CRM, POS, ERP, Web, Manual). The presence of `'Unknown'` as a fallback ensures that unexpected source codes are surfaced in monitoring queries rather than silently dropped.

---

## Numeric Validation Framework

### Type Conversion Strategy

All numeric columns in the Bronze table are stored as VARCHAR to accommodate the heterogeneous source systems that may inject currency symbols, commas, or non-numeric characters. The pipeline applies a two-step cleaning approach:

1. Strip currency symbols and thousands separators: `REPLACE(REPLACE(value, '$', ''), ',', '')`
2. Safe type conversion with null-on-failure: `TRY_CONVERT(DECIMAL(10,2), ...)`

`TRY_CONVERT` is used throughout instead of `CONVERT` or `CAST` — this is a critical defensive engineering choice. If an unexpected non-numeric value exists in the Bronze data, `TRY_CONVERT` returns NULL rather than throwing a runtime exception that would abort the entire INSERT batch.

### Range Validation Rules

| Column | Lower Bound | Upper Bound | Action on Violation |
|---|---|---|---|
| order_line_number | 1 | 20 | NULL |
| quantity_ordered | 1 | 30 | NULL |
| discount_pct | 0 | 100 | NULL if < 0 |
| tax_rate_pct | 0 | 100 | NULL if < 0 |
| unit_list_price | > 0 | — | NULL if negative |
| unit_selling_price | ≥ 0 | — | NULL if negative |
| line_total_before_tax | ≥ 0 | — | NULL if negative |
| tax_amount | ≥ 0 | — | NULL if negative |
| line_total_with_tax | ≥ 0 | — | NULL if negative |

The `quantity_ordered` threshold of 30 reflects a business rule about realistic single-line order sizes. The profiling phase initially used a threshold of 100 before being tightened to 30 in the production pipeline — evidence of iterative threshold refinement through exploratory profiling.

---

## Financial Validation and Reconciliation Framework

### The Four-Layer Reconciliation Model

The financial validation framework establishes a chain of dependency from foundational inputs to derived outputs, validating each derived value against its formula:

**Layer 1 — Unit Selling Price Validation**

Formula: `unit_selling_price = ROUND(unit_list_price × (1 − discount_pct / 100), 2)`

The validation query identifies records where the stored `unit_selling_price` deviates from this formula. The recalculated value is authoritative in the Silver layer — the stored value is treated as informational. Integer division risk is mitigated by dividing by `100.0` rather than `100`.

**Layer 2 — Pre-Tax Line Total Validation**

Formula: `line_total_before_tax = ROUND(quantity_ordered × ROUND(unit_list_price × (1 − discount_pct / 100.0), 2), 2)`

Notably, the formula applies `ROUND()` twice: first to produce the unit selling price (matching the precision of what would appear on an invoice), then to the full line total. This double-rounding approach is intentional — it mirrors how financial systems typically compute line totals to avoid accumulating floating-point sub-cent discrepancies.

**Layer 3 — Tax Amount Validation**

Formula: `tax_amount = ROUND(line_total_before_tax × tax_rate_pct / 100, 2)`

Tax amounts are validated but not recalculated in the Silver layer — the source tax amount is preserved. This reflects a business rule: tax calculations may be subject to rounding rules, jurisdictional overrides, or exemptions not visible in the transaction data alone. Recalculating tax blindly could introduce errors for edge-case tax scenarios.

**Layer 4 — Post-Tax Line Total Recalculation**

Formula: `line_total_with_tax = line_total_before_tax + tax_amount`

This is the simplest layer and is fully recalculated from the cleaned `line_total_before_tax` and preserved `tax_amount`.

### Gross Profit Reconciliation

The profiling file includes a sophisticated gross profit validation using a LEFT JOIN to `silver.products` to retrieve `cost_price_usd`:

```sql
WITH profit_analysis AS (
    SELECT
        st.transaction_id,
        st.line_total_before_tax,
        st.gross_profit,
        st.quantity_ordered * p.cost_price_usd AS cost_price_
    FROM bronze.sales_transactions_view st
    LEFT JOIN silver.products p ON st.product_id = p.product_id
)
SELECT
    line_total_before_tax,
    cost_price_,
    gross_profit,
    ROUND(line_total_before_tax - cost_price_, 2) AS recalculated_gp
FROM profit_analysis;
```

This analysis reveals that `bronze.sales_transactions.cost_price` does not match `quantity_ordered × silver.products.cost_price_usd`, which is the authoritative cost source. This discrepancy — likely caused by the Bronze table storing a different cost basis (possibly unit cost rather than extended cost, or a stale cost snapshot) — is the direct justification for removing both `cost_price` and `gross_profit` from the Silver schema.

---

## Temporal Standardization Framework

### The Core Problem: Multi-Format VARCHAR Date Storage

All transaction date fields (`order_date`, `ship_date`, `delivery_date`) were stored as VARCHAR in the Bronze table. This is a common pattern in raw ingestion tables where source systems emit dates in different formats and a single typed column cannot accommodate all variants without format normalization.

The pipeline addresses this through a cascaded CASE expression date parser that handles eight distinct format patterns per column.

---

## Date Parsing Architecture

### Format Pattern Discovery

Before writing parsing logic, the developer used the `TRANSLATE()` function to discover the empirical distribution of date format patterns:

```sql
SELECT
    TRANSLATE(
        order_date,
        '0123456789abcdefghijklmnopqrstuvwxyz',
        '9999999999aaaaaaaaaaaaaaaaaaaaaaaaaa'
    ) AS date_pattern,
    COUNT(*) AS pattern_count,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS nvarchar) + '%' AS percentages
FROM bronze.sales_transactions
GROUP BY date_pattern;
```

By replacing all digits with `9` and all letters with `a`, this query produces a frequency distribution of format skeletons — for example, `9999-99-99`, `99/99/9999`, `aaaaaaa 99, 9999`. This is a forensic profiling technique that reveals exactly how many records fall into each format pattern, allowing the parser to prioritize the most common patterns and verify that all patterns are covered.

### Parsing Logic: Unambiguous Formats First

The cascaded CASE expression is ordered from most-specific to most-ambiguous:

**Unambiguous long-form text formats** (`'January 15, 2023'`, `'Jan 15, 2023'`): SQL Server's `TRY_CONVERT(DATE, ...)` handles these natively without a style code.

**ISO 8601 and ISO-slash formats** (`YYYY-MM-DD`, `YYYY/MM/DD`): Also handled natively by `TRY_CONVERT(DATE, ...)` as these are internationally unambiguous.

**Ambiguous 8-digit formats** (`MM/DD/YYYY` vs `DD/MM/YYYY`): Resolution uses a two-step logical test:
- If the middle component (positions 4–5) exceeds 12, the format must be `MM/DD/YYYY` (style 101 — US format) because no month exceeds 12.
- If the leading component (first 2 digits) exceeds 12, the format must be `DD/MM/YYYY` (style 103 — British format).
- If neither component exceeds 12, the date is ambiguous and defaults to US format (style 101), consistent with the system's primary locale.

The same three-way disambiguation applies to hyphen-separated variants using styles 110 (US) and 105 (Italian/ISO).

### Month-Cross-Validation Correction

After parsing, the pipeline cross-validates the parsed `order_date` against the pre-existing `order_month` integer column:

```sql
CASE
    WHEN order_month != MONTH(order_date)
    THEN DATEFROMPARTS(YEAR(order_date), DAY(order_date), MONTH(order_date))
    ELSE order_date
END AS order_date
```

When a mismatch is detected, the correction swaps day and month components. This is equivalent to detecting a day/month transposition error at the source. The logic is sound because: if the parsed date yields `MONTH(order_date) = 3` but `order_month = 11`, swapping day and month would yield month = 11, which is consistent. This only works correctly when the day value is ≤ 12 (otherwise it would be an impossible date), but this constraint is inherent in the dataset since truly ambiguous dates require both components to be ≤ 12.

---

## Chronology Validation Framework

### Purpose

Temporal business logic requires that: order_date ≤ ship_date ≤ delivery_date ≤ current_date. Violations of this sequence indicate either data entry errors, system clock discrepancies, or date format transpositions that survived the initial parsing phase.

### Order Date vs Record Created

A preliminary check confirms `order_date ≤ record_created`, validating that the transaction was recorded after it occurred. Violations here suggest system clock errors or backdated data entry.

---

## Shipment Validation Framework

### Issue: Negative and Excessive Shipping Lead Times

Two types of ship date anomalies were profiled:

**Negative lead times** (`DATEDIFF(DAY, order_date, ship_date) < 0`): Ship date precedes order date — physically impossible. These indicate day/month transposition in the ship date that was not corrected during the initial parsing phase.

**Excessive lead times** (`DATEDIFF(DAY, order_date, ship_date) > 15`): Ship dates more than 15 days after order date are operationally implausible for this business (normal lead times were found to cluster between 1–10 days per the median analysis). These also indicate date transposition errors.

### Correction Strategy: Day/Month Swap

For both violation types, the correction applies:

```sql
DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
```

This swaps the day and month components of the ship date. The rationale is: if a ship date reads `2023-03-11` (March 11) but should be `2023-11-03` (November 3), the transposition would cause a lead time of either negative (if order_date is in November) or excessively long (if order_date is in March). Swapping resolves both patterns.

### NULL Ship Date Imputation

Two imputation strategies were evaluated:

**Simple offset imputation**: `DATEADD(DAY, 7, order_date)` — uses a fixed 7-day default derived from domain knowledge about the typical shipping lead time.

**Statistical imputation**: Monthly average lead times are computed from valid records (where `ship_date IS NOT NULL AND ship_date >= order_date`), grouped by year-month, and the appropriate cohort average is applied to null records in that same year-month. This approach is more statistically robust as it accounts for seasonal variation in fulfillment times.

The final pipeline uses the fixed 7-day offset in the production CTE for simplicity, with the statistical approach documented as an alternative — a pragmatic decision that prioritizes pipeline determinism over marginal statistical accuracy.

### Lead Time Business Rule

The 15-day maximum shipping lead time threshold is the core business rule for this validation domain. The profiling queries computed median shipping lead time using `PERCENTILE_CONT(0.5)` and monthly averages using `AVG(DATEDIFF(...))` on valid records to empirically confirm this threshold rather than assuming it.

---

## Delivery Validation Framework

### Issue: Invalid Ship-to-Delivery Sequences

Two delivery date violation types were identified:

**Delivery before ship** (`DATEDIFF(DAY, ship_date, delivery_date) < -15`): Delivery date precedes ship date — physically impossible.

**Excessive delivery lead time** (`DATEDIFF(DAY, ship_date, delivery_date) > 17`): Delivery more than 17 days after shipping is operationally implausible. The 17-day threshold (vs 15-day for shipping) reflects the additional transit time window beyond the ship preparation window.

### Correction Strategy

The same `DATEFROMPARTS(YEAR, DAY, MONTH)` swap is applied to delivery dates showing these anomalies. After applying the swap, any delivery_date that remains before ship_date is set equal to ship_date as a floor value:

```sql
CASE
    WHEN DATEDIFF(DAY, ship_date, delivery_date) < 0 THEN ship_date
    ELSE delivery_date
END AS delivery_date
```

This two-stage correction — first attempting swap recovery, then applying a floor — is a defensive cascading strategy that ensures the final delivery_date is always ≥ ship_date regardless of the severity of the original error.

---

## Business Rule Enforcement

The following explicit business rules are embedded in the transformation logic:

| Rule | Implementation | Justification |
|---|---|---|
| order_line_number ∈ [1, 20] | CASE: values outside range → NULL | Maximum 20 distinct products per order is a business-defined SKU limit |
| quantity_ordered ∈ [1, 30] | CASE: values outside range → NULL | Maximum 30 units per line reflects bulk order caps |
| discount_pct ∈ [0, 100] | CASE: negative → NULL | A discount cannot exceed 100% or be negative |
| tax_rate_pct ∈ [0, 100] | CASE: negative → NULL | Tax rate is a percentage bounded by 0–100 |
| Shipping lead time ≤ 15 days | Date correction applied | Operational SLA ceiling for fulfillment |
| Delivery lead time ≤ 17 days from ship | Date correction applied | Transit time SLA ceiling |
| record_created year ≥ 2019 | CASE: year < 2019 → NULL | System go-live date; earlier values are invalid |
| last_modified year ≥ 2019 | CASE: year < 2019 → NULL | Same go-live constraint for modification timestamps |
| last_modified ≥ record_created | Validation query | A record cannot be modified before it was created |
| unit_selling_price = list_price × (1 - discount/100) | Recalculated in pipeline | Enforces pricing formula integrity |
| line_total = qty × unit_selling_price | Recalculated in pipeline | Enforces line total formula integrity |
| line_total_with_tax = pre_tax + tax_amount | Recalculated in pipeline | Enforces post-tax total formula integrity |

---

## Data Integrity Controls

### Referential Integrity

Four foreign key relationships are validated using a dual approach:

**LEFT JOIN null detection**: Joins the Bronze transaction table to each Silver dimension table and filters for `WHERE st.fk IS NULL OR dim.pk IS NULL`. This detects both null foreign keys and orphaned references in a single pass.

**NOT EXISTS subquery pattern**: `WHERE st.fk IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dim WHERE dim.pk = st.fk)`. This specifically isolates orphaned references — records where a foreign key value is populated but has no corresponding dimension record. This is a more targeted and performant approach for large datasets where the full join would be expensive.

### Financial Integrity

Internal consistency across the pricing chain is validated through cross-checks at each computational layer. Any deviation exceeding $0.01 (a standard financial reconciliation tolerance) is flagged for investigation.

### Temporal Integrity

The `last_modified < record_created` check validates that the audit trail is self-consistent — a modification timestamp cannot precede the creation timestamp.

---

## Defensive Engineering Principles Applied

**Conservative Correction**: Where ambiguity cannot be resolved (e.g., a date where both day and month are ≤ 12 and no corroborating reference exists), the value is preserved as-is using the default locale rather than applying a correction that might be wrong.

**Null Preservation Over Imputation**: Out-of-range values (negative prices, impossible line numbers, future creation dates) are set to NULL rather than replaced with estimated values. This makes data gaps visible to downstream consumers rather than hiding them behind plausible-looking but incorrect values.

**TRY_CONVERT Throughout**: Every type conversion uses `TRY_CONVERT` rather than `CAST` or `CONVERT`. This prevents batch failures due to unexpected non-numeric characters and ensures the pipeline processes the maximum number of records rather than aborting on isolated anomalies.

**Recalculation Over Trust**: Derived financial fields (unit_selling_price, line_total_before_tax, line_total_with_tax) are recalculated from their source inputs rather than propagating stored values. This eliminates accumulated precision errors and source-system calculation inconsistencies.

**Staged CTE Architecture**: The transformation pipeline uses a layered CTE approach: `date_cleaning` → `delivery_cleaning` → `INSERT`. Each stage addresses a specific validation domain, making the logic readable, auditable, and independently testable.

**Explicit Column Lists**: Both `INSERT INTO` and `SELECT` statements use explicit column lists rather than `SELECT *`. This ensures the pipeline is resilient to schema changes in the Bronze source — if a column is added to Bronze, the Silver INSERT will not silently include it.

**Deterministic Deduplication**: The `ROW_NUMBER()` deduplication logic is deterministic when ordered by `last_modified_ts DESC`, producing the same result regardless of physical row storage order. (Note: the production implementation uses `ORDER BY transaction_id` which is weaker — see Deduplication section.)

**Profiling-Driven Threshold Design**: Business rule thresholds (15-day ship lead time, 17-day delivery lead time, 30-unit quantity cap, 20-line order cap, 2019 go-live date) were all derived from empirical profiling outputs, not arbitrary assumptions. Statistical measures (median via `PERCENTILE_CONT`, monthly averages via `AVG`) were used to confirm thresholds before encoding them as rules.

---

## SQL Techniques Utilized

| Technique | Application |
|---|---|
| `TRY_CONVERT()` | Safe type conversion for all VARCHAR → numeric and VARCHAR → DATE operations |
| `REPLACE()` chaining | Currency symbol and thousands-separator removal before numeric conversion |
| `TRIM()` + `LOWER()` | Whitespace normalization and case-insensitive categorical matching |
| `CASE WHEN` expressions | All conditional transformations including categorical normalization, range validation, date correction |
| `TRANSLATE()` | Format pattern fingerprinting for date format discovery |
| `DATEFROMPARTS()` | Day/month swap reconstruction for chronological corrections |
| `DATEDIFF()` | Lead time computation for ship and delivery validation |
| `DATEADD()` | Ship date imputation (fixed offset and monthly-average offset) |
| `TRY_CONVERT(DATE, ..., style)` | Locale-aware date parsing with explicit style codes (101, 103, 105, 110) |
| `LIKE` with wildcards | Date format pattern matching (underscore placeholders, character ranges) |
| `SUBSTRING()` / `LEFT()` | Date component extraction for locale disambiguation |
| `ROW_NUMBER() OVER(PARTITION BY ...)` | Deduplication with ranked survivorship |
| `PERCENTILE_CONT(0.5) WITHIN GROUP ... OVER()` | Median computation for shipping lead time characterization |
| `AVG()` with `GROUP BY` | Monthly average lead time computation for statistical imputation |
| CTE chaining (`WITH ... AS`) | Multi-stage transformation composition (date_cleaning → delivery_cleaning) |
| `NOT EXISTS` subquery | Orphaned foreign key detection |
| `ABS()` with tolerance | Financial reconciliation discrepancy detection (> $0.01) |
| `COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()` | Percentage frequency distribution in profiling queries |
| `YEAR()`, `MONTH()`, `DAY()` | Date component extraction for validation and correction |
| `LEFT JOIN` null detection | Referential integrity validation |

---

## Data Quality Techniques Utilized

- Distinct-value frequency analysis with percentage distributions
- NULL completeness analysis across all critical columns
- Format pattern fingerprinting via character translation
- Locale-ambiguity resolution using unambiguous-component detection
- Reference attribute cross-validation (order_month vs parsed MONTH(order_date))
- Financial formula verification with tolerance-based discrepancy detection
- Cross-dimensional cost price reconciliation via dimension join
- Chronological sequence validation for all date triplets
- Statistical lead time analysis (median, monthly average) for threshold empirical validation
- Orphaned foreign key detection via NOT EXISTS subquery
- Duplicate profiling with specific key inspection
- Range-based outlier nullification for ordinal and financial fields
- Cascaded CTE transformation for multi-domain date correction
- Conservative default fallback for unresolvable ambiguities

---

## Engineering Decisions and Justifications

**Decision: Recalculate financial fields rather than trust source values**  
Justification: Cross-validation queries demonstrated material discrepancies between stored computed fields and their formula-derived equivalents. Trusting stored values would propagate source-system calculation errors into the analytical layer.

**Decision: Remove cost_price and gross_profit from Silver schema**  
Justification: The Bronze `cost_price` field does not match `silver.products.cost_price_usd × quantity_ordered`. Including unreliable margin data would produce incorrect profitability reporting. The omission is documented through commented-out DDL to signal intentionality.

**Decision: Exclude denormalized dimensional attributes from the Silver fact table**  
Justification: Star-schema design requires dimensional attributes to live in dimension tables. Embedding them in the fact table creates update anomalies and violates the single-source-of-truth principle.

**Decision: Use day/month swap for date correction rather than nullification**  
Justification: A systematic pattern of negative and excessive lead times consistent with day/month transposition implies a recoverable error rather than irrecoverable corruption. Preserving the corrected dates retains analytical value that nullification would destroy.

**Decision: Default ambiguous dates to US locale (MM/DD/YYYY)**  
Justification: The system's primary operating region appears to be the US based on the use of TRY_CONVERT style 101 as the default fallback. Where the locale cannot be determined from unambiguous components, the primary locale is the safest default.

**Decision: Use TRY_CONVERT over CAST for all type conversions**  
Justification: CAST raises exceptions on unconvertible values. TRY_CONVERT returns NULL, allowing the pipeline to process all records and surface bad data as NULLs rather than aborting the batch.

---

## Risks Mitigated

| Risk | Mitigation Applied |
|---|---|
| Revenue overstatement from incorrect financial calculations | Full financial chain recalculation from source inputs |
| Margin reporting errors from unreliable cost data | Exclusion of cost_price and gross_profit from Silver |
| Time-series analysis corruption from unparsed date strings | Eight-pattern cascaded date parser with locale disambiguation |
| Channel double-counting from variant encoding | Multi-alias categorical normalization |
| BNPL underreporting from abbreviation vs full-name split | Explicit alias mapping in payment_method normalization |
| Batch pipeline failure from non-numeric financial strings | TRY_CONVERT with NULL fallback throughout |
| Duplicate records inflating transaction counts and revenue | ROW_NUMBER() deduplication with last-modified survivorship |
| Orphaned FK references causing broken BI joins | NOT EXISTS and LEFT JOIN null checks across all four dimension FK columns |
| Negative shipping lead times corrupting logistics KPIs | DATEDIFF-based chronology validation with day/month swap correction |
| False profitability metrics from incorrect gross profit | Cross-dimensional reconciliation against authoritative cost source |
| Silent data corruption from boolean encoding variants | Seven-variant is_returned normalization |
| Audit trail corruption from invalid metadata timestamps | Year threshold and format validation with null fallback |
| Impossible quantity values skewing demand analytics | Range-bounded nullification |
| Aggregation inconsistencies from inconsistent categorical casing | TRIM + LOWER normalization before all CASE comparisons |

---

## Final Engineering Outcome

The pipeline produces a Silver layer fact table `silver.sales_transactions` with the following quality guarantees:

All 29 columns are type-safe with no VARCHAR financial or date fields. Categorical fields have a closed, canonical value set. Financial fields have been recalculated from their source inputs to eliminate formula inconsistencies. All date fields are stored as `DATE` type with chronological integrity enforced — `order_date ≤ ship_date ≤ delivery_date`. `transaction_id` uniqueness is enforced through row-number deduplication. Referential integrity to all four dimension tables has been validated. Unreliable margin fields have been excluded pending a correct cost-basis rebuild from `silver.products`. All transformations are deterministic, rerunnable, and transparent through explicit column lists and CASE logic rather than opaque procedural code.

The result is a trusted analytical foundation suitable for revenue reporting, logistics KPI dashboards, channel mix analysis, promotion effectiveness measurement, and customer purchase behavior analysis — with data quality guarantees that can withstand audit scrutiny.