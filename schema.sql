-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it
-- This Schema is for a PostgreSQL database


-- Table: accidents
-- Stores detailed information about each accident
CREATE TABLE accidents (
    accident_id SERIAL PRIMARY KEY,          -- Unique identifier for each accident
    accident_time TIMESTAMP,                 -- Date and time of the accident
    location_id INTEGER,                     -- Reference to the location where the accident occurred
    road_type_id INTEGER,                    -- Reference to the type of road where the accident occurred
    location_type_id INTEGER,                -- Reference to the type of location (e.g., bend, market)
    accident_type_id INTEGER,                -- Reference to the type of accident (e.g., head-on collision)
    number_of_vehicles INTEGER,              -- Number of vehicles involved in the accident
    weather_conditions TEXT,                 -- Weather conditions at the time of the accident
    light_conditions TEXT,                   -- Light conditions at the time of the accident
    road_conditions TEXT,                    -- Road conditions at the time of the accident
    police_report_number TEXT,               -- Police report number associated with the accident
    injuries_count INTEGER,                  -- Number of injuries resulting from the accident
    fatalities_count INTEGER,                -- Number of fatalities resulting from the accident
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (road_type_id) REFERENCES road_types(road_type_id),
    FOREIGN KEY (location_type_id) REFERENCES location_types(location_type_id),
    FOREIGN KEY (accident_type_id) REFERENCES accident_types(accident_type_id)
);

-- Table: locations
-- Stores information about locations
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,          -- Unique identifier for each location
    precise_location TEXT,                   -- Precise location details (e.g., GPS coordinates or street address)
    administrative_location TEXT             -- Administrative location details (e.g., district, upazila)
);

-- Table: road_types
-- Stores different types of roads
CREATE TABLE road_types (
    road_type_id SERIAL PRIMARY KEY,         -- Unique identifier for each road type
    road_type TEXT                           -- Description of the road type (e.g., Highway, City road)
);

-- Table: location_types
-- Stores different types of locations
CREATE TABLE location_types (
    location_type_id SERIAL PRIMARY KEY,     -- Unique identifier for each location type
    location_type TEXT                       -- Description of the location type (e.g., bend, market)
);

-- Table: accident_types
-- Stores different types of accidents
CREATE TABLE accident_types (
    accident_type_id SERIAL PRIMARY KEY,     -- Unique identifier for each accident type
    accident_type TEXT                       -- Description of the accident type (e.g., head-on collision)
);

-- Table: vehicle_types
-- Stores different types of vehicles
CREATE TABLE vehicle_types (
    vehicle_type_id SERIAL PRIMARY KEY,      -- Unique identifier for each vehicle type
    vehicle_type TEXT                        -- Description of the vehicle type (e.g., Car, Bus)
);

-- Table: accident_vehicles
-- Stores information about vehicles involved in accidents
CREATE TABLE accident_vehicles (
    accident_vehicle_id SERIAL PRIMARY KEY,  -- Unique identifier for each accident-vehicle relationship
    accident_id INTEGER,                     -- Reference to the accident
    vehicle_type_id INTEGER,                 -- Reference to the type of vehicle involved
    vehicle_count INTEGER,                   -- Number of vehicles of this type involved in the accident
    FOREIGN KEY (accident_id) REFERENCES accidents(accident_id),
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(vehicle_type_id)
);

-- Table: sources
-- Stores information about sources of information for each accident
CREATE TABLE sources (
    source_id SERIAL PRIMARY KEY,            -- Unique identifier for each source
    source_type TEXT,                        -- Type of source (e.g., Online news portal, Police record)
    link TEXT,                               -- Link to the online news article (if applicable)
    title TEXT,                              -- Title of the news article (if applicable)
    newspaper_portal_name TEXT,              -- Name of the newspaper or online portal (if applicable)
    other_details TEXT                       -- Other details about the source (e.g., court record, print article details)
);

