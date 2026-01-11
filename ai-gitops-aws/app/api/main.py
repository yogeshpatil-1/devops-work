from fastapi import FastAPI
import joblib

app = FastAPI()
model = joblib.load('model.pkl')

@app.get('/predict')
def predict(marketing_spend: float):
    return {'sales': model.predict([[marketing_spend]])[0]}
