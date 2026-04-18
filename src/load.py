
from sqlalchemy import create_engine


def load_to_csv(df, filepath='output/cleaned_retail.csv'):
    df.to_csv(filepath, index=False)
    print(f"CSV saved successfully! Path: {filepath}")

def load_to_postgres(df, db_name, user, password, host='localhost', port='5432'):
    engine = create_engine(f'postgresql+psycopg2://{user}:{password}@{host}:{port}/{db_name}')
    df.to_sql('retail_data', engine, if_exists='replace', index=False)
    print(f"Data loaded to PostgreSQL successfully! Rows: {len(df)}")