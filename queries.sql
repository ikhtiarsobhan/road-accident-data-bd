-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- In this  file, write (and comment!) the typical  queries users will run on your database

-- 1. Total Number of Accidents
-- -- Purpose: Provides the total number of accidents recorded in the database.
-- Insight: Gives a baseline understanding of the dataset size.

SELECT COUNT(*) AS total_accidents
FROM accidents;


-- 2. Accidents by Administrative Location
-- Purpose: Lists the number of accidents in each administrative location.--Insight: Helps identify areas with the highest number of accidents, indicating potential hotspots that require attention.

SELECT l.administrative_location, COUNT(a.accident_id) AS accident_count
FROM accidents a
JOIN locations l ON a.location_id = l.location_id
GROUP BY l.administrative_location
ORDER BY accident_count DESC;

-- 3. Accidents by Road Type

SELECT rt.road_type, COUNT(a.accident_id) AS accident_count
FROM accidents a
JOIN road_types rt ON a.road_type_id = rt.road_type_id
GROUP BY rt.road_type
ORDER BY accident_count DESC;


-- Purpose: Shows the distribution of accidents across different road types.
--Insight: Identifies which road types are more prone to accidents, informing infrastructure planning and safety measures.

--4. Accidents by Time of Day

SELECT
  CASE
    WHEN EXTRACT(HOUR FROM accident_time) BETWEEN 0 AND 5 THEN 'Late Night (12am-6am)'
    WHEN EXTRACT(HOUR FROM accident_time) BETWEEN 6 AND 11 THEN 'Morning (6am-12pm)'
    WHEN EXTRACT(HOUR FROM accident_time) BETWEEN 12 AND 17 THEN 'Afternoon (12pm-6pm)'
    ELSE 'Evening (6pm-12am)'
  END AS time_of_day,
  COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY time_of_day
ORDER BY accident_count DESC;


-- Purpose: Categorizes accidents based on the time of day they occurred.
--Insight: Highlights peak hours for accidents, aiding in traffic management and resource allocation.

--5. Accidents by Weather Conditions

SELECT weather_conditions, COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY weather_conditions
ORDER BY accident_count DESC;


-- Purpose: Displays the number of accidents under different weather conditions.
--Insight: Assesses the impact of weather on road safety, informing driver advisories and infrastructure improvements.

--6. Accidents Involving Different Vehicle Types

SELECT vt.vehicle_type, COUNT(av.accident_vehicle_id) AS involvement_count
FROM accident_vehicles av
JOIN vehicle_types vt ON av.vehicle_type_id = vt.vehicle_type_id
GROUP BY vt.vehicle_type
ORDER BY involvement_count DESC;


-- Purpose: Counts how often each vehicle type is involved in accidents.
--Insight: Identifies which vehicle types are most frequently involved in accidents, possibly indicating risk factors associated with certain vehicles.

-- 7. Most Common Accident Types

SELECT at.accident_type, COUNT(a.accident_id) AS accident_count
FROM accidents a
JOIN accident_types at ON a.accident_type_id = at.accident_type_id
GROUP BY at.accident_type
ORDER BY accident_count DESC;


-- Purpose: Lists accident types by their frequency.
--Insight: Helps focus safety campaigns on the most prevalent types of accidents.

-- 8. Accidents by Light Conditions

SELECT light_conditions, COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY light_conditions
ORDER BY accident_count DESC;


-- Purpose: Shows how light conditions affect accident occurrences.
--Insight: Provides data on whether poor lighting contributes significantly to accidents, potentially prompting improvements in street lighting.

-- 9. Total Injuries and Fatalities

SELECT
  SUM(injuries_count) AS total_injuries,
  SUM(fatalities_count) AS total_fatalities
FROM accidents;


-- Purpose: Calculates the total number of injuries and fatalities.
--Insight: Provides an overall measure of the human impact of road accidents.

--10. Average Injuries and Fatalities per Accident Type

SELECT at.accident_type,
       AVG(a.injuries_count) AS avg_injuries,
       AVG(a.fatalities_count) AS avg_fatalities
FROM accidents a
JOIN accident_types at ON a.accident_type_id = at.accident_type_id
GROUP BY at.accident_type
ORDER BY avg_fatalities DESC, avg_injuries DESC;


-- Purpose: Computes the average number of injuries and fatalities for each accident type.
--Insight: Identifies accident types that are typically more severe, aiding in prioritizing safety interventions.

