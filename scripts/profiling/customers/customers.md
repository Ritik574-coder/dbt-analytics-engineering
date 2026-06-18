# Bronze Customers Table Documentation

## Overview

The `bronze.customers` table constitutes the foundational customer master dataset utilized across downstream analytical engineering, data-quality standardization, transformation orchestration, and reporting workflows. The dataset integrates customer identity, contact, demographic, temporal, and geographic attributes consolidated from heterogeneous upstream operational systems.

Comprehensive profiling and transformation analysis revealed the presence of multiple real-world data-quality anomalies commonly observed in enterprise-scale ingestion environments, including but not limited to:

* structural inconsistencies
* semantic redundancy across attributes
* malformed and partially truncated records
* mixed regional formatting conventions
* incomplete customer identity information
* source-system standardization drift
* manual data-entry anomalies
* inconsistent temporal representations
* formatting heterogeneity across textual attributes

The principal objective of the transformation pipeline was to establish a defensible, auditable, and analytically reliable customer standardization framework capable of:

* profiling raw customer-domain data
* detecting structural and semantic inconsistencies
* standardizing valid business entities
* isolating malformed or unresolved records
* preserving transformation traceability
* improving downstream analytical reliability
* minimizing silent data corruption risk
* enabling reusable transformation logic for future ingestion workflows

---

# Table Information

| Property          | Value                                                              |
| ----------------- | ------------------------------------------------------------------ |
| Layer             | Bronze                                                             |
| Table Name        | customers                                                          |
| Domain            | Customer Master Data                                               |
| Database Platform | Microsoft SQL Server                                               |
| Primary Purpose   | Customer profiling, standardization, and analytical transformation |

---

# Final Column Structure

| Column Name          | Description                                                    |
| -------------------- | -------------------------------------------------------------- |
| customer_id          | Unique customer-level surrogate or business identifier         |
| full_name            | Original customer full-name representation from source systems |
| first_name           | Extracted or standardized customer first name                  |
| last_name            | Extracted or standardized customer last name                   |
| title                | Customer title or honorific prefix                             |
| gender               | Customer gender attribute                                      |
| email                | Standardized customer email address                            |
| phone                | Standardized US-format phone number                            |
| date_of_birth        | ISO-standardized customer date of birth                        |
| account_created_date | ISO-standardized customer account creation date                |
| city                 | Customer city information                                      |
| state_abbr           | Standardized state abbreviation                                |
| state_full           | Standardized full state name                                   |
| country              | Customer country information                                   |
| postal_code          | Customer ZIP/postal code                                       |

---

# Removed Columns

The following attributes were removed during the optimization and standardization phase because they introduced semantic redundancy, increased maintenance overhead, or failed to provide additional business utility.

| Removed Column | Rationale                                           |
| -------------- | --------------------------------------------------- |
| state          | Redundant relative to `state_abbr` and `state_full` |

---

# Customer Name Validation and Standardization

## Objective

Improve the structural consistency, reliability, and downstream usability of customer identity attributes.

## Major Data-Quality Issues Identified

* truncated first-name values
* malformed full-name structures
* inconsistent title formatting
* reconstructed name mismatches
* incomplete source-system identity values
* normalization inconsistencies across customer records

## Transformation and Validation Logic Implemented

* reconstructed full-name validation
* title-aware parsing logic
* first-name extraction workflows
* last-name extraction workflows
* normalized string comparison
* semantic mismatch detection
* defensive null-safe comparison handling

## Principal SQL Techniques Utilized

* `TRIM()`
* `LOWER()`
* `CONCAT()`
* `PARSENAME()`
* `REPLACE()`
* `ISNULL()`

---

# Email Cleaning and Standardization

## Objective

Standardize customer email structures while preserving defensive handling of malformed, incomplete, or semantically invalid records.

## Major Data-Quality Issues Identified

* inconsistent casing conventions
* leading and trailing whitespace anomalies
* duplicate `@` symbols
* malformed domain structures
* missing domain punctuation
* invalid email representations
* domain spelling inconsistencies

## Transformation Logic Implemented

* lowercase normalization
* whitespace standardization
* duplicate `@` symbol cleanup
* domain typo correction
* structural email validation
* malformed email isolation
* defensive transformation handling

## Principal SQL Techniques Utilized

* `LOWER()`
* `TRIM()`
* `PATINDEX()`
* `LEFT()`
* `SUBSTRING()`
* `REPLACE()`
* `CHARINDEX()`
* `CONCAT()`

---

# Phone Number Standardization

## Objective

Normalize all structurally valid US phone-number representations into a unified analytical formatting standard.

## Final Standardized Format

```text
+1 (AAA) BBB-CCCC
```

## Major Data-Quality Issues Identified

* inconsistent formatting separators
* heterogeneous structural patterns
* malformed phone-number representations
* incomplete numeric structures
* invalid grouping conventions
* mixed canonical and non-canonical representations

