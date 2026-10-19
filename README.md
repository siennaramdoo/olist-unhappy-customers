# Predicting unhappy customers in online orders

**Question:** which orders end with an unhappy customer (a 1 or 2 star review), and can we predict them when the order is delivered, before the review is written?

The project uses SQL to combine the data and Python to build a machine learning model.

## Key findings

- **Late delivery is the biggest cause of unhappy customers.** Orders that arrive early have about 9% unhappy customers. That rises to 32% at 1–3 days late and about 80% at 8 or more days late.
- **The model catches about half of unhappy customers** before they review (recall 0.54, ROC-AUC 0.75), which is about three times better than picking orders at random.
- **Orders with several items are riskier,** probably because they often arrive in separate deliveries from different sellers.

## Project structure

| Folder | What's in it |
|---|---|
| `01_sql/` | Loads the raw data into SQLite, builds one row per delivered order, and answers business questions in SQL |
| `02_python/` | Model notebook: preprocessing, train/test split, logistic regression and random forest, evaluation |
| `data/processed/` | Outputs from each stage |

## My own code samples

These files were written by only me:

- [`01_sql/my_query.sql`](01_sql/my_query.sql): average review score by state, using joins, `GROUP BY` and `HAVING`
- [`02_python/my_model.py`](02_python/my_model.py): a logistic regression model with a train/test split, a scaling pipeline and evaluation metrics

## Use of AI

I planned this project and built the main pipeline with help from an AI assistant (Claude). I used it to explain concepts, generate parts and debug code, and check my work. I wrote the code samples listed above entirely myself.

## Data

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce): about 100,000 real, anonymised orders from 2016 to 2018. Licence: CC BY-NC-SA 4.0. Credit to Olist.

The raw data is not included in this repository. To run the project, download it from Kaggle and unzip the CSV files into `data/raw/`.

## How to run

```
pip install -r requirements.txt
python 01_sql/load_data.py
python 01_sql/export_dataset.py
python 01_sql/run_queries.py
```

Then open `02_python/modelling.ipynb` in Jupyter and run all cells.

## Limitations and next steps

- The data comes from one Brazilian marketplace, so the results may not apply elsewhere.
- The model only uses order and delivery data. Product quality, another likely cause of bad reviews, isn't included.
- The review text could be analysed with NLP to understand *why* customers are unhappy.
