import pandas as pd

def extract(path):
    return pd.read_csv(path)

def transform(df):
    df = df.dropna()
    df = df[df['sales'] > 0]
    return df

def load(df, output):
    df.to_csv(output, index=False)
