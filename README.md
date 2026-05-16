# End-to-End Analytics Engineering Pipeline: Snowflake + dbt Core + Apache Airflow

An enterprise-grade data transformation and orchestration pipeline that processes raw e-commerce data, builds an optimized dimensional model (Star Schema) in Snowflake, executes strict data quality assertions via dbt tests, and is fully orchestrated by Apache Airflow.

-----

## 🏗️ Architecture & Data Flow

1. **Extraction & Loading:** Raw transactional and dimensional data source files are managed as seeds within dbt.
1. **Storage & Data Warehouse:** Formatted datasets are provisioned directly into **Snowflake** inside dedicated environments (RAW, STAGING, INTERMEDIATE, MARTS).
1. **Data Transformation (dbt Core):**
- **Staging Layer:** Cleans, casts types, and renames raw column names into consistent conventions.
- **Intermediate Layer:** Handles complex business logic, row joins, and intermediate state management.
- **Marts Layer:** Produces optimized fct_ (Fact) and dim_ (Dimension) tables using a modern Star Schema methodology for high-performance BI tool consumption.
1. **Data Quality Assurance:** Structural constraints (uniqueness, non-nullability, referential integrity) are asserted programmatically across every stage using dbt test suites.
1. **Orchestration (Apache Airflow):** The entire workflow is controlled dynamically via a Python DAG executing task blocks via linear dependencies.

-----

## 📊 Orchestration Topology

The linear dependency map executed seamlessly across the modern Airflow control plane:

<img width="1466" height="828" alt="to lo lola le" src="https://github.com/user-attachments/assets/05ef9d19-5f1e-487a-b0f7-47ede68c0d9a" />

### 🌲 Internal dbt Model Lineage

The internal data dependencies, staging schemas, intermediate joins, and final star-schema dimensional transformations managed inside Snowflake:

<img width="1171" height="733" alt="Pasted Graphic 1" src="https://github.com/user-attachments/assets/ecf1166d-1b19-4a5e-a30b-8aff0e79e0d0" />


-----

## 🛠️ Tech Stack & Prerequisites

- **Data Warehouse:** Snowflake
- **Transformation Engine:** dbt Core (v1.x)
- **Workflow Management:** Apache Airflow (v3.0.0+)
- **Language/Environment:** Python 3.11+ / macOS Virtual Environment (venv)

-----

## 🚀 Deployment & Local Execution

### 1. Repository Configuration

Clone the repository and spin up your isolated virtual environment:

```bash
git clone https://github.com/akhilesh-sivadasan/dbt-snowflake-airflow-pipeline.git
cd dbt-snowflake-airflow-pipeline
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 2. Database Initialization

Execute the foundational schema and environment structure in your Snowflake workspace using:

```sql
CREATE WAREHOUSE IF NOT EXISTS DBT_WH WITH WAREHOUSE_SIZE = 'X-SMALL';
CREATE DATABASE IF NOT EXISTS SALES_ANALYTICS;
CREATE SCHEMA IF NOT EXISTS SALES_ANALYTICS.RAW;
CREATE SCHEMA IF NOT EXISTS SALES_ANALYTICS.STAGING;
CREATE SCHEMA IF NOT EXISTS SALES_ANALYTICS.INTERMEDIATE;
CREATE SCHEMA IF NOT EXISTS SALES_ANALYTICS.MARTS;
```

### 3. Workflow Orchestration (Airflow Launch)

Initialize your local scheduler instance to pick up the source code definition sitting in the ~/airflow/dags/ folder:

```bash
export AIRFLOW_HOME=~/airflow
airflow standalone
```

Navigate to http://localhost:8080, fetch your generated credentials via simple_auth_manager_passwords.json.generated, unpause dbt_sales_analytics_pipeline, and trigger the run.

-----

## 🛡️ Data Quality & Idempotency Edge-Cases

During deployment processing, data anomaly protections were put to the test when an automatic table duplication glitch on upstream seed sources forced data row multipliers to throw 69,441 duplicates into primary keys.

**Resolution Implementation:**
The data infrastructure enforces complete idempotency. By intercepting data flows and triggering targeted schema cleanses, the model dropped corrupted configurations out of the data layers cleanly:

```bash
dbt seed --full-refresh
```

Downstream lineage dependencies within the Airflow DAG automatically cleared and recalculated states across the multi-layered dependencies, validating 100% structural compliance across uniqueness checks without data loss.

```text
Done. PASS=24 WARN=0 ERROR=0 SKIP=0 TOTAL=24
```
