# World Life Expectancy Project (Exploratory Data Analysis)
# Find insights and trends in the data


SELECT *
FROM world_life_expectancy;

SELECT Country, MIN(`Life expectancy`), 
MAX(`Life expectancy`)
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <>0
AND MAX(`Life expectancy`) <> 0
ORDER BY Country DESC;

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = 0;

SELECT Country, MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <>0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years ASC;


SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy`<>0
GROUP BY Year
ORDER BY Year;


SELECT *
FROM world_life_expectancy;

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC;

# Prediction: GDP has positive correlation with life expectancy


SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life Expectancy` ELSE NULL END) AS High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life Expectancy` ELSE NULL END) AS Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

SELECT *
FROM world_life_expectancy;


# Avg Life Expectancy Between Developed and Developing Countries
SELECT status, ROUND(AVG(`Life Expectancy`),1)
FROM world_life_expectancy
GROUP BY status;

SELECT status, COUNT(DISTINCT Country), ROUND(AVG(`Life Expectancy`),1)
FROM world_life_expectancy
GROUP BY status;


# Life_Exp vs BMI
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC;


# Adult Mortality
SELECT Country, Year, `Life expectancy`, `Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%';
