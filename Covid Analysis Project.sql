
Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4;




select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location Like 'indi%%'
and continent is not null
order by 1,2;

--Looking at Total Cases vs Population

select location, date, total_cases, population , (total_cases/population) * 100 as CasePercentage
from PortfolioProject..CovidDeaths
--where location Like 'indi%%'
where continent is not null
order by 1,2;

--Looking at Countries with Highest Infection Rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as InfectedRAte
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by Infectedrate DESC;

--Showing countries with Highest Death Count per population


select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount DESC;

--Showing continents with Highest Death Count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount DESC;

--Global Numbers

select SUM(new_cases)as TotalNewCases,SUM(cast(new_deaths as int)) as TotalNewDeaths,(SUM(cast(new_deaths as int))/sum(new_cases)) * 100 as NewDeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2;


--Looking at Total Poulation Vs Vaccination

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

--CTE

With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as

(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

)

Select *,(RollingPeopleVaccinated/Population) * 100
from PopvsVac

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date


Select *,(RollingPeopleVaccinated/Population) * 100
from #PercentPopulationVaccinated


--Creating View to store data  for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null





