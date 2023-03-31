# Reproduce (Test it yourself)

### Setup project

Create new project in Google Cloud Console &rarr; switch to that newly created project


### Setup VM
Create instance with the following specifications:
- region: closest to you with low co2
- Machine Type: e2-standard-4 (4 vCPU, 16 GB Memory)
- Change boot disk: Ubuntu 20.04 LTS, Size: 30 GB
- you might have to enable the compute engine API if you haven't created a VM on this account before

### Setup SSH to VM

- in your local terminal: `ssh-keygen -t rsa -f ~/.ssh/<DESIREDNAMEOFYOURKEY> -C <DESIREDUSERNAMEONVM> -b 2048` <br>
- cat out the public key: `cat .ssh/capstone.pub` <br>
- copy output, go to VM instance on Google Cloud Console & paste ssh key under Metadata
- Go back to the VM and start it, copy the external IP
- Create a config-file locally under your .ssh directory with the following content:
```
Host <hostname to use when connecting>
HostName <external IP>
User <DESIREDUSERNAMEONVM you specified in ssh-keygen command>
IdentityFile <path to your private key> e.g.  ~/.ssh/privatekey
```
- go to your local terminal and type ssh <hostname to use when connecting>
  <br>
    &rarr; you are now connected to your VM

### Connecting and setting up VSCode

- install VS Code locally if you don't have it already 
- search Extensions for SSH and install Remote-SSH from Microsoft
- in the lower left hand corner click the green icon to Open a Remote Window
- choose "Connect to Host..." and either choose your ssh connection or type in Hostname

### Create Service Account
    
- go to IAM & Admin &rarr; Service Accounts on Google Cloud Console
- create service account
- grant the following roles:
    - Viewer
    - Storage Admin 
    - Storage Object Admin 
    - BigQuery Admin
- click continue and navigate to the three dots on the right side and click on manage keys
- choose: Add Key & &rarr; Create new key &rarr; JSON &rarr; Create 
- key will be downloaded onto local computer 
    
### Setup your VM

1. Open terminal in VS Code and run:
   <br>
   `wget https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh`
2. make download executable and run it:
   <br>
   `chmod +x Anaconda3-2023.03-Linux-x86_64.sh`
   <br>
   `./Anaconda3-2023.03-Linux-x86_64.sh`
   <br> type 'yes' when prompted
3. run 
   <br>
   `sudo apt-get update`
4. clone repo
   <br>
   `git clone https://github.com/PandaKata/dezoomcamp-project.git`
5. make new directory for credentials
   <br>
   `mkdir -p .google/credentials`
   <br>
   move the credentials file we downloaded before in there
6. add the following to the .bashrc file:
   <br>
   `export GOOGLE_APPLICATION_CREDENTIALS=~/.google/credentials/<name-of-creds-file>.json`
   <br>
   then run
   <br>
   `source .bashrc`
   <br>
   and authenticate by running
   <br>
   `gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS`
7. setup terraform
   <br>
   run 
   <br>
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```
- `cd` to the terraform directory
- change the variables.tf file with your corresponding variables:
![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/terraform_var.png?raw=true)
- run
  <br>
```
terraform init
terraform apply
```
type 'yes' when prompted
    
    
### Setup Prefect
1. go to [Prefect Cloud](https://www.prefect.io/cloud/) and create a free account
2. once logged in, create a [workspace](https://app.prefect.cloud/workspaces/create) and an [API key](https://app.prefect.cloud/my/api-keys).
3. add the previously created API key and the name of your workspace as repository secrets, as shown in this image:
![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/prefect_github.png?raw=true)
    
    
    
    
    
    
    
# test
    

6. create service account: <br>
    IAM & Admin &rarr; service accounts &rarr; create service account <br>
    apply the following roles:
    - Viewer
    - Storage Admin 
    - Storage Object Admin 
    - BigQuery Admin
    generate key & download to your local machine
    <br>
    save .json file to .credentials/<filename>.json:
    <br>
    `GOOGLE_APPLICATION_CREDENTIALS=~/dezoomcamp-project/.credentials/service-covid.json`
    <br>
    `gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS`
5. clone this repo: <br>
    `git clone https://github.com/PandaKata/dezoomcamp-project.git`
7. authenticate: create service account with storage admin & bigquery admin; save .json file to .credentials/<filename>.json:
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
15. create dbt cloud account & setup dbt cloud with BQ: https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_4_analytics_engineering/dbt_cloud_setup.md
16. 
