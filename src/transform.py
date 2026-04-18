import pandas as pd

def transform_data(df):
    df_clean = df.copy()

    # Rename columns to snake case
    df_clean = df_clean.rename(columns={
        'InvoiceNo': 'invoice_no',
        'StockCode': 'stock_code',
        'Description': 'description',
        'Quantity': 'quantity',
        'InvoiceDate': 'invoice_date',
        'UnitPrice': 'unit_price',
        'CustomerID': 'customer_id',
        'Country': 'country'
    })

    # 1. Remove duplicates
    df_clean = df_clean.drop_duplicates()

    # 2. Remove null customer_id
    df_clean = df_clean.dropna(subset=['customer_id'])

    # 3. Remove negatives
    df_clean = df_clean[df_clean['quantity'] > 0]
    df_clean = df_clean[df_clean['unit_price'] > 0]

    # 4. Fix data types
    df_clean['customer_id'] = df_clean['customer_id'].astype(int)  # ✅ fixed
    df_clean['invoice_date'] = pd.to_datetime(df_clean['invoice_date'], format='%m/%d/%y %H:%M')

    # 5. Add total_price
    df_clean['total_price'] = (df_clean['quantity'] * df_clean['unit_price']).round(2)

    print(f"Transform complete! Shape: {df_clean.shape}")
    return df_clean