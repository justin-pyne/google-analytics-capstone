-- Create aggregate table
SELECT * FROM `cyclistic-case-study-378619.tripdata.202202`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202203`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202204`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202205`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202206`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202207`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202208`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202209`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202210`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202211`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202212`
UNION ALL
SELECT * FROM `cyclistic-case-study-378619.tripdata.202301`;


-- (We save the result as a BigQuery table)


-- Get count of records with null member_casual
SELECT count(*) as null_count
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
WHERE member_casual is null;


-- Get count of records with duplicate ride_id
SELECT ride_id, count(ride_id) as duplicate_count
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
GROUP BY ride_id HAVING COUNT (ride_id) > 1;


-- Check for spaces around string values
SELECT rideable_type,
start_station_name,
end_station_name,
member_casual
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
WHERE rideable_type LIKE ' %' 
OR rideable_type LIKE '% '
OR start_station_name LIKE ' %' 
OR rideable_type LIKE '% '
OR end_station_name LIKE ' %' 
OR rideable_type LIKE '% ';


-- Check for misspellings in rideable_type, member_casual
SELECT rideable_type,
member_casual
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
GROUP BY rideable_type, member_casual;


-- Get count of records with either null start_station_name or end_station_name
SELECT COUNT(*) AS records_count
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
WHERE start_station_name IS NULL OR end_station_name IS NULL;


-- Delete records with null member_casual
DELETE FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
WHERE member_casual is null;


-- Delete records with duplicate ride_id
DELETE FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
WHERE ride_id IN
(
  SELECT ride_id
  FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
  GROUP BY ride_id HAVING count(ride_id) > 1
);


-- Total members
SELECT count(ride_id) as total_members
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`;


-- Distribution of members
SELECT member_casual as membership, count(member_casual) as member_count
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
GROUP BY member_casual;


-- Preferred type of bike by member type
SELECT member_casual as membership, rideable_type, count(rideable_type) as bike_count
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
GROUP BY member_casual, rideable_type
ORDER BY member_casual, rideable_type;


-- Average ride duration by member type
SELECT member_casual as membership, round(avg(date_diff(ended_at, started_at, minute)),0) as avg_ride_duration
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
GROUP BY member_casual;


-- Number of rides by day of the week and member type
SELECT member_casual as membership, day_of_week, count(ride_id) as rides_count
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
GROUP BY member_casual, day_of_week
ORDER BY member_casual, day_of_week;


-- Ride duration by day of the week and member type
SELECT member_casual as membership, day_of_week, round(avg(date_diff(ended_at, started_at, minute)),0) as avg_ride_duration
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
GROUP BY member_casual, day_of_week
ORDER BY member_casual, day_of_week;


-- Ride count and average ride duration per month for casual members
SELECT extract(month from started_at) as month, count(ride_id) as ride_count, round(avg(date_diff(ended_at, started_at, minute)),0) as avg_ride_duration
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
WHERE member_casual in ("casual")
GROUP BY month
ORDER BY month;


-- Ride count and average ride duration per month for annual members
SELECT extract(month from started_at) as month, count(ride_id) as ride_count, round(avg(date_diff(ended_at, started_at, minute)),0) as avg_ride_duration
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
WHERE member_casual in ("member")
GROUP BY month
ORDER BY month;


-- Average duration of rides with same start and end station 
SELECT count(ride_id) as ride_count,
round(avg(date_diff(ended_at, started_at, minute)),0) as avg_ride_duration,
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
WHERE start_station_name = end_station_name;


-- Average duration of rides with different start and end station
SELECT count(ride_id) as ride_count,
round(avg(date_diff(ended_at, started_at, minute)),0) as avg_ride_duration,
FROM `cyclistic-case-study-378619.tripdata.mastertripdata`
WHERE start_station_name != end_station_name;
