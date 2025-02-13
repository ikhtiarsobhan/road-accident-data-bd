# road-accident-data-bd
A database to store road accidents and related data that will help to make roads safer


# Design Document

By Mohammad Ikhtiar Sobhan

Video overview: <URL HERE>

## Scope

# Purpose of the Database
The purpose of this database is to create a comprehensive and detailed repository of road accident data in Bangladesh. The database aims to capture various aspects of each accident to facilitate analysis, identify patterns, and contribute to improving road safety measures.

# Included in the Scope
Accidents: Detailed records including time, precise location, road conditions, and outcomes.
Locations: Both precise (GPS coordinates) and administrative locations (district, upazila).
Road Types: Classification of roads such as highways, city roads, rural roads, etc.
Location Types: Specific features of the location like bends, markets, intersections.
Accident Types: Types of accidents including head-on collisions, rear-endings, rollovers.
Vehicle Types: Different vehicles involved such as cars, buses, motorcycles, trucks.
Weather Conditions: Weather at the time of the accident (e.g., clear, rainy, foggy).
Light Conditions: Lighting conditions during the accident (e.g., daylight, dawn, night).
Road Conditions: State of the road (e.g., dry, wet, icy).
Injuries and Fatalities: Number of injuries and fatalities resulting from the accident.
Sources: Multiple sources for each accident including online news portals, police records, public court records, print articles.

# Outside the Scope
Personal Data: Information about individuals involved (names, contact details) is excluded to maintain privacy.
Financial Data: Insurance claims or economic impact details are not included.
Real-time Tracking: The database does not provide live updates or tracking of accidents.
International Data: The focus is solely on Bangladesh; accidents outside this region are not covered.

## Functional Requirements

### User Capabilities

A user should be able to:

- **Record Accidents**: Input detailed information about new road accidents.
- **Query Data**: Retrieve accident records based on various criteria such as location, time, accident type, etc.
- **Perform Analysis**: Run statistical queries to gain insights into patterns and trends.
- **Access Sources**: View the sources of information linked to each accident.
- **Generate Reports**: Create reports summarizing key statistics and findings.

### Beyond the Scope

A user should not be able to:

- **Access Personal Information**: Since personal data is not stored, users cannot retrieve such information.
- **Modify Core Schema**: Users cannot alter the database structure without appropriate permissions.
- **Integrate External Systems**: The database does not support direct integration with external systems like traffic control or emergency services.
- **Real-time Monitoring**: Users cannot use the database for live monitoring of accidents or traffic conditions.

## Representation

### Entities

#### Accidents

- **Attributes**:
  - `accident_id` (Primary Key)
  - `accident_time` (Timestamp)
  - `location_id` (Foreign Key to Locations)
  - `road_type_id` (Foreign Key to Road_Types)
  - `location_type_id` (Foreign Key to Location_Types)
  - `accident_type_id` (Foreign Key to Accident_Types)
  - `number_of_vehicles` (Integer)
  - `weather_conditions` (Text)
  - `light_conditions` (Text)
  - `road_conditions` (Text)
  - `police_report_number` (Text)
  - `injuries_count` (Integer)
  - `fatalities_count` (Integer)

- **Reasoning**:
  - **Data Types**: Chosen to accurately represent the nature of each attribute (e.g., `TIMESTAMP` for time, `INTEGER` for counts).
  - **Constraints**: Foreign keys ensure referential integrity with related entities, and primary keys uniquely identify each accident.

#### Locations

- **Attributes**:
  - `location_id` (Primary Key)
  - `precise_location` (Text)
  - `administrative_location` (Text)

- **Reasoning**: Separating location information allows for efficient querying and normalization, avoiding data redundancy.

#### Road_Types

- **Attributes**:
  - `road_type_id` (Primary Key)
  - `road_type` (Text)

- **Reasoning**: Standardizing road types ensures consistency in data entry and analysis.

#### Location_Types

- **Attributes**:
  - `location_type_id` (Primary Key)
  - `location_type` (Text)

- **Reasoning**: Capturing specific location features helps in identifying high-risk areas.

#### Accident_Types

- **Attributes**:
  - `accident_type_id` (Primary Key)
  - `accident_type` (Text)

- **Reasoning**: Categorizing accidents facilitates targeted safety measures.

#### Vehicle_Types

