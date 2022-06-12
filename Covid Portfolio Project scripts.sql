Select *
from PortfolioProject..CovidDeaths
order by 3,4

--Select *
--from PortfolioProject..CovidVacines
--order by 3,4

--Select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--Total cases vs. Total deaths (%)
--Death Rate per Country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Rate
from PortfolioProject..CovidDeaths
where location = 'World'
order by 1,2

--Total cases vs. population

Select location, date, total_cases, population, (total_cases/population)*100 as Infected_Pop
from PortfolioProject..CovidDeaths
where location = 'World'
order by 1,2

--Countries with highest infection rate compared to total population

Select location, Max(total_cases) as HighestInfectionCount, population, Max((total_cases/population))*100 as Infected_Pop
from PortfolioProject..CovidDeaths
Group by location, population
order by Infected_Pop desc

--Countries with highest death count per population

Select location, Max(cast(total_deaths as int)) as total_deathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by location
order by total_deathCount desc

--Total population vs. Vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location) 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVacines vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

--USE CTE

with POPvsVAC (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVacines vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from POPvsVAC

--TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(225),
location nvarchar(225),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVacines vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--Create View to Store data for Visualization

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVacines vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null