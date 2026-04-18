import pandas as pd
import os


def extract_data(filepath):
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return None

    df = pd.read_csv(filepath, encoding='ISO-8859-1')
    print(f"Data extracted successfully! Shape: {df.shape}")
    return df
