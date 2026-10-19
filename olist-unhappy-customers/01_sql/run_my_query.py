"""Run my_query.sql against olist.db and print the result."""

import sqlite3
from pathlib import Path

import pandas as pd

HERE = Path(__file__).resolve().parent
DB_PATH = HERE.parent / "data" / "olist.db"

conn = sqlite3.connect(DB_PATH)
query = (HERE / "my_query.sql").read_text()
print(pd.read_sql_query(query, conn).to_string(index=False))
conn.close()
