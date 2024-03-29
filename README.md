# Analysis of Covid Data around the world :earth_africa:

Since the beginning of 2020, the coronavirus has changed the world. With scary news also came the doubters. That makes it all the more important to understand the data. So for my capstone project for the [Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp) by [DataTalks Club](https://datatalks.club/), I chose to analyze a global corona dataset.
<br>
<br>
With this project I aim to built an end-to-end orchestrated data pipeline. My dataset is publicly available and provided by [Our World in Data](https://github.com/owid/covid-19-data). 
<br>
<br>
Disclaimer: Since my trial period on Google Cloud has now ended, I can no longer use all the features. That's why my dashboard has not been updated since April 21.

## Used Technologies 
For this project I decided to use the following tools:

- Prefect & GitHub Actions - for orchestration; <br>
- Terraform - as Infrastructure-as-Code (IaC) tool; <br>
- Google Compute Engine - as a virtual machine; <br>
- Google Cloud Storage (GCS) - for storage as Data Lake; <br>
- Google BigQuery - for the project Data Warehouse; <br>
- dbt - for the transformation of raw data in refined data; <br>
- Google Looker studio - for visualizations. <br>

I built a data pipeline that pulls Corona data daily from GitHub, loads it into Google Cloud Storage using Prefect and GitHub Actions, and then into BigQuery. Using dbt Labs, the raw data is transformed and then visualized in Looker Studio.

## Problem Description

The data set is a very detailed time series. I decided to look at the development of new corona cases over the course of the year, on the one hand. In doing so, I would like to compare the development in Germany with the rest of the world. Furthermore, I am interested in the vaccination rate in a worldwide comparison and whether there is a correlation between poverty and excess mortality.
<br>
<br>
Since the data by Our World in Data is updated daily early in the morning, my goal is also to have fresh data every day at 7 am.

## Pipeline

![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/pipeline.png?raw=true)

## Structure of the Repo
- .github/workflows: .yml-files for GitHub Actions
- dbt: all directories, .yml, .scl files, etc. for the transformations in dbt
- flows: .py files for the prefect flows
- images: used images in the repo
- terraform: terraform files


## Try it yourself
If you want to reproduce my pipeline and play around with the data, you can find the [detailed instructions here](https://github.com/PandaKata/dezoomcamp-project/blob/main/reproduce.md).

## Visualizations

The interactive dashboards [can be found here](https://lookerstudio.google.com/reporting/6f2401c9-9622-4bc6-8b37-e68a8c0879cc).
![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/dashboard.png?raw=true)
![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/dashboard2.png?raw=true)


