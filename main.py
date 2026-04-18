from src.extract import extract_data
from src.transform import transform_data
from src.load import load_to_csv, load_to_postgres

filepath = "data/Online_Retail.csv"

#extract
df = extract_data(filepath)

#Transform
df_clean = transform_data(df)

#print(df_clean.head())

# Step 3 - Load to CSV
load_to_csv(df_clean)

# Step 4 - Load to PostgreSQL
load_to_postgres(
    df_clean,
    db_name='online_retail',
    user='postgres',
    password=''  # ← put your pgAdmin password
)
