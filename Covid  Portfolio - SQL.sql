select * 
from [Portfolio Project]..coviddeaths
Order by 3,4


select * 
from [Portfolio Project]..covidvaccination
Order by 3,4


--Select Location, date, total_cases, new_cases , Total_deaths , population 
--from [Portfolio Project]..coviddeaths
--Order by 1,2    



Select Location, date, total_cases,Total_deaths , (Total_deaths/Total_cases)*100 as deathPercentage
from [Portfolio Project]..coviddeaths
Where location = 'India'
Order by 1,2 


---Total cases Vs population ( % population got Covid ) 


Select Location, date,population, total_cases, (Total_cases/population)*100 as percentpopulation infected
from [Portfolio Project]..coviddeaths
Where location = 'India'
Order by 1,2 

--- Country with highest infestion rate
Select Location,population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentpopulationinfected
from [Portfolio Project]..coviddeaths
Group by population, location
Order by percentpopulationinfected desc


Death count per population 

Select Location, max(cast(total_deaths as int)) as totaldeathcount
From [Portfolio Project]..coviddeaths
Where continent is not null
group by location
Order by  totaldeathcount desc


Continent Filter 


Select continent, max(cast(total_deaths as int)) as totaldeathcount
From [Portfolio Project]..coviddeaths
Where continent is not null
group by continent
Order by  totaldeathcount desc


---- Showing the continent with highest death count  per population 

Select continent, max(cast(total_deaths as int)) as totaldeathcount
From [Portfolio Project]..coviddeaths
Where continent is not null
group by continent
Order by  totaldeathcount desc




--- Breaking Global numbers 


Select date, sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [Portfolio Project]..coviddeaths
--Where location = 'India'
where continent is not null
group by date
Order by 1,2

--- Total Cases

Select sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [Portfolio Project]..coviddeaths
--Where location = 'India'
where continent is not null
--group by date
Order by 1,2

--- using vaccination Table Join with death

--- Total people Vs Total Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio Project..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


sing CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..Coviddeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

Using Temp Table to perform Calculation on Partition By in previous query

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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 








     

