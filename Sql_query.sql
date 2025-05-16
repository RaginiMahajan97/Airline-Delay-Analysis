create database project;
use project;

CREATE TABLE flights (
    YEAR INT,
    MONTH INT,
    DAY INT,
    DAY_OF_WEEK INT,
    FLIGHT_NUMBER VARCHAR(10),
    TAIL_NUMBER VARCHAR(10),
    DESTINATION_AIRPORT VARCHAR(10),
    SCHEDULED_DEPARTURE INT,
    DEPARTURE_TIME FLOAT,
    DEPARTURE_DELAY FLOAT,
    TAXI_OUT FLOAT,
    WHEELS_OFF INT,
    SCHEDULED_TIME FLOAT,
    ELAPSED_TIME FLOAT,
    AIR_TIME FLOAT,
    DISTANCE FLOAT,
    WHEELS_ON INT,
    TAXI_IN FLOAT,
    SCHEDULED_ARRIVAL INT,
    ARRIVAL_TIME FLOAT,
    ARRIVAL_DELAY FLOAT,
    DIVERTED INT,
    CANCELLED INT,
    CANCELLATION_REASON VARCHAR(5),
    AIR_SYSTEM_DELAY FLOAT,
    SECURITY_DELAY FLOAT,
    AIRLINE_DELAY FLOAT,
    LATE_AIRCRAFT_DELAY FLOAT,
    WEATHER_DELAY FLOAT,
    AIRLINE_y VARCHAR(100),
    ORIGIN_AIRPORT_y VARCHAR(100),
    ORIGIN_CITY VARCHAR(50),
    ORIGIN_STATE VARCHAR(5),
    ORIGIN_COUNTRY VARCHAR(50),
    DEST_IATA_CODE VARCHAR(10),
    DEST_AIRPORT VARCHAR(100),
    DEST_CITY VARCHAR(50),
    DEST_STATE VARCHAR(5),
    DEST_COUNTRY VARCHAR(50),
    CANCELLATION_DESCRIPTION VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/final_dataset.csv'
INTO TABLE flights
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM flights;

## Find the most delayed routes (origin-destination pairs).

SELECT 
    ORIGIN_AIRPORT_y AS origin,
    DEST_AIRPORT AS destination,
    AVG(ARRIVAL_DELAY) AS avg_arrival_delay
FROM flights
GROUP BY ORIGIN_AIRPORT_y, DEST_AIRPORT
ORDER BY avg_arrival_delay DESC
LIMIT 10;

## Calculate average delay per airline.

SELECT 
    AIRLINE_y AS airline,
    AVG(DEPARTURE_DELAY) AS avg_departure_delay,
    AVG(ARRIVAL_DELAY) AS avg_arrival_delay
FROM flights
GROUP BY AIRLINE_y
ORDER BY avg_arrival_delay DESC;

## Retrieve total number of flights per airport.

SELECT 
    ORIGIN_AIRPORT_y AS airport,
    COUNT(*) AS total_flights
FROM flights
GROUP BY ORIGIN_AIRPORT_y
ORDER BY total_flights DESC;

## Count how many delays are due to weather, carrier, security, etc.

SELECT 
    SUM(WEATHER_DELAY) AS total_weather_delay,
    SUM(AIRLINE_DELAY) AS total_carrier_delay,
    SUM(SECURITY_DELAY) AS total_security_delay,
    SUM(AIR_SYSTEM_DELAY) AS total_system_delay,
    SUM(LATE_AIRCRAFT_DELAY) AS total_late_aircraft_delay
FROM flights;

## Determine the average departure and arrival delay per month.

SELECT 
    MONTH,
    AVG(DEPARTURE_DELAY) AS avg_departure_delay,
    AVG(ARRIVAL_DELAY) AS avg_arrival_delay
FROM flights
GROUP BY MONTH
ORDER BY MONTH;

## Identify top 5 airports with the highest number of delayed departures.

SELECT 
    ORIGIN_AIRPORT_y AS airport,
    COUNT(*) AS delayed_departures
FROM flights
WHERE DEPARTURE_DELAY > 15
GROUP BY ORIGIN_AIRPORT_y
ORDER BY delayed_departures DESC
LIMIT 5;



## Get cancellation rate per airline.

SELECT 
    AIRLINE_y AS airline,
    COUNT(*) AS total_flights,
    SUM(CANCELLED) AS cancelled_flights,
    ROUND(SUM(CANCELLED) * 100.0 / COUNT(*), 2) AS cancellation_rate_percent
FROM flights
GROUP BY AIRLINE_y
ORDER BY cancellation_rate_percent DESC;
