"""Run each query in business_queries.sql and print the results as tables."""

import sqlite3
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parent.parent
DB_PATH = ROOT / "data" / "olist.db"
SQL_PATH = Path(__file__).resolve().parent / "business_queries.sql"

conn = sqlite3.connect(DB_PATH)

# Queries are separated by ";" and each starts with a "-- Q..." title comment
for query in SQL_PATH.read_text().split(";"):
    if not query.strip():
        continue
    title = query.strip().splitlines()[0].removeprefix("-- ")
    print(f"\n{title}\n")
    print(pd.read_sql_query(query, conn).to_string(index=False))

conn.close()
