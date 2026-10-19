"""Load the Olist CSVs from data/raw into a SQLite database (data/olist.db)."""

import sqlite3
from pathlib import Path

import pandas as pd

# Paths are built from this file's location, so the script works from any folder
ROOT = Path(__file__).resolve().parent.parent
RAW_DIR = ROOT / "data" / "raw"
DB_PATH = ROOT / "data" / "olist.db"

# Geolocation is large (61 MB) and not used in this project
SKIP = {"geolocation"}

conn = sqlite3.connect(DB_PATH)

for csv_path in sorted(RAW_DIR.glob("*.csv")):
    # olist_order_reviews_dataset.csv -> order_reviews
    table = csv_path.stem.removeprefix("olist_").removesuffix("_dataset")
    if table in SKIP:
        continue

    df = pd.read_csv(csv_path)
    # "replace" means the script can be re-run safely without duplicating rows
    df.to_sql(table, conn, if_exists="replace", index=False)
    print(f"{table:<35} {len(df):>8,} rows")

conn.close()
print(f"\nDatabase saved to {DB_PATH}")
