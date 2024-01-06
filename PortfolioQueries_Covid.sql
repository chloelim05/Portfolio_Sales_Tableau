SELECT * 
FROM Portfolio..CovidDeaths$
WHERE continent is not null;
--showing highest cases percentage 
SELECT location, population,max(total_cases) as HighestInfection, max((total_cases/population)*100) as CasesPercentage
FROM Portfolio..CovidDeaths$
GROUP BY location, population
ORDER BY CasesPercentage desc;
--Use CTE
WITH PopsvsVac(location,date,population, RollingPeopleDeath)
as (
SELECT location,date,population,SUM(CONVERT(int, total_deaths)) OVER (Partition By location order by location,date) as
RollingPeopleDeath
FROM Portfolio..CovidDeaths$
GROUP BY location,total_deaths,date, population
)
SELECT * , RollingPeopleDeath/population
FROM PopsvsVac;
--Looking at Total Population vs Vaccinations
/*SELECT dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location) as RollingPeopleVaccinated
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
	ON dea.date=vac.date
	AND dea.location=vac.location*/
--Temporary Table
DROP Table if exists TempTable
CREATE Table TempTable(
Location nvarchar(255),
Date datetime,
Population numeric,
RollingPeopleDeath numeric)
INSERT INTO TempTable
SELECT location,date,population,SUM(CONVERT(int, total_deaths)) OVER (Partition By location order by location,date) as
RollingPeopleDeath
FROM Portfolio..CovidDeaths$
GROUP BY location,total_deaths,date, population
SELECT * , RollingPeopleDeath/population
FROM TempTable;
/*
--Create view to store data for vizualisations
Create View PercentPopulationDeath as
SELECT location,date,population,SUM(CONVERT(int, total_deaths)) OVER (Partition By location order by location,date) as
RollingPeopleDeath
FROM Portfolio..CovidDeaths$
GROUP BY location,total_deaths,date, population

Select * 
FROM PercentPopulationDeath;*/