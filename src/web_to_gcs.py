from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from random import randint


@task(retries=3)
def fetch(dataset_url: str) -> pd.DataFrame:
    """Read covid data from web into pandas DataFrame"""
    # if randint(0, 1) > 0:
    #     raise Exception

    df_covid = pd.read_csv(dataset_url)
    return df_covid


@task(log_prints=True)
def clean(df_covid: pd.DataFrame) -> pd.DataFrame:
    """Fix dtype issues"""
    df_covid.date = pd.to_datetime(df_covid.date)
    print(df_covid.head(2))
    print(f"columns: {df_covid.dtypes}")
    print(f"rows: {len(df_covid)}")
    return df_covid


#@task()
#def write_local(df: pd.DataFrame, color: str, dataset_file: str) -> Path:
#    """Write DataFrame out locally as parquet file"""
#    path = Path(f"data/{color}/{dataset_file}.parquet")
#    df.to_parquet(path, compression="gzip")
#    return path


@task()
def write_gcs(df_covid: pd.DataFrame) -> None:
    """Upload local parquet file to GCS"""
    gcs_bucket = GcsBucket.load("capstone-bucket")
    gcs_bucket.upload_from_dataframe(df=df_covid, to_path="data/covid_data.csv", serialization_format='csv')
    return



@flow()
def etl_web_to_gcs() -> None:
    """The main ETL function"""
    
    dataset_url = 'https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv'

    df = fetch(dataset_url)
    df_clean = clean(df)
    write_gcs(df_clean)


if __name__ == "__main__":
    etl_web_to_gcs()




#prefect deployment build web_to_gcs.py:etl_web_to_gcs -n 'covid_data_to_bucket' --cron "0 5 * * *" -a # creates deployment yaml file and schedule it via CRON daily at 6 CET 
