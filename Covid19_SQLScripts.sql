Select *
from PortfolioProject1..Covid19Deaths
where continent is not null
order by 3,4 

--Select *
--from PortfolioProject1..Covid19Vaccination
--order by 3,4


Select Location, date, total_cases, new_cases,total_deaths,population
from PortfolioProject1..Covid19Deaths
where continent is not null
order by 1,2

--Total cases vs Total Deaths
--Shows the likelihood of dying if you get covid in your country

Select Location, date, total_cases,total_deaths,(total_deaths/total_cases) * 100 as Percentage_of_Death
from PortfolioProject1..Covid19Deaths
where location like '%states%' and continent is not null
order by 1,2

-- Looking at Total cases vs Population
--Shows what percentage of people got Covid

Select Location,date,population, total_cases,(total_cases/population) * 100 as Covid_Percentage
from PortfolioProject1..Covid19Deaths
where continent is not null
--where location like '%states%'
order by 1,2

--Countries with highest Covid19 infection rate compated to Population

Select Location,population, MAX(total_cases) as HighestCovidInfectionCount,MAX(total_cases/population) * 100 as InfectedPopulationPercentage
from PortfolioProject1..Covid19Deaths
--where location like '%states%'
where continent is not null
Group by location,population
order by InfectedPopulationPercentage desc

--Countries with highest death count per population

Select Location, MAX(cast(total_deaths as int)) as HighestCovidDeathCount
from PortfolioProject1..Covid19Deaths
--where location like '%states%'
where continent is not null
Group by location
order by HighestCovidDeathCount desc


--Let's break thing's down by continent :
-- Showing continents with highest death counts per population

Select continent, MAX(cast(total_deaths as int)) as HighestCovidDeathCount
from PortfolioProject1..Covid19Deaths
--where location like '%states%'
where continent is not null
Group by continent
order by HighestCovidDeathCount desc


-- GLOBAL NUMBERS

Select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject1..Covid19Deaths
--where location like '%states%'  
where continent is not null
--group by date
order by 1,2


--Total new cases and deaths in world 

Select sum(new_cases) as New_Cases,sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject1..Covid19Deaths
--where location like '%states%'  
where continent is not null
--group by date
order by 1,2


-- Looking at Total population vs Vaccinations

Select dth.continent,dth.location,dth.date,dth.population,vacc.new_vaccinations
,SUM(cast(vacc.new_vaccinations as int)) OVER (Partition by dth.location 
order by dth.location,dth.date) as CumulativePeopleVaccinated,

from PortfolioProject1..Covid19Deaths dth
Join PortfolioProject1..Covid19Vaccination vacc
	ON dth.location = vacc.location
	and dth.date = vacc.date
where dth.continent is not null
order by 2,3



---- USE CTE

With PopulationVacc ( continent, location, date, population, new_vaccinations,CumulativePeopleVaccinated)
as
(
Select dth.continent,dth.location,dth.date,dth.population,vacc.new_vaccinations
,SUM(cast(vacc.new_vaccinations as int)) OVER (Partition by dth.location 
order by dth.location,dth.date) as CumulativePeopleVaccinated
from PortfolioProject1..Covid19Deaths dth
Join PortfolioProject1..Covid19Vaccination vacc
	ON dth.location = vacc.location
	and dth.date = vacc.date
where dth.continent is not null
)
Select *, (CumulativePeopleVaccinated/population)*100
from PopulationVacc



-- Create view to store data for DataVisulaization

Create View PercentPopulationVaccinated as
Select dth.continent,dth.location,dth.date,dth.population,vacc.new_vaccinations
,SUM(cast(vacc.new_vaccinations as int)) OVER (Partition by dth.location 
order by dth.location,dth.date) as CumulativePeopleVaccinated
from PortfolioProject1..Covid19Deaths dth
Join PortfolioProject1..Covid19Vaccination vacc
	ON dth.location = vacc.location
	and dth.date = vacc.date
where dth.continent is not null
--order by 2,3

Select *
from PercentPopulationVaccinated

------Create view to show new deaths and new cases

create view newdeathsandnewcases as
Select sum(new_cases) as New_Cases,sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject1..Covid19Deaths
--where location like '%states%'  
where continent is not null
--group by date
--order by 1,2

Select *
from newdeathsandnewcases



Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject1..Covid19Deaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..Covid19Deaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..Covid19Deaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc