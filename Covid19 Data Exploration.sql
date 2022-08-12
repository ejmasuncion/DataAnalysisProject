SELECT * FROM `covid-19`.dataset;

-- Select data that we are going to use

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `covid-19`.dataset
order by 1, 2;

-- Total case vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM `covid-19`.dataset
where location = 'Philippines'
order by 1, 2;

-- Looking at the Total Cases vs Population
-- Shows what percentage of population got Covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as InfectionRate
FROM `covid-19`.dataset
where location = 'Philippines'
order by 1, 2;

-- Looking at countries w/ highest infection rate compared to Population
SELECT location, population, max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as InfectionRate
FROM `covid-19`.dataset
group by location, population
order by InfectionRate desc;

-- Looking at countries highest deathcount per population
SELECT location, max(cast(Total_deaths as float)) as TotalDeathCount
FROM `covid-19`.dataset
where continent != ''
group by location
order by TotalDeathCount desc;

-- sort by continents
SELECT location, max(cast(Total_deaths as float)) as TotalDeathCount
FROM `covid-19`.dataset
where continent = ''
group by location
order by TotalDeathCount desc;

-- Global numbers
SELECT date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM `covid-19`.dataset
where location = 'World'
order by 1, 2;

-- Max Global numbers
SELECT location, max(total_cases) as MaxTotalCases, max(cast(total_deaths as float)) as MaxTotalDeaths, max(total_deaths/total_cases)*100 as DeathPercentage
FROM `covid-19`.dataset
where location = 'World'
group by location
order by 1, 2;

-- Total Population vs Vaccinations
SELECT continent, location, date, population, new_vaccinations, sum(cast(new_vaccinations as float)) over (partition by location order by location, date)  as TotalVaccination
FROM `covid-19`.dataset
where continent != ''
order by 2, 3;

-- Use CTE
with PopvsVac (Continent, location, date, population, new_vaccinations, TotalVaccination)
as
(
SELECT continent, location, date, population, new_vaccinations, sum(cast(new_vaccinations as float)) over (partition by location order by location, date)  as TotalVaccination
FROM `covid-19`.dataset
where continent != ''
order by 2, 3
)
select *, (TotalVaccination / Population) * 100 as VaccinateRate
From PopvsVac;


