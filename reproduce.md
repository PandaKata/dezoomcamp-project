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
- change the variables.tf file with your corresponding variables, I would recommend to leave the name of the dataset, table and bucket as they are; otherwise you need to change them in the prefect flows and dbt:
![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/terraform_var.png?raw=true)
- run
  <br>
```
terraform init
terraform apply
```
- type 'yes' when prompted
  
8. create virtual environment
   <br>
   run
   <br>
```
conda create -n capstone python=3.10
conda activate capstone
pip install -r requirements.txt
```
    
    
### Setup Prefect
1. go to [Prefect Cloud](https://www.prefect.io/cloud/) and create a free account
2. once logged in, create a [workspace](https://app.prefect.cloud/workspaces/create) and an [API key](https://app.prefect.cloud/my/api-keys).
3. add the previously created API key and the name of your workspace as repository secrets, as shown in this image:
![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/prefect_github.png?raw=true)
  &rarr; `PREFECT_API_KEY` is the API key you created before (should start with pnu_); `PREFECT_WORKSPACE` is a combination of your account/workspace e.g. pandakata/dezoomcamp 
4. create blocks in prefect cloud
  - run `prefect block register -m prefect_gcp` in the terminal in VSCode in your virtual env
  - go to your workspace in prefect cloud
    1. add gcs bucket block
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/gcs_bucket.png?raw=true)
    2. name the block 'capstone-bucket' if you don't want to make any changes in the prefect flows; fill in the other fields with bucket name 
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/gcs_bucket_and_creds.png?raw=true)
    3. create a credentials block within in that window where you paste the content of the .json file for your service account (I created a separate service account for prefect); name the block 'capstone-gcp-creds' if you don't want to change anything
     
  
### Setup dbt

1. create a [dbt cloud account](https://www.getdbt.com/signup/) 
2. create a new project and connect it to your [warehouse](https://docs.getdbt.com/docs/cloud/manage-access/set-up-bigquery-oauth); more detailed instruction can be found [here](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_4_analytics_engineering/dbt_cloud_setup.md).
3. fork [my repo](https://github.com/PandaKata/dezoomcamp-project) if you haven't done it yet.
4. setup a repo:
  Choose git clone and paste the ssh link from your github fork
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/git_dbt.png?raw=true)
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/dbt_git.png?raw=true)
5. copy key
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/api_dbt.png?raw=true)
6. in the forked repo go to Settings and then Deploy Keys &rarr; paste the key; enable write access
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/deploy_key.png?raw=true)
7. go to your project settings and change the subdirectory to 'dbt'
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/dbt_sub.png?raw=true)
8. go back to dbt &rarr; develop &rarr; there you should see the repo; navigate to the dbt directory
9. run `dbt deps` in the console, so your environment is ready
10. navigate to models &rarr; staging &rarr; schema.yml and replace variables with your own where necessary:
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/schema_yaml.png?raw=true)
11. you may also need to go into the .sql files and update the names to match what is in Big Query
12. repeat for core directory

### Run dbt in production
1. go to environments in dbt cloud and create environment 
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/create_env.png?raw=true)
2. go to jobs in dbt cloud and create new job with the following parameters; this will schedule the dbt transformations daily at 6.45 CET
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/job_1.png?raw=true)
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/jobs_2.png?raw=true)
  ![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/jobs_3.png?raw=true)
 
  

### Visualization in Looker Studio
go to [Looker Studio](https://lookerstudio.google.com/) &rarr; create &rarr; BigQuery &rarr; choose you project, dataset & table
