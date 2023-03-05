# Reproduce (Test it yourself)

1. create new project in Google Cloud Console &rarr; switch to that newly created project
2. create instance with the following specifications:
    - region: closest to you with low co2
    - Machine Type: e2-standard-4 (4 vCPU, 16 GB Memory)
    - Change boot disk: Ubuntu 20.04 LTS, Size: 40 GB
3. create service account: <br>
    IAM & Admin &rarr; service accounts &rarr; create service account <br>
    apply the following roles: <br>
        - Viewer <br>
        - Storage Admin <br>
        - Storage Object Admin <br>
        - BigQuery Admin <br>
    generate key & download to your local machine
