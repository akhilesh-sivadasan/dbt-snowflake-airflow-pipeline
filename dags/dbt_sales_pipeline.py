from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

# Path to your dbt project
DBT_PROJECT_DIR = '/Users/akhileshsivadasan/portfolio/dbt-snowflake-pipeline/sales_analytics'

default_args = {
    'owner': 'akhilesh',
    'depends_on_past': False,
    'start_date': datetime(2025, 1, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'dbt_sales_analytics_pipeline',
    default_args=default_args,
    description='Orchestrates DBT pipeline: seed, run, test',
    schedule='@daily',
    catchup=False,
    tags=['dbt', 'snowflake', 'sales_analytics'],
) as dag:

    # Step 1: Load raw data into Snowflake
    dbt_seed = BashOperator(
        task_id='dbt_seed',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt seed --profiles-dir ~/.dbt',
    )

    # Step 2: Run staging models
    dbt_run_staging = BashOperator(
        task_id='dbt_run_staging',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt run --select staging --profiles-dir ~/.dbt',
    )

    # Step 3: Run intermediate models
    dbt_run_intermediate = BashOperator(
        task_id='dbt_run_intermediate',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt run --select intermediate --profiles-dir ~/.dbt',
    )

    # Step 4: Run mart models
    dbt_run_marts = BashOperator(
        task_id='dbt_run_marts',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt run --select marts --profiles-dir ~/.dbt',
    )

    # Step 5: Run all tests
    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt test --profiles-dir ~/.dbt',
    )

    # Step 6: Generate documentation
    dbt_docs = BashOperator(
        task_id='dbt_docs_generate',
        bash_command=f'cd {DBT_PROJECT_DIR} && dbt docs generate --profiles-dir ~/.dbt',
    )

    # Define execution order
    dbt_seed >> dbt_run_staging >> dbt_run_intermediate >> dbt_run_marts >> dbt_test >> dbt_docs
