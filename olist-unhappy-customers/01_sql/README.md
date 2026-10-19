# Stage 1: SQL

Combines the raw Olist tables into one clean dataset, one row per delivered order, using SQLite.

## Files

| File | What it does |
|---|---|
| `load_data.py` | Loads the raw CSVs from `data/raw/` into a SQLite database, `data/olist.db` |
| `build_dataset.sql` | Joins orders, reviews, items and customers, and creates the features and the `unhappy` target |
| `export_dataset.py` | Runs `build_dataset.sql`, saves the result to `data/processed/orders_reviews.csv`, and also stores it as the `orders_reviews` table |
| `business_queries.sql` | Three business questions answered in SQL |
| `run_queries.py` | Runs the business queries and prints the results |

## How to run

From the project folder:

```
python 01_sql/load_data.py
python 01_sql/export_dataset.py
python 01_sql/run_queries.py
```

## How the dataset is built (`build_dataset.sql`)

- **CTE with a window function:** some orders have more than one review, so `ROW_NUMBER()` keeps only the latest one.
- **CTE with aggregation:** `order_items` has one row per item, so `GROUP BY order_id` turns it into one row per order with the item count, seller count, total price and total freight.
- **INNER JOIN** to reviews and customers, because every row needs a review score and a state.
- **LEFT JOIN** to the item totals, so no order is dropped.
- **Date arithmetic:** `julianday()` gives the delivery time and the number of days early or late compared with the promised date.
- **Target:** `unhappy = 1` when the review score is 1 or 2.
- **No leakage:** every feature is known by the time the order is delivered, before the review is written.

Result: 95,824 delivered orders. 12.8% have an unhappy customer and 6.7% were delivered late.

## What the business queries show

1. **Lateness drives bad reviews.** Orders that arrive early have about 9–11% unhappy customers. That jumps to 32% at 1–3 days late and about 80% at 8 or more days late.
2. **Late-delivery rates vary a lot by state.** North-eastern states such as MA (17%) and CE (14%), plus RJ (12%), have the highest late rates. Their unhappy rates are also above the 12.8% average.
3. **Problems come in waves.** Late deliveries jumped in November 2017 (Black Friday) and in February–March 2018 (14–19% late), and the unhappy rate rose with them each time.