--11. Accidents with the Highest Fatalities

SELECT a.accident_id, a.accident_time, l.administrative_location, a.fatalities_count
FROM accidents a
JOIN locations l ON a.location_id = l.location_id
WHERE a.fatalities_count > 0
ORDER BY a.fatalities_count DESC, a.accident_time DESC
LIMIT 10;


-- Purpose: Lists the top 10 accidents with the highest number of fatalities.
--Insight: Allows for in-depth analysis of the most severe accidents.

--12. Accidents by Road Conditions

SELECT road_conditions, COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY road_conditions
ORDER BY accident_count DESC;


-- Purpose: Shows the number of accidents under different road conditions.
--Insight: Helps assess the impact of road surface conditions on accident rates.

--13. Vehicle Types Most Involved in Fatal Accidents

SELECT vt.vehicle_type, COUNT(DISTINCT av.accident_id) AS fatal_accident_count
FROM accident_vehicles av
JOIN vehicle_types vt ON av.vehicle_type_id = vt.vehicle_type_id
JOIN accidents a ON av.accident_id = a.accident_id
WHERE a.fatalities_count > 0
GROUP BY vt.vehicle_type
ORDER BY fatal_accident_count DESC;


-- Purpose: Identifies which vehicle types are most frequently involved in accidents resulting in fatalities.
--Insight: Guides targeted safety measures for high-risk vehicle types.

--14. Accidents by Location Type

SELECT lt.location_type, COUNT(a.accident_id) AS accident_count
FROM accidents a
JOIN location_types lt ON a.location_type_id = lt.location_type_id
GROUP BY lt.location_type
ORDER BY accident_count DESC;


-- Purpose: Analyzes accidents based on specific location features.
--Insight: Helps determine if certain location types (e.g., intersections, bends) are more prone to accidents.

--15. Accidents by Number of Vehicles Involved

SELECT number_of_vehicles, COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY number_of_vehicles
ORDER BY accident_count DESC;


-- Purpose: Shows how often accidents involve a certain number of vehicles.
--Insight: Indicates whether multi-vehicle accidents are common, informing responses to collision types.

--16. Monthly Accident Trends

SELECT TO_CHAR(accident_time, 'YYYY-MM') AS month, COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY month
ORDER BY month;


-- Purpose: Provides the number of accidents per month.
--Insight: Identifies seasonal patterns or trends in accidents over time.

--17. Correlation Between Weather and Accident Severity

SELECT weather_conditions,
       AVG(injuries_count) AS average_injuries,
       AVG(fatalities_count) AS average_fatalities
FROM accidents
GROUP BY weather_conditions
ORDER BY average_fatalities DESC, average_injuries DESC;


-- Purpose: Examines how weather conditions affect the severity of accidents.
--Insight: Assesses whether certain weather conditions lead to more severe accidents.

--18. Accidents with Multiple Sources

SELECT a.accident_id, COUNT(asrc.source_id) AS source_count
FROM accidents a
JOIN accident_sources asrc ON a.accident_id = asrc.accident_id
GROUP BY a.accident_id
HAVING COUNT(asrc.source_id) > 1
ORDER BY source_count DESC;


-- Purpose: Identifies accidents that have multiple sources of information.
--Insight: May indicate incidents with higher public attention or more significant impacts.

--19. Top Sources of Accident Data

SELECT s.source_type, COUNT(DISTINCT asrc.accident_id) AS accident_count
FROM sources s
JOIN accident_sources asrc ON s.source_id = asrc.source_id
GROUP BY s.source_type
ORDER BY accident_count DESC;


-- Purpose: Determines which sources contribute the most data.
--Insight: Assesses the reliability and coverage of different data sources, informing data collection strategies.

--20. Average Time Between Accident and Reporting
Assuming you have a report_time field in your sources table (if not, this query cannot be run).


SELECT AVG(EXTRACT(EPOCH FROM (s.report_time - a.accident_time))/3600) AS avg_hours_delay
FROM accidents a
JOIN accident_sources asrc ON a.accident_id = asrc.accident_id
JOIN sources s ON asrc.source_id = s.source_id;


-- Purpose: Calculates the average delay between when an accident occurs and when it is reported.
--Insight: Helps understand reporting lags and the timeliness of data.

--21. Accident Severity by Road Type

