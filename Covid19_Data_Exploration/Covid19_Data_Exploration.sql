/*
Covid 19 Data Exploration from 01st Jan 2020 till 10th July 2021
Skills used: Joins, CTE's, Temp Tables, Aggregate Functions, Converting Data Types
*/


SELECT * 
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
ORDER BY 3, 4

SELECT * 
FROM `portfolioprojects-319607.Covid19.covid_vaccinations`
WHERE continent IS NOT NULL
ORDER BY 3, 4

-- Select data you are going to use

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases) * 100, 2) as DeathPercentage
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
-- AND location = "India"
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT location, date, total_cases, population, round((total_cases/population) * 100, 2) as PopulationInfectedPercent
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
-- AND location = "India"
ORDER BY 1,2

-- Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(round((total_cases/population) * 100, 2)) as PopulationInfectedPercent
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
-- AND location = "India"
GROUP BY location, population
ORDER BY PopulationInfectedPercent DESC

-- Countries with Highest Death Count for every location

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
-- AND location = "India"
GROUP BY location
ORDER BY TotalDeathCount DESC


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
-- AND location = "India"
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, round((SUM(new_deaths)/SUM(new_cases)) * 100, 2) as DeathPercentage
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
-- AND location = "India"
GROUP BY date
ORDER BY 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM `portfolioprojects-319607.Covid19.covid_deaths` dea
JOIN `portfolioprojects-319607.Covid19.covid_vaccinations` vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- Using CTE to perform Calculation on Partition By in previous query (ROLLING COUNT OF PREOPLE VACCINATED)

WITH PopvsVac
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)AS RollingPeopleVaccinated
FROM `portfolioprojects-319607.Covid19.covid_deaths` dea
JOIN `portfolioprojects-319607.Covid19.covid_vaccinations` vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated / Population)*100 AS RollingVaccinationPercent
FROM PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists PercentPopulationVaccinated
create table  PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)AS RollingPeopleVaccinated
FROM `portfolioprojects-319607.Covid19.covid_deaths` dea
JOIN `portfolioprojects-319607.Covid19.covid_vaccinations` vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated


/*
Queries used in tableau
*/

SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, round((SUM(new_deaths)/SUM(new_cases)) * 100, 2) as DeathPercentage
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
-- AND location = "India"
-- GROUP BY date
ORDER BY 1,2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
FROM `portfolioprojects-319607.Covid19.covid_deaths`
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(round((total_cases/population) * 100, 2)) as PopulationInfectedPercent
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
-- AND location = "India"
GROUP BY location, population
ORDER BY PopulationInfectedPercent DESC

SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount, MAX(round((total_cases/population) * 100, 2)) as PopulationInfectedPercent
FROM `portfolioprojects-319607.Covid19.covid_deaths`
WHERE continent IS NOT NULL
-- AND location = "India"
GROUP BY location, population, date
ORDER BY PopulationInfectedPercent DESC
