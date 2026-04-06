CREATE DATABASE AgricultureDB;
USE AgricultureDB;
CREATE TABLE crop_yield_data (
    Area VARCHAR(100),
    Item VARCHAR(100),
    Year INT,
    Value FLOAT,
    average_rain_fall_mm_per_year FLOAT,
    avg_temp FLOAT,
    pesticides_tonnes FLOAT,
    yield_tonnes_ha FLOAT
);
-- TOP 5 highest yielding years for maize in indiA
select  Year , yield_tonnes_ha
from crop_yield_data
where Item = 'Maize' and Area = 'India'
order by yield_tonnes_ha desc
limit 5;

-- WHAT IS THE AVERAGE RAINFALL AND AVERAGE YIELD FOR EACH UNIQUE CROP ITEM
select Item, 
       avg(average_rain_fall_mm_per_year) as Mean_Rainfall, 
       avg(yield_tonnes_ha) as Mean_Yield
from crop_yield_data
group by Item;

-- LABEL EACH RECORD AS HIGH TEMP OR NORMAL TEMP AND SEE HOW IT AFFECT THE YIELD 
select Year , Item, avg_temp,
	case
        when avg_temp > 25 then 'HIGH HEAT' 
        else 'normal'
	end as climate_category,
    yield_tonnes_ha
from crop_yield_data;

-- WHICH COUNTRIES HAVE AN AVERAGE PESTISIDE USE OF MORE THAN 500 TONNE
SELECT Area, AVG(pesticides_tonnes) as Total_Pest
FROM crop_yield_data
GROUP BY Area
HAVING Total_Pest > 500;

-- "How many different crops are we analyzing, and how many different countries are represented?"
SELECT 
    COUNT(DISTINCT Area) AS Unique_Countries, 
    COUNT(DISTINCT Item) AS Unique_Crops
FROM crop_yield_data;

-- "Find all instances where a crop in India faced a 'Double Whammy': High Heat (>28°C) AND Low Rainfall (<500mm)."
SELECT Year, Item, avg_temp, average_rain_fall_mm_per_year, yield_tonnes_ha
FROM crop_yield_data
WHERE Area = 'India' 
  AND avg_temp > 28 
  AND average_rain_fall_mm_per_year < 500;

-- "Which records have a yield that is higher than the GLOBAL average yield?"
SELECT Area, Item, Year, yield_tonnes_ha
FROM crop_yield_data
WHERE yield_tonnes_ha > (SELECT AVG(yield_tonnes_ha) FROM crop_yield_data);

-- "Compare the average yield of 'Rice, paddy' and 'Wheat' for the years 2000 to 2010."
SELECT Item, AVG(yield_tonnes_ha) as Decade_Avg
FROM crop_yield_data
WHERE Item IN ('Rice, paddy', 'Wheat')
  AND Year BETWEEN 2000 AND 2010
GROUP BY Item;

-- final Check for any NULL values in important columns
SELECT COUNT(*) 
FROM crop_yield_data 
WHERE yield_tonnes_ha IS NULL OR avg_temp IS NULL;

CREATE VIEW Dashboard_India_Global AS
SELECT *,
       -- Adding a flag to easily separate India in Power BI
       CASE 
           WHEN Area = 'India' THEN 'India' 
           ELSE 'Rest of World' 
       END AS Region_Category
FROM crop_yield_data;

SELECT * FROM crop_yield_data;



