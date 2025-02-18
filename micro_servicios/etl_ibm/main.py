from google.cloud import storage, bigquery
import pandas as pd
import os
import functions_framework

def upload_to_bigquery(dataframe, table_id):
    client = bigquery.Client()
    job_config = bigquery.LoadJobConfig(write_disposition=bigquery.WriteDisposition.WRITE_APPEND)
    job = client.load_table_from_dataframe(dataframe, table_id, job_config=job_config)
    job.result()
    print(f"Loaded {job.output_rows} rows into {table_id}.")

def validar_datos(archivo:str)->pd.DataFrame:
    """
    Esta función recibe la ruta de un archivo CSV, lee columnas definidas,
    convierte ciertos campos a valores numéricos y fechas en formato datetime,
    estandariza los nombres de columnas y devuelve un DataFrame resultante
    con la información validada.
    """
    cols = ['User', 'Card', 'Year', 'Month', 'Day', 'Time', 'Amount', 
            'Use Chip','Merchant State', 'MCC', 'Errors?', 'Is Fraud?']
    origin = ['User', 'Card', 'Amount', 
              'Use Chip','Merchant State', 'MCC', 'Errors?', 'Is Fraud?','ts']
    names = ['id_user','id_card','c_amt','d_use_chip','d_merchant_state',
             'id_mcc','d_errors','b_fraud','dt_timestamp']

    df = pd.read_csv(archivo, dtype=str, usecols=cols)

    for c in ['User','Card','MCC']:
        df[c] = pd.to_numeric(df[c], errors='coerce').fillna(99999).astype(int)
    
    for c in ['Month','Day']:
        df[c] = pd.to_numeric(df[c], errors='coerce').map(lambda x:f'{x:02d}')
    
    df['ts'] = df[['Year','Month','Day']].apply("-".join,axis=1)
    df['ts'] = df[['ts','Time']].apply(" ".join,axis=1)
    df['ts'] = pd.to_datetime(df['ts'],format='%Y-%m-%d %H:%M')

    df['Amount'] = pd.to_numeric(df['Amount'].map(lambda x:x.replace('$','')), errors='coerce')
    df['Is Fraud?'] = df['Is Fraud?']=='Yes'

    df.drop(['Year','Month','Day','Time'],axis=1,inplace=True)
    df.rename(columns=dict(zip(origin,names)), inplace=True)

    return df

@functions_framework.cloud_event
def main(event):
    # Get the bucket and file name from the event
    bucket_name = event.data['bucket']
    file_name = event.data['name']
    print(f"Processing file: {file_name}")

    # Download the file to /tmp
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    download_path = f"/tmp/{file_name}"
    blob.download_to_filename(download_path)

    # Process the file
    df = validar_datos(download_path)

    # Upload the DataFrame to BigQuery
    table_id = "bi-2025-01.ibm.txn_data"
    upload_to_bigquery(df, table_id)

    # Clean up the temporary file
    os.remove(download_path)