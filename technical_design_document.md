#                            Architecture Design Document (ADD)

---

Before I Buildign This Project and write a single line of SQL or YAML, I need to **design the foundation**. Here’s how I’ll approach this:

---

### **1. Project Scope & Business Context**

#### Q -  What’s the **primary purpose** of this dbt project ?

```
primary purpose : Learn dbt deeply, cover advanced dbt features, and develop strong critical thinking and problem-solving abilities.

This project simulates retail business and is designed to help me learn dbt deeply, cover maximum dbt features, build Thinking, and develop the mindset of an Analytics Engineer. The project includes key business domains such as Customer, Sales, Product, Inventory, Marketing, Finance, Fulfillment, and Returns, enabling the implementation of real-world data modeling, testing, documentation, lineage, snapshots, incremental processing, and analytics engineering best practices.
```

#### Q - What are the **key business domains** ?

```
Project Domain: Retail Analytics Platform
```

#### Q - Who are the **stakeholders** ?

```
Stakeholders: Data Analysts, Analytics Engineers, and Data Engineers.
```

---

### **2. Source Systems & Data Ingestion**

#### Q - What are the **source systems** ?

```
Source Systems:
CSV files serve as the raw operational data source. Data is ingested into SQL Server, where dbt performs transformations, testing, documentation, and modeling to create analytics-ready datasets.
```

#### Q - How is data **ingested** into the warehouse ?

```
Data Ingestion :

Data is ingested into the warehouse through custom SQL Server ETL scripts. Raw CSV files are loaded into Bronze tables using SQL-based ingestion procedures.
```

#### Q - What’s the **data volume and velocity** ?

```
Data Volume:
Small-scale dataset becouse This project simulates to help me learn dbt deeply,

Data Velocity:
Batch processing. Data is loaded periodically from CSV files into SQL Server using custom ingestion scripts. 
```

---

### **3. dbt Project Architecture**

#### Q - What are the dbt Project **Layering Strategy** ?

```
Layering Strategy : Staging → Intermediate → Marts

Staging (stg_): Raw source data cleaning, standardization, and renaming.
Intermediate (int_): Business logic, joins, aggregations, and reusable transformations.
Marts (fct_, dim_): Analytics-ready fact and dimension tables optimized for reporting and BI.
```

#### Q - What are the **Model Organization** ? 

```
Model Organization: By Domain

Models are organized by business domain (e.g., Sales, Marketing, Finance) to improve maintainability, ownership, and scalability.

Each domain contains its own staging, intermediate, and mart models, making it easier to navigate and manage domain-specific transformations.

This structure aligns well with business processes and supports future project growth.
```

#### Q - **DAG Design**:

```
The DAG follows a linear dependency structure from staging to intermediate to marts. Staging models depend only on source tables, intermediate models depend on staging models, and marts depend on intermediate models. Circular dependencies are strictly avoided to maintain a clear, maintainable, and scalable lineage graph.
```

#### Q - What are the **Materializations** overview ?

```
Materializations:

Physical table materialization is used for the Bronze (Staging) and Silver (Intermediate) layers to persist transformed data and improve performance for downstream processing. The Gold (Mart) layer is materialized as views, providing business-ready datasets while avoiding unnecessary data duplication. This approach balances storage efficiency, maintainability, and query performance by storing transformation-heavy layers as physical tables and exposing analytical models through virtual tables (views).
```

---

### **4. Data Modeling Approach**

- What are the **Schema** That use ?

```
Data Modeling Approach: Star Schema (Kimball)

Fact tables (fct_) store measurable business events and metrics.
Dimension tables (dim_) store descriptive business attributes.
Dimensions are directly connected to fact tables, minimizing joins and improving query performance.

The model is optimized for analytics, reporting, and BI tools, providing a simple and intuitive structure for end users.
This approach follows Kimball dimensional modeling principles and is well-suited for scalable analytical workloads.
```
---

### **5. dbt Configuration & Best Practices**

#### Q - What are the **dbt Version** ? 

```
Core:
  - installed: 1.11.11
  - latest:    1.11.11

Plugins:
  - sqlserver: 1.10.0
```

#### Q - What are the **Project Structure**:

```
The analyses directory is used for exploratory and ad-hoc analytical queries that support business investigations, validation, and experimentation. Queries in this layer are not materialized as tables or views and do not form part of the production transformation pipeline. Instead, they serve as a workspace for analyzing business trends, validating model outputs, testing hypotheses, and performing one-time analytical studies. This approach keeps exploratory analysis separate from production data models while maintaining version control and reproducibility within the dbt project.
```

