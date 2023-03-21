# Reproduce (Test it yourself)

1. create new project in Google Cloud Console &rarr; switch to that newly created project
2. create instance with the following specifications:
    - region: closest to you with low co2
    - Machine Type: e2-standard-4 (4 vCPU, 16 GB Memory)
    - Change boot disk: Ubuntu 20.04 LTS, Size: 40 GB
3. create service account: <br>
    IAM & Admin &rarr; service accounts &rarr; create service account <br>
    apply the following roles:
    - Viewer
    - Storage Admin 
    - Storage Object Admin 
    - BigQuery Admin
    generate key & download to your local machine
4. generate ssh key <br>
    in terminal: `ssh-keygen -t rsa -f ~/.ssh/capstone -C <USER> -b 2048` <br>
    cat out the public key: `cat .ssh/capstone.pub` <br>
    copy output, go to VM instance on Google Cloud & add ssh key under Metadata
5. `git clone https://github.com/PandaKata/dezoomcamp-project.git`
6. authenticate: create service account with storage admin & bigquery admin; save .json file to .credentials/<filename>.json:
    <br>
    `GOOGLE_APPLICATION_CREDENTIALS=~/dezoomcamp-project/.credentials/service-covid.json`
    <br>
    `gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS`
7. do terraform: replace values: table name, bucket id, project id, got to terraform directory, run:
    <br>
    `terraform init`
    <br>
    `terraform plan`
    <br> 
    enter project ID when prompted
    <br> 
    enter yes when prompted 
    <br> 
    &rarr; check in console to see if bucket & table are there
8. create virtual env with requirements `conda create -n capstone python=3.10` `pip install -r requirements.txt`
9. prefect cloud login OR local alternative
10. register block with credentials
11. `prefect block register -m prefect_gcp` add GCS Bucket
12. `prefect deployment build src/web_to_gcs.py:etl_web_to_gcs -n 'covid_data_to_bucket' --cron "0 6 * * *" -a`
13. `prefect deployment build gcs_to_bq.py:etl_gcs_to_bq -n 'covid_data_to_dwh' --cron "15 6 * * *" -a` # creates deployment yaml file and schedule it via CRON daily at 6.15 CET 
14. `prefect agent start -q 'default'`
15. setup dbt cloud with BQ: https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_4_analytics_engineering/dbt_cloud_setup.md
16. 
