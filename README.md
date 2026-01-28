# IT_Asset_Management
This project demonstrates an end-to-end analytics solution for managing IT assets and analyzing data using a data warehouse approach.  The solution includes data modeling, SQL-based transformations, and BI dashboards to support data-driven decision-making.

## **Requirement**

The objective of this project is to design and implement an **end-to-end IT Asset Management Data Mart** that accurately tracks the **complete lifecycle of IT assets** (primarily laptops and accessories) across an organization. The system is built to support **operational reporting, audit compliance, cost tracking, and analytical insights** using a **Snowflake schema–based data warehouse design**.

### **Business Problem**

The organization manages thousands of employees and IT assets, resulting in challenges such as:

- Lack of a **single source of truth** for asset allocation and availability
- Difficulty tracking **asset history** (issuance, breakfix, temporary handover, damage, missing assets)
- Inconsistent and unstructured accessory data
- Limited visibility into **asset costs, lifecycle status, and department-wise impact**
- Manual effort required for audits, breakfix analysis, and inventory reconciliation

This project addresses these challenges by building a structured, scalable, and analytics-ready data model.

---

### **Functional Requirements**

1. **Employee Information Management**
    - Maintain a centralized dimension for employee details including staff ID, role, department, cost center, and employment status.
    - Support mapping of assets to active employees.
2. **Asset Master Management**
    - Store standardized master data for all IT assets including laptops and accessories.
    - Track asset attributes such as product name, manufacturing date, warranty period, service cost, and end-of-life date.
3. **Asset Allocation Tracking**
    - Capture asset issuance details including serial number, allocation date, request ID, and cost center.
    - Maintain current allocation status for each asset.
4. **Store Inventory Management**
    - Track real-time status of assets available in store (stock, issued, disposed).
    - Ensure store stock is always greater than issued assets to support breakfix and replacement scenarios.
5. **Event-Based Asset Lifecycle Tracking**
    - Record all asset lifecycle events including:
        - Breakfix and replacements
        - Temporary asset handovers
        - Permanent handovers
        - New joiner allocations
        - Transfers and exits
    - Maintain historical traceability of old and new asset serial numbers.
6. **Accessory Management**
    - Handle multi-value accessory data by splitting and normalizing accessories into analyzable rows.
    - Track issued, temporary, and handed-over accessories separately.
7. **Damage and Missing Asset Tracking**
    - Capture physical damage events for laptops, including damage type and associated cost codes.
    - Track missing assets and map recovery costs to the respective department or cost center.
8. **Daily Asset Management Snapshot**
    - Create a consolidated daily transactional fact table capturing all asset-related activities.
    - Enable trend analysis, operational reporting, and audit readiness.

---

### **Data Architecture Requirements**

- Implement a **Bronze → Silver → Gold** data layering approach:
    - **Bronze Layer**: Raw, unstructured, source-system data
    - **Silver Layer**: Cleaned, standardized, and normalized data
    - **Gold Layer**: Business-ready fact and dimension tables
- Use **Snowflake schema** to reduce redundancy and support scalable analytics.
- Ensure proper grain definition for all fact tables (event-level granularity).

---

### **Analytical & Reporting Requirements**

The data model should enable:

- Asset utilization analysis by department and role
- Breakfix frequency and replacement cost analysis
- Inventory aging and end-of-life tracking
- Damage and missing asset cost attribution
- Employee-wise and department-wise asset history
- Audit-ready reporting with full asset traceability

---

### **Non-Functional Requirements**

- Scalable to handle **thousands of employees and assets**
- Designed for **future BI tools** (Power BI / Tableau)
- Optimized for query performance and data consistency
- Easy to extend with new asset types or lifecycle events