#### Q - What are the **Naming Conventions** ?

```
Naming Conventions:

Snake case naming conventions are used across all models, columns, and database objects to ensure consistency and readability. Models follow DBT standard prefixes based on their purpose, including stg_ for staging models, int_ for intermediate models, fct_ for fact tables, and dim_ for dimension tables. Names are written in lowercase with words separated by underscores (e.g., fct_orders, dim_customers, customer_id, order_date) to maintain a clear, predictable, and scalable naming standard throughout the project.
```

#### Q - What are the **Snapshots Strategy** ? 

```
Snapshot Strategy:

dbt snapshots are used to capture historical changes in dimension data such as customers and products. This enables Slowly Changing Dimension (SCD Type 2) tracking and allows historical analysis of attribute changes over time.
```

#### Q - What are the **Seed Strategy** ? 

```
Seed Strategy:

dbt seeds are used to manage small static reference datasets directly within the project. These datasets are version-controlled in Git and loaded into the warehouse using dbt seed. Typical use cases include country mappings, product categories, status lookups, business rules, and other reference data required by transformations.
```

#### Q - What are the **Macros Strategy** ? 

```
Macro Strategy:

Reusable SQL logic is implemented through dbt macros to reduce code duplication and improve maintainability. Common transformation patterns, surrogate key generation, and utility functions are centralized in macros for consistent implementation across models.
```

#### Q - What are the **Analysis Strategy** ? 


#### Q - What are the **Data Quality Governance Strategy** ? 

```
Data Quality Governance:

Data quality is enforced through automated testing, source validation, and business rule checks. Critical failures such as duplicate primary keys, null business keys, or broken relationships are treated as blocking issues and must be resolved before deployment.
```

#### Q - What are the **Testing Strategy** ? 

```
Testing Strategy:

A comprehensive testing strategy is implemented using Generic Tests, Singular Tests, and Unit Tests. Generic tests are used to validate data quality rules such as uniqueness, null checks, referential integrity, and accepted values. Singular tests are used for custom business validations that cannot be covered by standard tests, ensuring that domain-specific requirements are met. Unit tests are applied to validate transformation logic by comparing expected outputs against controlled input datasets. Together, these testing approaches help ensure the accuracy, consistency, and reliability of data throughout the transformation pipeline.
```

#### Q - What are the **Documentation** Strategy ?

```
Documentation Strategy:

Documentation is maintained using dbt Docs, detailed model descriptions, and project-level README.md files. Each model, column, and data asset is documented to provide clear business and technical context, while README files describe project structure, architecture, data flow, and implementation details. The generated dbt documentation serves as a centralized source for lineage, dependencies, and metadata, making the project easier to understand, maintain, and onboard new contributors.
```

---

### **6. Performance & Scalability**

- **Incremental Models** ? 

```
Incremental Models

Incremental loading is applied to large transactional fact tables to reduce processing time and improve pipeline efficiency. New and updated records are loaded using the incremental_strategy: merge approach, allowing the warehouse to process only changed data instead of rebuilding entire datasets during each run.
```

- **Partitioning/Clustering** ? 

```
Partitioning / Clustering

Query performance is optimized by partitioning large tables on date-based columns such as order_date and clustering on frequently filtered or joined keys such as customer_id, product_id, and order_id. This reduces the amount of data scanned and improves query execution performance for analytical workloads.
```

- **Expensive Transformations** ? 

```
Expensive Transformations

The most resource-intensive transformations involve large-scale joins between transactional fact tables and multiple dimension tables, along with aggregations used for KPI and reporting models. These transformations are managed in the Intermediate layer to minimize repeated computations and improve overall pipeline performance.
```

---

### **7. CI/CD & Deployment**

#### Q - What are the **Git Strategy** ? 

```
Git Strategy:

The project is managed using Git and GitHub with a dedicated dbt_branch development workflow. All DBT development, model changes, testing, and documentation updates are performed within feature branches before being merged into the main branch through pull requests. This approach enables version control, code review, collaboration, and safe deployment of changes while maintaining a stable production codebase.
```

#### Q - Which are use for **CI/CD Pipeline** ? 

```
CI/CD Pipeline:
The project uses GitHub Actions to automate continuous integration and deployment workflows. Pull requests automatically trigger validation steps such as SQL compilation, model testing, and code quality checks to ensure changes meet project standards before merging. This automated pipeline improves reliability, reduces manual effort, and helps maintain a consistent and production-ready DBT codebase.
```

---

**“The natural state of things is not progress, but decay. Progress requires constant effort.”**

**Author : Ritik__**