- **Attributes**:
  - `vehicle_type_id` (Primary Key)
  - `vehicle_type` (Text)

- **Reasoning**: Tracking vehicle types involved in accidents helps in understanding vehicle-specific risks.

#### Accident_Vehicles

- **Attributes**:
  - `accident_vehicle_id` (Primary Key)
  - `accident_id` (Foreign Key to Accidents)
  - `vehicle_type_id` (Foreign Key to Vehicle_Types)
  - `vehicle_count` (Integer)

- **Reasoning**: This associative entity handles the many-to-many relationship between accidents and vehicle types.

#### Sources

- **Attributes**:
  - `source_id` (Primary Key)
  - `source_type` (Text)
  - `link` (Text)
  - `title` (Text)
  - `newspaper_portal_name` (Text)
  - `other_details` (Text)

- **Reasoning**: Storing source details aids in data verification and credibility assessment.

#### Accident_Sources

- **Attributes**:
  - `accident_source_id` (Primary Key)
  - `accident_id` (Foreign Key to Accidents)
  - `source_id` (Foreign Key to Sources)

- **Reasoning**: Manages the many-to-many relationship between accidents and their sources.

### Why These Types and Constraints

- **Data Types**: Selected based on the nature of the data to ensure data integrity and appropriate storage.
- **Constraints**:
  - **Primary Keys**: Ensure each record is unique.
  - **Foreign Keys**: Maintain referential integrity across related tables.
  - **Allowing Nulls**: Omitted `NOT NULL` constraints to accommodate partial data and ease data entry.

### Relationships

![ERD Diagram](erd_diagram.png)

*(Please refer to the `erd_diagram.png` file for the visual representation of the ERD.)*

#### Description of Relationships

- **Accidents ↔ Locations**: One accident occurs at one location, but a location can have many accidents over time (One-to-Many).
- **Accidents ↔ Road_Types**: Each accident is associated with one road type (One-to-Many).
- **Accidents ↔ Location_Types**: Each accident has one location type (One-to-Many).
- **Accidents ↔ Accident_Types**: Each accident has one accident type (One-to-Many).
- **Accidents ↔ Accident_Vehicles**: An accident can involve multiple vehicles (One-to-Many).
- **Accident_Vehicles ↔ Vehicle_Types**: Each accident vehicle record references one vehicle type (Many-to-One).
- **Accidents ↔ Accident_Sources**: An accident can have multiple sources (One-to-Many).
- **Accident_Sources ↔ Sources**: Each accident source record references one source (Many-to-One).

## Optimizations

### Indexes

- **Purpose**: Improve query performance on frequently searched columns.
- **Indexes Created**:
  - On `accident_time` in Accidents to speed up time-based queries.
  - On foreign key fields like `location_id`, `road_type_id`, `vehicle_type_id` for efficient joins.
  - On attributes like `weather_conditions`, `light_conditions` to enhance condition-based queries.

### Views

- **Purpose**: Simplify complex queries and provide readily accessible summarized data.
- **Views Created**:
  - `total_accidents`: Provides a quick count of all accidents.
  - `accidents_by_road_type`: Summarizes accidents based on road types.
  - `accidents_by_vehicle_type`: Analyzes accidents involving different vehicle types.
  - `total_injuries_and_fatalities`: Aggregates total injuries and fatalities.

### Reasoning

- **Performance**: Indexes significantly reduce data retrieval time for large datasets.
- **Usability**: Views offer users easy access to common queries without needing to write complex SQL statements.


## Limitations

- **Data Completeness**: Allowing null values may result in incomplete records, affecting analysis accuracy.
- **Dynamic Data**: The database is not designed for real-time data entry or updates, limiting its use for live monitoring.
- **Personal Data Exclusion**: The absence of personal identifiers prevents analyses involving driver behavior or demographics.
- **Geographic Specificity**: Focused solely on Bangladesh, so it's not immediately applicable to other regions without modifications.
- **External Integration**: Limited capacity to integrate with external systems like GIS mapping or traffic management software.

### Potential Challenges

- **Data Entry Consistency**: Relies on consistent data entry practices to maintain data integrity across various attributes.
- **Scalability**: As data volume grows, further optimizations may be necessary to maintain performance.
- **Maintenance**: Regular updates to road types, vehicle types, and other categorical data are required to keep the database current.
