# Naming convention

## Table of content
1.  General Principles
2.  Table Naming Convention
    *  Bronze Rules
    *  Silver Rules
    *  Gold Rules
3.  Column Naming Convention
    *  Surrogate Keys
    *  Technical Columns
4.  Stored Procedure

### 1.  General Principles
+  **Naming conventions:** Use snake_case with lowercase letters and underscores (_) to separate words
+  **Language:** Use English for all names.
+  **Avoid Reserved Words:** Do not use SQL reserved words as object names e.g table

### 2.  Table Naming Convention
+ Bronze Rules
    +  All names must start with the source system name, and table names must match their original names without renaming
    +  Format <sourcesystem>_<entity>
        *  <sourcesystem>: Name of the source system (eg. crm, erp)
        *  <entity>: Exact table name from the source system
        *  Example: crm_customer_info &rarr customer information from the CRM system

+  Silver Rules
    +  All names must start with the source system name, and table names must match their original names without renaming
    +  Format <sourcesystem>_<entity>
        *  <sourcesystem>: Name of the source system (eg. crm, erp)
        *  <entity>: Exact table name from the source system
        *  Example: crm_customer_info &rarr customer information from the CRM system

+  Gold Rules
    +  All names must use meaningful business-aligned names for tables, starting with category prefix
    +  Format <category>_<entity>
        *  <category>: Describes the role of the table such as dim (dimension) or fact (fact table)
        *  <entity>: Descriptive name of the table aligned with the business domain (e.g customers, products, sales
        *  Examples: 
            -  dim_customers &rarr Dimension table for customer data
            -  fact_sales &rarr Fact table containing sales transactions

#### Glossary of Category Patterns
|Pattern	|Meaning	|Example(s)|
|---|---|---|
dim_	|Dimension table	| dim_customers, dim_products
fact_	|Fact table	|fact_sales
agg_	|Aggregated table |	Agg_customers, agg_sales_monthly

### 3.  Column Naming Convention
#### Surrogate Keys
+  All primary keys in dimension tables must use the suffix _key
+  <table_name>_key
    *  <table_name>: Refers to the name of the table or entity the key belongs to
    *  _key: A suffix indicating that this column is a surrogate key
    *  	Example: customer_key  surrogate key in the dim_customers table

#### Technical Columns
a.	All technical columns must start with the prefix dwh_, followed by a descriptive name indicating the column’s purpose
b.	dwh_<column_name>
•	dwh_: Prefix exclusively for system-generated metadata
•	<column_name>: Descriptive name indicating the column’s purpose
•	Example: dwh_load_date  system-generated column used to store the date when the record was loaded

### 4.  Stored Procedure
+  All stored procedure used for loading data must follow the naming pattern: load_<layer>
+  <layer>: Represents the layer being loaded such as bronze, silver, or gold
+  Example: 
    *  load_bronze &rarr Stored Procedure for loading data into the Bronze layer
    *  load_silver &rarr Stored Procedure for loading data into the Silver layer