-- Table: accident_sources
-- Stores the relationship between accidents and their sources
CREATE TABLE accident_sources (
    accident_source_id SERIAL PRIMARY KEY,   -- Unique identifier for each accident-source relationship
    accident_id INTEGER,                     -- Reference to the accident
    source_id INTEGER,                       -- Reference to the source
    FOREIGN KEY (accident_id) REFERENCES accidents(accident_id),
    FOREIGN KEY (source_id) REFERENCES sources(source_id)
);

-- Indexes
-- Indexes to speed up queries on frequently accessed columns
CREATE INDEX idx_accidents_accident_time ON accidents(accident_time);
CREATE INDEX idx_accidents_location_id ON accidents(location_id);
CREATE INDEX idx_accidents_road_type_id ON accidents(road_type_id);
CREATE INDEX idx_accidents_location_type_id ON accidents(location_type_id);
CREATE INDEX idx_accidents_accident_type_id ON accidents(accident_type_id);
CREATE INDEX idx_accidents_weather_conditions ON accidents(weather_conditions);
CREATE INDEX idx_accidents_light_conditions ON accidents(light_conditions);
CREATE INDEX idx_accidents_road_conditions ON accidents(road_conditions);

CREATE INDEX idx_locations_administrative_location ON locations(administrative_location);

CREATE INDEX idx_accident_vehicles_accident_id ON accident_vehicles(accident_id);
CREATE INDEX idx_accident_vehicles_vehicle_type_id ON accident_vehicles(vehicle_type_id);

CREATE INDEX idx_accident_sources_accident_id ON accident_sources(accident_id);
CREATE INDEX idx_accident_sources_source_id ON accident_sources(source_id);

-- Views
-- Views to simplify and frequently access complex queries
CREATE VIEW total_accidents AS
SELECT COUNT(*) AS total_accidents
FROM accidents;

CREATE VIEW accidents_by_road_type AS
SELECT rt.road_type, COUNT(a.accident_id) AS accident_count
FROM accidents a
JOIN road_types rt ON a.road_type_id = rt.road_type_id
GROUP BY rt.road_type;

CREATE VIEW accidents_by_location_type AS
SELECT lt.location_type, COUNT(a.accident_id) AS accident_count
FROM accidents a
JOIN location_types lt ON a.location_type_id = lt.location_type_id
GROUP BY lt.location_type;

CREATE VIEW accidents_by_accident_type AS
SELECT at.accident_type, COUNT(a.accident_id) AS accident_count
FROM accidents a
JOIN accident_types at ON a.accident_type_id = at.accident_type_id
GROUP BY at.accident_type;

CREATE VIEW accidents_by_time_of_day AS
SELECT EXTRACT(HOUR FROM accident_time) AS hour_of_day, COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY EXTRACT(HOUR FROM accident_time)
ORDER BY hour_of_day;

CREATE VIEW accidents_by_weather_conditions AS
SELECT weather_conditions, COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY weather_conditions;

CREATE VIEW accidents_by_vehicle_type AS
SELECT vt.vehicle_type, COUNT(av.accident_vehicle_id) AS accident_count
FROM accident_vehicles av
JOIN vehicle_types vt ON av.vehicle_type_id = vt.vehicle_type_id
GROUP BY vt.vehicle_type;

CREATE VIEW total_injuries_and_fatalities AS
SELECT SUM(injuries_count) AS total_injuries, SUM(fatalities_count) AS total_fatalities
FROM accidents;

CREATE VIEW accidents_by_administrative_location AS
SELECT l.administrative_location, COUNT(a.accident_id) AS accident_count
FROM accidents a
JOIN locations l ON a.location_id = l.location_id
GROUP BY l.administrative_location;

CREATE VIEW accidents_with_more_than_2_vehicles AS
SELECT COUNT(accident_id) AS accidents_with_more_than_2_vehicles
FROM accidents
WHERE number_of_vehicles > 2;
