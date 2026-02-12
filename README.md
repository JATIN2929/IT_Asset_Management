# IT_Asset_Management

## 📌 Overview

This project demonstrates an **end-to-end analytics solution for IT Asset Management** using a **data warehouse approach**. It is designed to track the complete lifecycle of IT assets (primarily laptops and accessories) and enable **operational reporting, audit compliance, cost tracking, and analytical insights**.

The solution follows modern **data engineering best practices**, including:

* Bronze → Silver → Gold data layering
* Snowflake schema–based dimensional modeling
* SQL-based transformations
* Containerized environment using Docker (GitHub Codespaces ready)

---

## 📘 Project Documentation (Notion)

Detailed project documentation, data model explanations, business logic, and design decisions are maintained in Notion.

🔗 **Notion Workspace:**
[https://opposite-whitefish-f16.notion.site/Asset-Management-2f00875cde048029abfae22f9a0b8c7e?pvs=74](https://opposite-whitefish-f16.notion.site/Asset-Management-2f00875cde048029abfae22f9a0b8c7e?pvs=74)

This documentation includes:

* Detailed requirement analysis
* Data architecture & schema explanations
* Business rules and assumptions
* Asset lifecycle workflows and scenarios
* Ongoing design notes and future improvements

---

## 🎯 Objective

The objective of this project is to design and implement an **IT Asset Management Data Mart** that accurately tracks the full lifecycle of IT assets across an organization and supports data-driven decision-making.

---

## 🧩 Business Problem

Organizations managing thousands of employees and IT assets face challenges such as:

* No single source of truth for asset allocation and availability
* Difficulty tracking complete asset history (issue, breakfix, handover, exit)
* Inconsistent and unstructured accessory data
* Limited visibility into asset cost, lifecycle, and departmental impact
* High manual effort for audits, reconciliation, and reporting

This project addresses these challenges by creating a **structured, scalable, and analytics-ready data model**.

---

## ⚙️ Functional Requirements

### 1️⃣ Employee Information Management

* Centralized employee dimension
* Staff ID, department, role, cost center, employment status
* Asset-to-employee mapping

### 2️⃣ Asset Master Management

* Standardized master data for laptops and accessories
* Manufacturing date, warranty, service cost, EOL date

### 3️⃣ Asset Allocation Tracking

* Asset issuance details (serial number, allocation date, request ID)
* Current allocation status tracking

### 4️⃣ Store Inventory Management

* Track stock, issued, and disposed assets
* Ensure availability for breakfix and replacement scenarios

### 5️⃣ Event-Based Asset Lifecycle Tracking

* Breakfix and replacements
* Temporary and permanent handovers
* New joiner allocations
* Transfers and exits
* Historical traceability of old and new asset serial numbers

### 6️⃣ Accessory Management

* Normalize multi-value accessory data
* Track issued, temporary, and handed-over accessories

### 7️⃣ Damage & Missing Asset Tracking

* Capture damage events with cost attribution
* Track missing assets and recovery costs

### 8️⃣ Daily Asset Snapshot

* Consolidated daily fact table
* Enables trend analysis, audits, and operational reporting

---

## 🏗️ Data Architecture

The project follows a **layered data architecture**:

### 🔹 Bronze Layer

* Raw, unstructured source-system data

### 🔹 Silver Layer

* Cleaned, standardized, and normalized data

### 🔹 Gold Layer

* Business-ready fact and dimension tables
* Snowflake schema design
* Event-level granularity for fact tables

---

## 📊 Analytical & Reporting Capabilities

The data model supports:

* Asset utilization by department and role
* Breakfix frequency and replacement cost analysis
* Inventory aging and end-of-life tracking
* Damage and missing asset cost attribution
* Employee-wise and department-wise asset history
* Audit-ready reporting with full traceability

Designed to integrate seamlessly with **Power BI / Tableau**.

---

## 🐳 Docker Setup (GitHub Codespaces Ready)

This project is containerized using Docker to ensure **consistent execution across environments**.

### 🔧 Prerequisites

* Docker installed
* Docker Compose
* GitHub Codespaces (optional)

### ▶️ Start Services

```bash
docker-compose up -d
```

### ⏹ Stop Services

```bash
docker-compose down
```

### 🧠 Why Docker?

* Eliminates environment dependency issues
* Easy setup for recruiters and reviewers
* Production-like local development
* Reproducible data engineering workflow

---

## 📁 Project Structure

```
IT_Asset_Management/
│
├── datasets/                # Raw and processed datasets
├── scripts/                 # SQL transformation logic
├── project_initialization/  # Database & schema setup
├── dataset_architecture/    # Data model & table design
├── project_documentation/  # Detailed project documentation & design notes
├── docs/                    # Documentation
├── Dockerfile               # Docker image definition
├── docker-compose.yml       # Multi-container setup
└── README.md
```

---

## ▶️ How to Run Sample Analysis

This section explains how to quickly run and validate sample analysis using the existing SQL scripts and Docker setup.

### 1️⃣ Start the Docker Environment

Ensure Docker and Docker Compose are running, then start all services:

```bash
docker-compose up -d
```

Verify running containers:

```bash
docker ps
```

---

### 2️⃣ Connect to the Database

Use any SQL client (Azure Data Studio / DBeaver / SSMS) and connect using:

* **Host:** `localhost`
* **Port:** `1433`
* **Username:** `sa`
* **Password:** As defined in `docker-compose.yml`

---

### 3️⃣ Initialize Database & Schemas

Run the scripts inside the `project_initialization/` folder in sequence:

1. Create database
2. Create schemas (Bronze, Silver, Gold)
3. Create base tables

This sets up the foundational data warehouse structure.

---

### 4️⃣ Load Sample Data (Bronze Layer)

Execute SQL scripts from the `datasets/` folder to load raw data into **Bronze** tables.

These tables represent uncleaned, source-system data.

---

### 5️⃣ Run Transformations (Silver → Gold)

Execute SQL scripts from the `scripts/` folder:

* Bronze → Silver: data cleaning & normalization
* Silver → Gold: fact & dimension creation

This produces analytics-ready tables following a Snowflake schema.

---

### 6️⃣ Validate Sample Analysis

Run sample analytical queries such as:

* Asset utilization by department
* Breakfix count per asset type
* Inventory aging & EOL tracking
* Employee-wise asset history

Successful query results confirm the pipeline is working correctly.

---

### 7️⃣ (Optional) Connect BI Tool

Connect Power BI / Tableau to the **Gold layer** tables to build dashboards and reports.

---

## 🚀 Future Enhancements (Roadmap)

Planned improvements for next iterations:

* ✅ Automated ETL orchestration (Airflow / Prefect)
* ✅ Incremental data loading & SCD handling
* ✅ Data quality checks & validation rules
* ✅ Role-based access control (RBAC)
* ✅ Power BI / Tableau dashboard screenshots
* ✅ CI/CD pipeline for SQL validation
* ✅ Support for additional asset types (mobiles, monitors)
* ✅ Cloud deployment (Azure / AWS)

---

## 🧠 Skills Demonstrated

* Data Warehouse Design (Snowflake Schema)
* SQL (T-SQL)
* Data Modeling & Normalization
* Analytics Engineering Concepts
* Docker & Containerization
* GitHub Codespaces
* Business-to-Technical Translation

---

## 📜 License

This project is licensed under the **MIT License**.

---

## ⭐ Final Note

This project is built with **real-world enterprise asset management scenarios** in mind and is designed to reflect **production-grade data engineering practices**.
