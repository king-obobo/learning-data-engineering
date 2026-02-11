-- Creating my dataset first
CREATE SCHEMA IF NOT EXISTS `kestra-homework-ebuka.bigquerylesson`
OPTIONS(
  location = 'africa-south1'
);

-- Creating external table referrig ti gcs path
CREATE OR REPLACE EXTERNAL TABLE `kestra-homework-ebuka.bigquerylesson.external_yellow_trip_data`
OPTIONS (
  format = 'CSV',
  uris = ['gs://kestra-homework-ebuka-bucket/yellow_tripdata_2020-*.csv']
);

-- Checking for yellow trip data
SELECT * FROM `kestra-homework-ebuka.bigquerylesson.external_yellow_trip_data` LIMIT 10;

-- Creating a partitioned table from external table
CREATE OR REPLACE TABLE `kestra-homework-ebuka.bigquerylesson.yellow_tripdata_partitioned`
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM `kestra-homework-ebuka.bigquerylesson.external_yellow_trip_data`;

-- Creating a non-partitioned table from external table
CREATE OR REPLACE TABLE `kestra-homework-ebuka.bigquerylesson.yellow_tripdata_non_partitioned` AS 
SELECT * FROM `kestra-homework-ebuka.bigquerylesson.external_yellow_trip_data`;

-- Impact of partition
-- scanning 369.3MB of data
SELECT DISTINCT(VendorID)
FROM `kestra-homework-ebuka.bigquerylesson.yellow_tripdata_non_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2020-02-01' AND '2020-02-29';

--SCANNING 95.75MB of data
SELECT DISTINCT(VendorID)
FROM `kestra-homework-ebuka.bigquerylesson.yellow_tripdata_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2020-02-01' AND '2020-02-29';

-- Taking a look at the Partitions
SELECT table_name, partition_id, total_rows
FROM `bigquerylesson.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitioned'
ORDER BY total_rows DESC;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE kestra-homework-ebuka.bigquerylesson.yellow_tripdata_partitioned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `kestra-homework-ebuka.bigquerylesson.external_yellow_trip_data`;

-- Query scans 369.93 GB
SELECT count(*) as trips
FROM `kestra-homework-ebuka.bigquerylesson.yellow_tripdata_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

-- Query scans 310.08MB
SELECT count(*) as trips
FROM `kestra-homework-ebuka.bigquerylesson.yellow_tripdata_partitioned_clustered`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;
