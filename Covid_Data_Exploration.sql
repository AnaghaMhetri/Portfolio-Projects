SELECT * FROM PortfolioProject.coviddeaths;

DROP TABLE IF EXISTS PortfolioProject.coviddeaths;

CREATE TABLE CovidVaccinations (
    iso_code VARCHAR(20) NULL,
    continent VARCHAR(20) NULL,
    location VARCHAR(100) NULL,
    date DATE NULL,
    total_tests BIGINT NULL,
    new_tests INT NULL,
    total_tests_per_thousand DOUBLE NULL,
    new_tests_per_thousand DOUBLE NULL,
    new_tests_smoothed INT NULL,
    new_tests_smoothed_per_thousand DOUBLE NULL,
    positive_rate DOUBLE NULL,
    tests_per_case DOUBLE NULL,
    tests_units VARCHAR(30) NULL,
    total_vaccinations BIGINT NULL,
    people_vaccinated BIGINT NULL,
    people_fully_vaccinated BIGINT NULL,
    total_boosters BIGINT NULL,
    new_vaccinations INT NULL,
    new_vaccinations_smoothed INT NULL,
    total_vaccinations_per_hundred DOUBLE NULL,
    people_vaccinated_per_hundred DOUBLE NULL,
    people_fully_vaccinated_per_hundred DOUBLE NULL,
    total_boosters_per_hundred DOUBLE NULL,
    new_vaccinations_smoothed_per_million INT NULL,
    new_people_vaccinated_smoothed INT NULL,
    new_people_vaccinated_smoothed_per_hundred DOUBLE NULL,
    stringency_index DOUBLE NULL,
    population_density DOUBLE NULL,
    median_age DOUBLE NULL,
    aged_65_older DOUBLE NULL,
    aged_70_older DOUBLE NULL,
    gdp_per_capita DOUBLE NULL,
    extreme_poverty DOUBLE NULL,
    cardiovasc_death_rate DOUBLE NULL,
    diabetes_prevalence DOUBLE NULL,
    female_smokers DOUBLE NULL,
    male_smokers DOUBLE NULL,
    handwashing_facilities DOUBLE NULL,
    hospital_beds_per_thousand DOUBLE NULL,
    life_expectancy DOUBLE NULL,
    human_development_index DOUBLE NULL,
    excess_mortality_cumulative_absolute DOUBLE NULL,
    excess_mortality_cumulative DOUBLE NULL,
    excess_mortality DOUBLE NULL,
    excess_mortality_cumulative_per_million DOUBLE NULL
);

CREATE TABLE CovidDeaths (
    iso_code VARCHAR(20) NULL,
    continent VARCHAR(20) NULL,
    location VARCHAR(100) NULL,
    date DATE NULL,
    population BIGINT NULL,
    total_cases BIGINT NULL,
    new_cases INT NULL,
    new_cases_smoothed DOUBLE NULL,
    total_deaths INT NULL,
    new_deaths INT NULL,
    new_deaths_smoothed DOUBLE NULL,
    total_cases_per_million DOUBLE NULL,
    new_cases_per_million DOUBLE NULL,
    new_cases_smoothed_per_million DOUBLE NULL,
    total_deaths_per_million DOUBLE NULL,
    new_deaths_per_million DOUBLE NULL,
    new_deaths_smoothed_per_million DOUBLE NULL,
    reproduction_rate DOUBLE NULL,
    icu_patients INT NULL,
    icu_patients_per_million DOUBLE NULL,
    hosp_patients INT NULL,
    hosp_patients_per_million DOUBLE NULL,
    weekly_icu_admissions INT NULL,
    weekly_icu_admissions_per_million DOUBLE NULL,
    weekly_hosp_admissions INT NULL,
    weekly_hosp_admissions_per_million DOUBLE NULL
);

select * from PortfolioProject.CovidDeaths;

------ DEATH %
SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) AS DeathPercentage
FROM CovidDeaths
where EXTRACT(YEAR FROM date ) > 2023
ORDER BY 1,2;

------ % of Population Infected
SELECT location, date, population, total_cases, ROUND((total_cases/population)*100,2) AS PercentPopulationInfected
FROM CovidDeaths
ORDER BY 1,2;

---------- Highest Infected count with total % of population infected
SELECT location, population, MAX(total_cases) HighestInfectionCount, ROUND(MAX(total_cases/population)*100,2) PercentPopulationInfected
FROM CovidDeaths
GROUP BY 1,2
ORDER BY 4 DESC;

---------- Highest Death count per population
SELECT location, MAX(total_deaths) AS HighestDeath
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

----------------------------------------------------------
select * from PortfolioProject.CovidVaccinations;

SELECT *
FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location = v.location AND d.date = v.date;

SELECT d.continent, d.location, d.date, v.new_vaccinations ,SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) NewVaccinationsPerLocation
FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 1,2,3;

CREATE VIEW CovidDeaths_CovidVaccinations_merge AS (
    SELECT d.iso_code, 
           d.continent, 
           d.location, 
           d.population,
           d.total_cases,
           SUM(d.total_cases) OVER (PARTITION BY d.location ORDER BY d.location, d.date) RunningTotalCases,
           d.total_deaths,
           SUM(d.total_deaths) OVER (PARTITION BY d.location ORDER BY d.location, d.date) RunningTotalDeaths,
           v.total_vaccinations,
           v.aged_65_older,
           v.aged_70_older,
           v.female_smokers,
           v.male_smokers
		FROM CovidDeaths d
        JOIN CovidVaccinations v
        ON d.location = v.location AND d.date = v.date
        WHERE d.continent IS NOT NULL
           );

SELECT * FROM coviddeaths_covidvaccinations_merge;




















