--CovidDeaths and CovidVaccination table.

--This will sum all total_deaths across the world
SELECT SUM(CAST(total_deaths as int))as TotalDeaths
FROM dbo.CovidDeaths

--Calculate the average number of daily deaths over a time period.
SELECT AVG(CAST(new_deaths as int))as AvgDeaths, CONVERT(date, date) as Date
FROM CovidDeaths
WHERE new_deaths is not NULL
GROUP BY date
order by 1 desc;

--Find the number of COVID-19 deaths in ASIA
SELECT continent, SUM(CAST(new_deaths as INT)) as TotalDeaths
FROM dbo.CovidDeaths
WHERE continent = 'Asia'
GROUP BY continent;

--Changing data types of total_deaths
ALTER TABLE dbo.CovidDeaths
ALTER COLUMN total_deaths INT

--Identify the location with the highest number of COVID-19 deaths.
SELECT continent, SUM(CAST(new_deaths as int)) as Highest_Deaths
FROM dbo.CovidDeaths
WHERE continent is not null  
Group by continent
ORDER BY 2  desc

--Changing the date format
ALTER TABLE dbo.CovidDeaths
ALTER COLUMN date date

--Determine the date with the highest number of deaths
SELECT date, MAX(CAST(new_deaths as INT)) as HighestDeath
FROM dbo.CovidDeaths
WHERE new_deaths is not NULL
GROUP BY date
ORDER by 2 desc

--Determine the Death Percentage
SELECT SUM(new_cases)as Total_Cases, SUM(CAST(new_deaths as INT))as Total_Deaths, 
SUM(CAST(new_deaths as INT))/SUM(new_cases)* 100 as Death_Percentage
FROM dbo.CovidDeaths
WHERE continent is not NULL
ORDER BY 1, 2

--Determine the number Country who got their full vaccination
SELECT iso_code,Location, COUNT(CAST(people_fully_vaccinated as INT)) as PeopleFullyVaccinated
FROM dbo.CovidVaccinations
--WHERE  people_fully_vaccinated is not NULL
GROUP BY iso_code, Location
ORDER BY 1,2

--Display the eact country with high positive rate from the Covid Vaccinaton Table
SELECT Continent,Location, MAX(positive_rate)as HighestPositiveRate
FROM dbo.CovidVaccinations
WHERE positive_rate is not NULL
GROUP BY Continent, Location
ORDER BY 3 desc

SELECT top(50) *
FROM CovidVaccinations

--Check for duplicated rows for CovidDeaths table
WITH RownumCTE as (
	SELECT * , ROW_NUMBER() OVER(
	PARTITION BY iso_code,
	Continent, 
	Location, 
	Date,
	new_cases
	ORDER BY iso_code) as row_num
FROM dbo.CovidDeaths
)
SELECT *
FROM RownumCTE

--Check for duplicated rows for CovidVaccinations table
WITH RownumCTE as (
	SELECT * , ROW_NUMBER() OVER(
	PARTITION BY iso_code,
	Continent, 
	Location, 
	Date,
	new_tests
	ORDER BY iso_code) as row_num
FROM dbo.CovidVaccinations
)
SELECT *
FROM RownumCTE
--WHERE row_num > 1


SELECT TOP(500) *
FROM dbo.CovidDeaths

SELECT TOP(500)*
FROM dbo.CovidVaccinations

--Creating a Temp table for CovidVaccination table to populate specific data in each columns
CREATE TABLE #temp_CovidVac (
 Continent varchar(100),
 Location varchar(100),
 Date date,
 new_vaccinations int,
 people_fully_vax int
 )
--Inserting specific column values in a temp table to easily specific column data.
 INSERT INTO #temp_CovidVac
 SELECT continent, location, date, new_vaccinations, people_fully_vaccinated
 FROM dbo.CovidVaccinations

 --Filtering two tables to check data consistency
 SELECT *
 FROM #temp_CovidVac
 WHERE Location LIKE '%Philippines%' 
 --WHERE new_vaccinations is not NULL AND people_fully_vax is not NULL
 ORDER BY 5 desc

 SELECT Continent,Location,date,positive_rate,new_vaccinations, people_fully_vaccinated
 FROM CovidVaccinations
 WHERE Location LIKE '%Philippines%'
 ORDER BY date desc
