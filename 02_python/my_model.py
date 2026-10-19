import pandas as pd
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import recall_score, precision_score, roc_auc_score

# Load the data
df = pd.read_csv(r"..\data\processed\orders_reviews.csv")

print(df.shape)       

X = df[["days_late", "delivery_days", "n_items", "total_freight"]]
y = df["unhappy"]

print(X.shape, y.mean())
# Split before training so the test set stays unseen
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)

print(len(X_train), len(X_test))
print(y_train.mean(), y_test.mean())
model = Pipeline([
    ("scale", StandardScaler()),
    ("logreg", LogisticRegression(class_weight="balanced")),
])

model.fit(X_train, y_train)
print("Model trained")
# Evaluate on the test set
predictions = model.predict(X_test)
probabilities = model.predict_proba(X_test)[:, 1]

print(f"Recall:    {recall_score(y_test, predictions):.3f}")
print(f"Precision: {precision_score(y_test, predictions):.3f}")
print(f"ROC-AUC:   {roc_auc_score(y_test, probabilities):.3f}")
