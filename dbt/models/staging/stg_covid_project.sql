{{config(materialized='view') }}

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
    
    



from {{ source('staging', 'covid_table') }}
limit 100