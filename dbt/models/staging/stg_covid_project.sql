{{config(materialized='view') }}

select * from {{ source('staging', 'covid_table') }}
limit 100