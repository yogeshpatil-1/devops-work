import joblib, pandas as pd
from sklearn.linear_model import LinearRegression

df = pd.read_csv('data/processed.csv')
X = df[['marketing_spend']]
y = df['sales']

model = LinearRegression()
model.fit(X, y)
joblib.dump(model, 'model.pkl')
