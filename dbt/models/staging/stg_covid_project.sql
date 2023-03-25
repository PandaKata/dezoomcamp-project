{{ config(
    materialized='view',
    partition_by={
      "field": "date",
      "data_type": "timestamp",
      "granularity": "day"
    }
)}}



---WHAT COLUMNS DO I NEED
select 

    -- identifiers
    cast(iso_code as string) as country_code,
    cast(continent as string) as continent,
    cast(location as string) as  location,

    --date
    cast(date as datetime) as date,
    
    -- numbers
    cast(total_cases as float64) as total_cases,
    cast(new_cases as float64) as new_cases,
    cast(new_cases_smoothed as float64) as new_cases_smoothed,
    cast(total_deaths as float64) as total_deaths,
    cast(new_deaths as float64) as new_deaths,
    cast(new_deaths_smoothed as float64) as new_deaths_smoothed,
    cast(total_cases_per_million as float64) as total_cases_per_million,
    cast(new_cases_per_million as float64) as new_cases_per_million,
    cast(total_deaths_per_million as float64) as total_deaths_per_million,
    cast(new_deaths_per_million as float64) as new_deaths_per_million,
    cast(new_deaths_smoothed_per_million as float64) as new_deaths_smoothed_per_million,
    cast(reproduction_rate as float64) as reproduction_rate,
    cast()


from {{ source('staging', 'covid_table') }}
limit 100