## Transformation Logic Implemented

* structural pattern profiling
* pattern-aware positional parsing
* canonical US-format reconstruction
* malformed-pattern isolation
* defensive invalid-record handling
* standardized output normalization

## Principal SQL Techniques Utilized

* `SUBSTRING()`
* `CONCAT()`
* `CASE`
* `TRIM()`

---

# Date of Birth (DOB) Cleaning and Standardization

## Objective

Standardize customer date-of-birth values into ISO 8601 format while defensively managing regional ambiguity and structurally inconsistent temporal representations.

## Major Data-Quality Issues Identified

* mixed regional date ecosystems
* locale ambiguity
* inconsistent date separators
* malformed temporal structures
* mixed deterministic and non-deterministic date patterns

## Transformation Logic Implemented

* structural date-pattern profiling
* conditional locale-aware parsing
* SQL style-code conversion
* deterministic format standardization
* fallback parsing strategies
* defensive `TRY_CONVERT()` handling
* ambiguity-aware transformation logic

## Final Standardized Format

```text
YYYY-MM-DD
```

## Principal SQL Techniques Utilized

* `TRY_CONVERT()`
* `CONVERT()`
* `TRANSLATE()`
* `LEFT()`
* `SUBSTRING()`

---

# Account Created Date Cleaning and Standardization

## Objective

Standardize account-creation temporal attributes while preserving temporal integrity and minimizing the probability of unsafe or semantically incorrect date conversion.

## Major Data-Quality Issues Identified

* mixed temporal ecosystems
* slash-formatted ambiguity
* regional formatting inconsistencies
* heterogeneous temporal standards
* partially inferable locale-dependent date structures

## Transformation Logic Implemented

* structural pattern extraction
* deterministic format conversion
* locale-aware classification
* ambiguity detection
* ISO-standard normalization
* conditional parsing workflows
* defensive temporal conversion handling

## Final Standardized Format

```text
YYYY-MM-DD
```

## Principal SQL Techniques Utilized

* `TRY_CONVERT()`
* `CONVERT()`
* `LEFT()`
* `SUBSTRING()`
* `TRANSLATE()`

---

# Geographic Data-Quality Optimization

## State Attribute Analysis

The original `state` attribute exhibited multiple quality deficiencies, including:

* inconsistent abbreviation usage
* duplicated full-state representations
* spelling inconsistencies
* semantically redundant geographic information
* mixed structural representations across records

## Final Engineering Decision

### Retained Attributes

* `state_abbr`
* `state_full`

### Removed Attribute

* `state`

### Rationale

The `state` column failed to provide incremental business value beyond the already standardized `state_abbr` and `state_full` attributes. Retaining the column would unnecessarily increase storage overhead, transformation complexity, and long-term maintenance costs.

---

# Defensive Engineering Principles Applied

The transformation framework intentionally prioritized the following engineering principles throughout the pipeline design lifecycle:

* preservation of data integrity
* transformation auditability
* conservative correction strategies
* defensive parsing methodologies
* ambiguity transparency
* malformed-record isolation
* downstream analytical reliability
* deterministic transformation preference
* prevention of silent data corruption

Potentially unsafe assumptions were intentionally avoided whenever deterministic validation could not be conclusively established.

---

# Data-Quality Techniques Utilized

| Technique                  | Purpose                                           |
| -------------------------- | ------------------------------------------------- |
| Structural Profiling       | Identification of recurring formatting structures |
| Pattern Frequency Analysis | Detection of dominant structural distributions    |
| Defensive Parsing          | Prevention of ETL execution failures              |
| Validation Rules           | Identification of malformed records               |
| Standardization Logic      | Normalization of valid business entities          |
| Conditional Parsing        | Handling of regional ambiguity                    |
| Null Validation            | Detection of unresolved or incomplete records     |
| Redundancy Analysis        | Elimination of duplicate semantic attributes      |

---

# Technologies and Methods Utilized

* Microsoft SQL Server
* T-SQL
* CASE-based transformation logic
* `TRY_CONVERT()`
* string-manipulation functions
* structural pattern profiling
* defensive data-validation methodologies
* ISO 8601 temporal standardization
* null-safe transformation workflows

---

# Final Engineering Outcome

The finalized customer-standardization pipeline successfully achieved:

* customer-domain profiling
* anomaly detection and isolation
* structural validation
* deterministic standardization
* locale-aware temporal parsing
* malformed-record isolation
* defensive ETL implementation
* downstream analytical consistency
* reusable transformation logic
* audit-friendly transformation behavior

The resulting implementation substantially improved customer-data consistency, analytical reliability, transformation transparency, and downstream usability while preserving defensible handling of malformed, incomplete, ambiguous, or unresolved source-system records.

```
Author : Ritik__
```