# Stage 2: Python modelling

`modelling.ipynb` predicts which delivered orders will get a 1 or 2 star review, using scikit-learn.

## Steps in the notebook

1. **Explore:** shape, data types, missing values and class balance (12.8% unhappy)
2. **Features:** order size, price, freight, freight share, delivery time, days late, state and weekday. `review_score` is left out because it is the answer (leakage).
3. **Split:** 80/20 train/test split, stratified so both sets have 12.8% unhappy, done *before* any preprocessing
4. **Preprocess:** a `ColumnTransformer` with `StandardScaler` for numbers and `OneHotEncoder` for categories, inside a `Pipeline`
5. **Models:** logistic regression (baseline) and random forest, both with `class_weight="balanced"`, compared with 5-fold cross-validation on the training set
6. **Evaluate on the test set:** confusion matrix, precision, recall, F1, ROC-AUC and ROC curve
7. **Feature importance:** permutation importance on the test set
8. **Export:** predictions, importances and metrics are saved to `data/processed/`

## Results (test set)

| Model | Accuracy | Precision | Recall | F1 | ROC-AUC |
|---|---|---|---|---|---|
| Logistic regression | 0.833 | 0.385 | 0.513 | 0.440 | 0.743 |
| Random forest | 0.828 | 0.379 | 0.537 | 0.444 | 0.746 |

Accuracy is shown only to make a point: a model that always predicts "happy" would score 87% and be useless. Recall and ROC-AUC are the metrics that matter here.

## How to run

```
cd 02_python
python -m jupyter notebook modelling.ipynb
```

Then choose **Run → Run All Cells**. It takes about 1 to 2 minutes, mostly for the random forest cross-validation.
