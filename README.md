# Analysis of Covid Data around the world 

Since the beginning of 2020, the coronavirus has changed the world. With scary news also came the doubters. That makes it all the more important to understand the data. So for my capstone project for the [Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp), I chose to analyze a global corona dataset.
<br>
<br>
With this project I aim to built an end-to-end orchestrated data pipeline. My dataset is publicly available and provided by [Our World in Data](https://github.com/owid/covid-19-data). 

## Used Technologies 
For this project I decided to use the following tools:

- Prefect & GitHub Actions - for orchestration; <br>
- Terraform - as Infrastructure-as-Code (IaC) tool; <br>
- Google Compute Engine - as a virtual machine; <br>
- Google Cloud Storage (GCS) - for storage as Data Lake; <br>
- Google BigQuery - for the project Data Warehouse; <br>
- dbt - for the transformation of raw data in refined data; <br>
- Google Looker studio - for visualizations.

## Problem Description

The data set is a very detailed time series. I decided to look at the development of new corona cases over the course of the year, on the one hand. In doing so, I would like to compare the development in Germany with the rest of the world. Furthermore, I am interested in the vaccination rate in a worldwide comparison and whether there is a connection between poverty and excess mortality.

## Pipeline

![alt text](https://github.com/PandaKata/dezoomcamp-project/blob/main/images/pipeline.png?raw=true)

## Structure of the Repo
- .github/workflows: .yml-files for GitHub Actions
- dbt: all directories, .yml, .sgl files, etc. for the transformations in dbt
- flows: .py files for the prefect flows
- images: used images in the repo
- terraform: terraform files

## Visualizations

The visualizations [can be found here](https://lookerstudio.google.com/reporting/6f2401c9-9622-4bc6-8b37-e68a8c0879cc).

## Try it yourself
If you want to reproduce my pipeline and play around with the data, you can find the [detailed instructions here](https://github.com/PandaKata/dezoomcamp-project/blob/main/reproduce.md).
