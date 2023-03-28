{{ config(
    materialized='table',
    partition_by={
      "field": "date",
      "data_type": "timestamp",
      "granularity": "week"
    }
)}}

with covid_data as
(
  select *,
  from {{ source('staging','covid_table') }}
)


---WHAT COLUMNS DO I NEED
select 

    -- identifiers
    {{ dbt_utils.surrogate_key(['location', 'date']) }} as covid_id,
    cast(iso_code as string) as continent_code,
    cast(continent as string) as continent,
    cast(location as string) as country,

    --date
    cast(date as timestamp) as date,
    
    -- absolute numbers
    cast(total_cases as integer) as total_cases,
    cast(new_cases as integer) as new_cases,
    cast(total_deaths as integer) as total_deaths,
    cast(new_deaths as integer) as new_deaths,
    cast(icu_patients as integer) as icu_patients,
    cast(hosp_patients as integer) as hosp_patients,
    cast(total_tests as integer) as total_tests,
    cast(new_tests as integer) as new_tests,
    cast(people_fully_vaccinated as integer) as people_fully_vaccinated,
    cast(median_age as float64) as median_age,
    cast(excess_mortality as float64) as excess_mortality,

    -- relative numbers
    cast(extreme_poverty as float64) as extreme_poverty,
    cast(total_cases_per_million as float64) as total_cases_per_mio,
    cast(new_cases_per_million as float64) as new_cases_per_mio,
    cast(total_deaths_per_million as float64) as total_deaths_per_mio,
    cast(new_deaths_per_million as float64) as new_deaths_per_mio,
    cast(icu_patients_per_million as float64) as icu_patients_per_mio,
    cast(hosp_patients_per_million as float64) as hosp_patients_per_mio,
    cast(total_tests_per_thousand as float64) total_tests_per_thousand,
    cast(people_fully_vaccinated_per_hundred as float64) as people_fully_vaccinated_per_hundred,
    cast(hospital_beds_per_thousand as float64) as hospital_beds_per_thousand,


    -- rates & indices
    cast(reproduction_rate as float64) as reproduction_rate,
    cast(positive_rate as float64) as positive_rate,
    cast(human_development_index as float64) as human_development_index,


from covid_data

{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}