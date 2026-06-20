import os
import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus

# SQL Server connection
server = os.getenv("DBT_SQLSERVER_HOST", "localhost")
port = os.getenv("DBT_SQLSERVER_PORT", "1433")
database = os.getenv("DBT_SQLSERVER_DATABASE", "RetailDB")
user = os.getenv("DBT_SQLSERVER_USER", "sa")
password = os.getenv("DBT_SQLSERVER_PASSWORD")

conn_str = (
    f"DRIVER={{ODBC Driver 18 for SQL Server}};"
    f"SERVER={server},{port};"
    f"DATABASE={database};"
    f"UID={user};"
    f"PWD={password};"
    "TrustServerCertificate=yes;"
)

engine = create_engine(
    f"mssql+pyodbc:///?odbc_connect={quote_plus(conn_str)}"
)

BASE_DIR = "scripts/raw_dataset/csv_data_file"

FILES = {
    "raw_customers.csv": "customers",
    "raw_employees.csv": "employees",
    "raw_inventory_snapshots.csv": "inventory_snapshots",
    "raw_products.csv": "products",
    "raw_returns.csv": "returns",
    "raw_reviews.csv": "reviews",
    "raw_sales_transactions.csv": "sales_transactions",
    "raw_stores.csv": "stores",
}

for csv_file, table_name in FILES.items():
    path = os.path.join(BASE_DIR, csv_file)

    print(f"Loading {csv_file} -> bronze.{table_name}")

    df = pd.read_csv(path)

    df.to_sql(
        name=table_name,
        con=engine,
        schema="bronze",
        if_exists="append",
        index=False,
        chunksize=100,
    )

    print(f"Loaded {len(df)} rows into bronze.{table_name}")

print("Bronze layer load completed successfully.")