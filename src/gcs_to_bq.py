from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials


@task(retries=3)
def extract_from_gcs() -> Path:
    """Download trip data from GCS"""
    gcs_path = "data/covid_data.csv" 
    gcs_block = GcsBucket.load("capstone-bucket")
    gcs_block.get_directory(from_path=gcs_path, local_path=f"../data/")
    return Path(f"../data/{gcs_path}")


@task()
def transform(path: Path) -> pd.DataFrame:
    """Data cleaning example"""
    df = pd.read_csv(path)
    # fill nan in continent column if there is a values in location column
    # group by country and forward-fill missing values in continent column
    df['continent'] = df.groupby('location')['continent'].ffill()
    print('nan eliminated')
    return df


@task()
def write_bq(df: pd.DataFrame) -> None:
    """Write DataFrame to BiqQuery"""

    gcp_credentials_block = GcpCredentials.load("capstone-gcp-creds")

    df.to_gbq(
        destination_table="capstone_covid_data.covid_table",
        project_id="capstone-project-379718",
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500_000,
        if_exists="append",
    )


@flow()
def etl_gcs_to_bq():
    """Main ETL flow to load data into Big Query"""

    path = extract_from_gcs()
    df = transform(path)
    write_bq(df)


if __name__ == "__main__":
    etl_gcs_to_bq()


#prefect deployment build gcs_to_bq.py:etl_gcs_to_bq -n 'covid_data_to_dwh' --cron "15 5 * * *" -a # creates deployment yaml file and schedule it via CRON daily at 6.15 CET 
