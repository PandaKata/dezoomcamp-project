{{ config(
    materialized='table',
    partition_by={
      "field": "date",
      "data_type": "timestamp",
      "granularity": "week"
    }
)}}



with covid_data as (
    select *, 
    from {{ ref('stg_covid_project') }}
    where (country is not null) and (continent is not null) and (date is not null) 

) 

select 
    extract(YEAR from covid_data.date) as year, 
    extract(MONTH from covid_data.date) as month,
    covid_data.date, 
    covid_data.new_cases_per_mio,
    covid_data.new_deaths_per_mio,
    covid_data.people_fully_vaccinated_per_hundred,
    covid_data.extreme_poverty,
    covid_data.excess_mortality,
    covid_data.human_development_index as hdi,
    covid_data.continent,
    covid_data.country

from covid_data