-- Creating my dataset first
CREATE SCHEMA IF NOT EXISTS `kestra-homework-ebuka.bigqueryhw`
OPTIONS(
  location = 'us'
);

-- Creating an external table using the Yellow Taxi Trip Records.
CREATE OR REPLACE EXTERNAL TABLE `kestra-homework-ebuka.bigqueryhw.external_yellow_trip_data`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://bigquery-homework/yellow_tripdata_2024-*.parquet']
);

-- Ensuring data is correct
SELECT * FROM `kestra-homework-ebuka.bigqueryhw.external_yellow_trip_data` LIMIT 10;


-- What is count of records for the 2024 Yellow Taxi Data?
SELECT COUNT(*) FROM `kestra-homework-ebuka.bigqueryhw.external_yellow_trip_data`;
-- ANS: 20,332,093

-- Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
-- What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
SELECT COUNT(DISTINCT(PULocationID)) FROM `kestra-homework-ebuka.bigqueryhw.external_yellow_trip_data`;
-- ANS: 0 MB for the External Table and 155.12 MB for the Materialized Table

-- How many records have a fare_amount of 0?
SELECT COUNT(*) FROM `kestra-homework-ebuka.bigqueryhw.external_yellow_trip_data` WHERE fare_amount = 0;
-- ANS: 8,333

-- Creating a non-partitioned table from external table
CREATE OR REPLACE TABLE `kestra-homework-ebuka.bigqueryhw.yellow_tripdata_non_partitioned` AS 
SELECT * FROM `kestra-homework-ebuka.bigqueryhw.external_yellow_trip_data`;


-- Creating a partitioned table from external table which filter based on tpep_dropoff_datetime and order the results by VendorID
CREATE OR REPLACE TABLE `kestra-homework-ebuka.bigqueryhw.yellow_tripdata_partitioned`
PARTITION BY
  DATE(tpep_dropoff_datetime) 
CLUSTER BY 
  VendorID AS
SELECT * FROM `kestra-homework-ebuka.bigqueryhw.external_yellow_trip_data`;


-- Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)
SELECT DISTINCT(VendorID) FROM `kestra-homework-ebuka.bigqueryhw.yellow_tripdata_non_partitioned`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';
-- 310.24MB

SELECT DISTINCT(VendorID) FROM `kestra-homework-ebuka.bigqueryhw.yellow_tripdata_partitioned`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';
-- 26.84MB


-- Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
SELECT COUNT(*) FROM `kestra-homework-ebuka.bigqueryhw.yellow_tripdata_non_partitioned`;
-- 0B

