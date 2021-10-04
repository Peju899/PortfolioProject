Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4


--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2


-- Looking at total cases vs total deaths
-- Shows likelihood of dying if one contracts covid

Select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%canada%'
Order by 1,2

-- Looking at Total cases vs population
-- Shows percentage of Population that contracted covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%canada%'
Order by 1,2

-- Looking at countries with the highest infection rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, Max ((total_cases/population))*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%canada%'
Where continent is not null
Group by location, population
Order by PercentagePopulationInfected desc

-- Showing countries with the highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%canada%'
Where continent is not null
Group by location
Order by TotalDeathCount desc

--Numbers by Continents
  

--Showing continents with the highest death counts per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%canada%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global numbers

Select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%canada%'
where continent is not null
Order by 1,2

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%canada%'
where continent is not null
--Group by date
Order by 1,2


-- Total population vs Vaccinations


Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
   Order by 2,3

   --Use CTE
 
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopelVaccinated)
as
(
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
   --Order by 2,3
   )
   Select *, (RollingPeopelVaccinated/Population)*100
   From PopvsVac





   --Temp Table

   Drop Table if exists #PercentPopulationVaccinated
   Create Table #PercentPopulationVaccinated
   (
   Continent nvarchar(255),
   Location nvarchar(255),
   Date datetime,
   Population numeric,
   New_Vaccinations numeric,
   RollingPeopelVaccinated numeric
   )

   Insert into #PercentPopulationVaccinated
   Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
   --where dea.continent is not null
   --Order by 2,3

   Select *, (RollingPeopelVaccinated/Population)*100
   From #PercentPopulationVaccinated



   --Creating View tfo store data for later

   Create view PercentPopulationVaccinated as 
    Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
   --Order by 2,3

   Select *
   from PercentPopulationVaccinated