# World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM world_life_expectancy;

# Finding Duplicates
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year)) 
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country,Year)) as Row_num
	FROM world_life_expectancy
) AS Row_table
WHERE Row_num > 1;

# Start removing duplicates 

DELETE FROM world_life_expectancy
WHERE Row_ID IN (
SELECT Row_ID
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country,Year)) as Row_num
	FROM world_life_expectancy
) AS Row_table
WHERE Row_num > 1
);

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE status = "";

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE status <> "";

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE status = 'Developing';

# this did not work
UPDATE world_life_expectancy 
SET status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
			FROM world_life_expectancy
			WHERE status = 'Developing');

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.status = 'Developing'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developing';



SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America';


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.status = 'Developed'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developed';


SELECT *
FROM world_life_expectancy
WHERE `Life Expectancy` = '';

# Goal: Populate the Life Expectancy by taking average of previous year and next year
SELECT Country, Year, `Life Expectancy`
FROM world_life_expectancy;

SELECT t1.Country, t1.Year, t1.`Life Expectancy`, 
t2.Country, t2.Year, t2.`Life Expectancy`,
t3.Country, t3.Year, t3.`Life Expectancy`,
ROUND((t2.`Life Expectancy` + t3.`Life Expectancy`) / 2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country 
    AND t1.Year = t2.Year - 1 #next year on 2nd table
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country 
    AND t1.Year = t3.Year + 1 #previous year on 2nd table
WHERE t1.`Life Expectancy` = '';


# Populate the calculation

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country 
    AND t1.Year = t2.Year - 1 #next year on 2nd table
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country 
    AND t1.Year = t3.Year + 1 #previous year on 2nd table
SET t1.`Life Expectancy` = ROUND((t2.`Life Expectancy` + t3.`Life Expectancy`) / 2, 1)
WHERE t1.`Life Expectancy` = '';



