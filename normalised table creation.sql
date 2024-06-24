create SCHEMA COVID_DATA.NORMAL;

use schema covid_data.normal;

----- CREATE COUNTRY TABLE 
CREATE OR REPLACE TABLE Country AS
(SELECT DISTINCT iso_code, continent, location, population_density, median_age, aged_65_older, aged_70_older, gdp_per_capita, extreme_poverty, CARDIOVASC_DEATH_RATE,diabetes_prevalence, female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand, life_expectancy, human_development_index, population from raw.covid_data
WHERE continent IS NOT NULL
ORDER BY ISO_CODE);

-- Add primary key constraint
ALTER TABLE country
ADD PRIMARY KEY (iso_code);

select * from country;

describe table country;


----- CREATE CovidStatistics TABLE 
CREATE OR REPLACE TABLE CovidStatistics AS(
select concat(rcd.iso_code,date,'C') as key, rcd.iso_code, date, new_cases, new_deaths, reproduction_rate, icu_patients, hosp_patients, weekly_icu_admissions, weekly_hosp_admissions, new_tests, positive_rate, tests_units,stringency_index
from raw.covid_data as rcd
inner join (select iso_code from normal.country) as iso on iso.iso_code = rcd.iso_code);

-- Add primary key constraint
ALTER TABLE CovidStatistics
ADD PRIMARY KEY (key);

-- Add foreign key constraint
ALTER TABLE COVIDSTATISTICS
ADD CONSTRAINT fk_iso_code_STATS
FOREIGN KEY (iso_code)
REFERENCES normal.country(iso_code);

describe table covidstatistics;

SHOW IMPORTED KEYS;


----- CREATE VaccineStatistics TABLE 
CREATE OR REPLACE TABLE VaccineStatistics AS
(SELECT concat(rcd.iso_code,date,'V') as key, rcd.iso_code, date,total_vaccinations - (LAG(total_vaccinations, 1,0) IGNORE NULLS OVER (PARTITION BY rcd.iso_code ORDER BY DATE) )as new_vaccinations, people_vaccinated, people_fully_vaccinated, total_boosters  from raw.covid_data rcd
inner join (select iso_code from normal.country) as iso on iso.iso_code = rcd.iso_code
);

-- Add primary key constraint
ALTER TABLE VaccineStatistics
ADD PRIMARY KEY (key);

-- Add foreign key constraint
ALTER TABLE VaccineStatistics
ADD CONSTRAINT fk_iso_code_VACCINE
FOREIGN KEY (iso_code)
REFERENCES normal.country(iso_code);

describe table VaccineStatistics;

SHOW IMPORTED KEYS;


----- CREATE ExcessMortality TABLE

CREATE OR REPLACE TABLE ExcessMortality AS(
select concat(iso_code,date,'M') as key,location,c.iso_code,date,p_scores_15_64,p_scores_65_74,p_scores_75_84,p_scores_85plus,deaths_2020_all_ages,deaths_2015_all_ages,deaths_2016_all_ages,deaths_2017_all_ages,deaths_2018_all_ages,deaths_2019_all_ages,deaths_2010_all_ages,deaths_2011_all_ages,deaths_2012_all_ages,deaths_2013_all_ages,deaths_2014_all_ages,deaths_2021_all_ages,time,time_unit,p_scores_0_14,projected_deaths_since_2020_all_ages,excess_proj_all_ages,p_proj_all_ages,p_proj_0_14,p_proj_15_64,p_proj_65_74,p_proj_75_84,p_proj_85p,deaths_2022_all_ages,deaths_2023_all_ages from raw.excess_mortality as rem
join (select iso_code,location as country from normal.country) as c on c.country = rem.location
);

-- Add primary key constraint
ALTER TABLE ExcessMortality
ADD PRIMARY KEY (key);

-- Add foreign key constraint
ALTER TABLE ExcessMortality
ADD CONSTRAINT fk_iso_code_MORTALITY
FOREIGN KEY (iso_code)
REFERENCES normal.country(iso_code);

describe table ExcessMortality;

SHOW IMPORTED KEYS;

----CREATE covid-hospitalizations table

create OR REPLACE TABLE covid_hospitalizations AS (SELECT
    CONCAT(ISO_CODE,DATE,'H') AS KEY,
    iso_code,
    date,
    MAX(CASE WHEN indicator = 'Daily hospital occupancy' THEN value END) as "Daily_hospital_occupancy",
    MAX(CASE WHEN indicator = 'Daily ICU occupancy' THEN value END) as "Daily_ICU_occupancy",
    MAX(CASE WHEN indicator = 'Weekly new hospital admissions' THEN value END) as "Weekly_new_hospital_admissions",
    MAX(CASE WHEN indicator = 'Weekly new ICU admissions' THEN value END) as "Weekly_new_ICU_admissions"
FROM raw.covid_hospitalizations
GROUP BY CONCAT(ISO_CODE,DATE,'H'), iso_code, date)
;

select * from raw.covid_hospitalizations where indicator not like '% per million';

select * from normal.covid_hospitalizations;

-- Add primary key constraint
ALTER TABLE covid_hospitalizations
ADD PRIMARY KEY (key);

-- Add foreign key constraint
ALTER TABLE covid_hospitalizations
ADD CONSTRAINT fk_iso_code_HOSPITAL
FOREIGN KEY (iso_code)
REFERENCES normal.country(iso_code);

describe table covid_hospitalizations;

SHOW IMPORTED KEYS;


select * from normal.country;
select * from normal.covid_hospitalizations;
select * from normal.covidstatistics;
select * from normal.excessmortality;
select * from normal.vaccinestatistics where iso_code = 'AFG';

