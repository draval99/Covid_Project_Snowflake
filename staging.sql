CREATE DATABASE IF NOT EXISTS COVID_DATA;

CREATE SCHEMA COVID_DATA.RAW;

CREATE STAGE RAW_STAGE;

USE DATABASE COVID_DATA;
USE SCHEMA RAW;

CREATE TABLE covid_data (
  iso_code VARCHAR,
  continent VARCHAR,
  location VARCHAR,
  date DATE,
  total_cases INT,
  new_cases INT,
  new_cases_smoothed INT,
  total_deaths INT,
  new_deaths INT,
  new_deaths_smoothed INT,
  total_cases_per_million FLOAT,
  new_cases_per_million FLOAT,
  new_cases_smoothed_per_million FLOAT,
  total_deaths_per_million FLOAT,
  new_deaths_per_million FLOAT,
  new_deaths_smoothed_per_million FLOAT,
  reproduction_rate FLOAT,
  icu_patients INT,
  icu_patients_per_million FLOAT,
  hosp_patients INT,
  hosp_patients_per_million FLOAT,
  weekly_icu_admissions INT,
  weekly_icu_admissions_per_million FLOAT,
  weekly_hosp_admissions INT,
  weekly_hosp_admissions_per_million FLOAT,
  total_tests INT,
  new_tests INT,
  total_tests_per_thousand FLOAT,
  new_tests_per_thousand FLOAT,
  new_tests_smoothed INT,
  new_tests_smoothed_per_thousand FLOAT,
  positive_rate FLOAT,
  tests_per_case FLOAT,
  tests_units VARCHAR,
  total_vaccinations INT,
  people_vaccinated INT,
  people_fully_vaccinated INT,
  total_boosters INT,
  new_vaccinations INT,
  new_vaccinations_smoothed INT,
  total_vaccinations_per_hundred FLOAT,
  people_vaccinated_per_hundred FLOAT,
  people_fully_vaccinated_per_hundred FLOAT,
  total_boosters_per_hundred FLOAT,
  new_vaccinations_smoothed_per_million FLOAT,
  new_people_vaccinated_smoothed INT,
  new_people_vaccinated_smoothed_per_hundred FLOAT,
  stringency_index FLOAT,
  population_density FLOAT,
  median_age FLOAT,
  aged_65_older FLOAT,
  aged_70_older FLOAT,
  gdp_per_capita FLOAT,
  extreme_poverty FLOAT,
  cardiovasc_death_rate FLOAT,
  diabetes_prevalence FLOAT,
  female_smokers FLOAT,
  male_smokers FLOAT,
  handwashing_facilities FLOAT,
  hospital_beds_per_thousand FLOAT,
  life_expectancy FLOAT,
  human_development_index FLOAT,
  population INT,
  excess_mortality_cumulative_absolute INT,
  excess_mortality_cumulative INT,
  excess_mortality FLOAT,
  excess_mortality_cumulative_per_million FLOAT
);
COPY INTO covid_data FROM @raw_stage/owid-covid-data.csv.gz FILE_FORMAT = (TYPE = CSV  SKIP_HEADER = 1) ;



CREATE TABLE IF NOT EXISTS covid_hospitalizations (
entity VARCHAR,
iso_code VARCHAR,
date date,
indicator varchar,
value float);

COPY INTO covid_hospitalizations FROM @raw_stage/covid-hospitalizations.csv.gz FILE_FORMAT = (TYPE = CSV  SKIP_HEADER = 1) ;

CREATE TABLE IF NOT EXISTS excess_mortality (
location VARCHAR,
date date,
p_scores_all_ages float,
p_scores_15_64 float,
p_scores_65_74 float,
p_scores_75_84 float,
p_scores_85plus float,
deaths_2020_all_ages float,
average_deaths_2015_2019_all_ages float,
deaths_2015_all_ages float,
deaths_2016_all_ages float,
deaths_2017_all_ages float,
deaths_2018_all_ages float,
deaths_2019_all_ages float,
deaths_2010_all_ages float,
deaths_2011_all_ages float,
deaths_2012_all_ages float,
deaths_2013_all_ages float,
deaths_2014_all_ages float,
deaths_2021_all_ages float,
time int,
time_unit varchar,
p_scores_0_14 float,
projected_deaths_since_2020_all_ages float,
excess_proj_all_ages float,
cum_excess_proj_all_ages float,
cum_proj_deaths_all_ages float,
cum_p_proj_all_ages float,
p_proj_all_ages float,
p_proj_0_14 float,
p_proj_15_64 float,
p_proj_65_74 float,
p_proj_75_84 float,
p_proj_85p float,
cum_excess_per_million_proj_all_ages float,
excess_per_million_proj_all_ages float,
deaths_2022_all_ages float,
deaths_2023_all_ages float,
deaths_since_2020_all_ages float);


COPY INTO excess_mortality FROM @raw_stage/excess_mortality.csv.gz FILE_FORMAT = (TYPE = CSV  SKIP_HEADER = 1) ;