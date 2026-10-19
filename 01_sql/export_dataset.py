"""Run build_dataset.sql against olist.db and save the result as a CSV for the Python stage."""

import sqlite3
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parent.parent
DB_PATH = ROOT / "data" / "olist.db"
SQL_PATH = Path(__file__).resolve().parent / "build_dataset.sql"
OUT_PATH = ROOT / "data" / "processed" / "orders_reviews.csv"

conn = sqlite3.connect(DB_PATH)
df = pd.read_sql_query(SQL_PATH.read_text(), conn)
# Also save it as a table so business_queries.sql can use it
df.to_sql("orders_reviews", conn, if_exists="replace", index=False)
conn.close()

df.to_csv(OUT_PATH, index=False)

print(f"{len(df):,} rows, {df.shape[1]} columns saved to {OUT_PATH}")
print(f"Unhappy customers: {df['unhappy'].mean():.1%}")
print(f"Late deliveries:   {df['is_late'].mean():.1%}")