SELECT rt.road_type,
       AVG(a.injuries_count) AS avg_injuries,
       AVG(a.fatalities_count) AS avg_fatalities
FROM accidents a
JOIN road_types rt ON a.road_type_id = rt.road_type_id
GROUP BY rt.road_type
ORDER BY avg_fatalities DESC, avg_injuries DESC;


-- Purpose: Compares average injuries and fatalities across different road types.
--Insight: Identifies road types that are associated with more severe accidents.

--22. Top 5 Locations with Highest Accident Frequency

SELECT l.precise_location, COUNT(a.accident_id) AS accident_count
FROM accidents a
JOIN locations l ON a.location_id = l.location_id
GROUP BY l.precise_location
ORDER BY accident_count DESC
LIMIT 5;


-- Purpose: Finds specific locations with the highest number of accidents.
--Insight: Pinpoints exact spots needing immediate safety interventions.

--23. Accidents Involving Pedestrians
Assuming 'Pedestrian accident' is one of the accident types.


SELECT a.accident_id, a.accident_time, l.administrative_location
FROM accidents a
JOIN accident_types at ON a.accident_type_id = at.accident_type_id
JOIN locations l ON a.location_id = l.location_id
WHERE at.accident_type = 'Pedestrian accident';


-- Purpose: Retrieves details of accidents involving pedestrians.
--Insight: Aids in pedestrian safety planning and infrastructure improvements.

--24. Distribution of Accidents Over the Week

SELECT to_char(accident_time, 'Day') AS day_of_week, COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY day_of_week
ORDER BY accident_count DESC;


-- Purpose: Shows how accidents are distributed across different days of the week.
--Insight: Identifies if certain days have higher accident rates, which could influence staffing for emergency services.

--25. Impact of Light Conditions on Fatalities

SELECT light_conditions, SUM(fatalities_count) AS total_fatalities
FROM accidents
GROUP BY light_conditions
ORDER BY total_fatalities DESC;


-- Purpose: Analyzes the total fatalities under different light conditions.
--Insight: Determines if poor lighting contributes to more fatal accidents.

--26. Accidents Occurring Near Markets

SELECT a.accident_id, a.accident_time, l.administrative_location
FROM accidents a
JOIN location_types lt ON a.location_type_id = lt.location_type_id
JOIN locations l ON a.location_id = l.location_id
WHERE lt.location_type = 'In front of a market';


-- Purpose: Lists accidents occurring near markets.
--Insight: Highlights the need for better traffic control measures in busy commercial areas.

--27. Fatality Rate by Vehicle Type

SELECT vt.vehicle_type,
       SUM(CASE WHEN a.fatalities_count > 0 THEN 1 ELSE 0 END)::float / COUNT(DISTINCT av.accident_id) AS fatality_rate
FROM accident_vehicles av
JOIN vehicle_types vt ON av.vehicle_type_id = vt.vehicle_type_id
JOIN accidents a ON av.accident_id = a.accident_id
GROUP BY vt.vehicle_type
ORDER BY fatality_rate DESC;


-- Purpose: Calculates the rate of fatal accidents for each vehicle type.
--Insight: Identifies which vehicle types have higher fatality rates, informing targeted safety regulations.

--28. Average Number of Vehicles Involved by Accident Type

SELECT at.accident_type, AVG(a.number_of_vehicles) AS avg_number_of_vehicles
FROM accidents a
JOIN accident_types at ON a.accident_type_id = at.accident_type_id
GROUP BY at.accident_type
ORDER BY avg_number_of_vehicles DESC;


-- Purpose: Determines the average number of vehicles involved in each accident type.
--Insight: Helps understand the complexity and potential causes of different accident types.

--29. Identifying High-Risk Time Periods

SELECT EXTRACT(HOUR FROM accident_time) AS hour_of_day, COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY hour_of_day
ORDER BY accident_count DESC;


-- Purpose: Provides accident counts for each hour of the day.
--Insight: Pinpoints specific hours with high accident rates, which could be critical for implementing time-based safety measures.

-- 30. Relation Between Number of Vehicles and Severity

SELECT number_of_vehicles,
       AVG(injuries_count) AS avg_injuries,
       AVG(fatalities_count) AS avg_fatalities
FROM accidents
GROUP BY number_of_vehicles
ORDER BY number_of_vehicles;


-- Purpose: Examines how the number of vehicles involved affects the severity of accidents.
-- Insight: Determines if multi-vehicle accidents tend to be more severe.
