# **Naming Conventions**

This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the data warehouse.

## **Table of Contents**

1. [General Principles](https://www.notion.so/Define-Project-Naming-Conventions-2e10875cde04807894cfcec6b63ce87b?pvs=21)
2. [Table Naming Conventions](https://www.notion.so/Define-Project-Naming-Conventions-2e10875cde04807894cfcec6b63ce87b?pvs=21)
    - [Bronze Rules](https://www.notion.so/Define-Project-Naming-Conventions-2e10875cde04807894cfcec6b63ce87b?pvs=21)
    - [Silver Rules](https://www.notion.so/Define-Project-Naming-Conventions-2e10875cde04807894cfcec6b63ce87b?pvs=21)
    - [Gold Rules](https://www.notion.so/Define-Project-Naming-Conventions-2e10875cde04807894cfcec6b63ce87b?pvs=21)
3. [Column Naming Conventions](https://www.notion.so/Define-Project-Naming-Conventions-2e10875cde04807894cfcec6b63ce87b?pvs=21)
    - [Surrogate Keys](https://www.notion.so/Define-Project-Naming-Conventions-2e10875cde04807894cfcec6b63ce87b?pvs=21)
    - [Technical Columns](https://www.notion.so/Define-Project-Naming-Conventions-2e10875cde04807894cfcec6b63ce87b?pvs=21)
4. [Stored Procedure](https://www.notion.so/Define-Project-Naming-Conventions-2e10875cde04807894cfcec6b63ce87b?pvs=21)

---

## **General Principles**

- **Naming Conventions**: Use snake_case, with lowercase letters and underscores (`_`) to separate words.
- **Language**: Use English for all names.
- **Avoid Reserved Words**: Do not use SQL reserved words as object names.

## **Table Naming Conventions**

### **Bronze Rules**

- All names must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**
    - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
    - `<entity>`: Exact table name from the source system.
    - Example: `user_table` → Customer information from the CRM system.

### **Silver Rules**

- All names must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**
    - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
    - `<entity>`: Exact table name from the source system.
    - Example: `temporary_asset_table` → Customer information from the CRM system.

### **Gold Rules**

- All names must use meaningful, business-aligned names for tables, starting with the category prefix.
- **`<category>_<entity>`**
    - `<category>`: Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).
    - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., `customers`, `products`, `sales`).
    - Examples:
        - `dim_user_table` → Dimension table for customer data.
        - `fact_user_info_table` → Fact table containing sales transactions.

### **Glossary of Category Patterns**

| Pattern | Meaning | Example(s) |
| --- | --- | --- |
| `dim_` | Dimension table | `dim_user_table` |
| `fact_` | Fact table | `fact_user_info_table` |
| `report_` | Report table | `report_user`, `report_daily_asset_management` |

## **Column Naming Conventions**

### **Surrogate Keys**

- All primary keys in dimension tables must use the suffix `_key`.
- **`<table_name>_key`**
    - `<table_name>`: Refers to the name of the table or entity the key belongs to.
    - `_key`: A suffix indicating that this column is a surrogate key.
    - Example: `staff_id` → Surrogate key in the `dim_user_table` table.

### **Technical Columns**

- All technical columns must start with the prefix `dwh_`, followed by a descriptive name indicating the column's purpose.
- **`dwh_<column_name>`**
    - `dwh`: Prefix exclusively for system-generated metadata.
    - `<column_name>`: Descriptive name indicating the column's purpose.
    - Example: `dwh_load_date` → System-generated column used to store the date when the record was loaded.

## **Stored Procedure**

- All stored procedures used for loading data must follow the naming pattern:
- **`load_<layer>`**.
    - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
    - Example:
        - `load_bronze` → Stored procedure for loading data into the Bronze layer.
        - `load_silver` → Stored procedure for loading data into the Silver layer.
