-- Creating external table referring to GCS path
CREATE OR REPLACE EXTERNAL TABLE `kestra-sand-487719.zoomcamp.external_yellow_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://will-zoomcamp/yellow_tripdata_2019-*.csv']
);
-- Check yellow trip data
SELECT *
FROM `kestra-sand-487719.zoomcamp.external_yellow_tripdata`
LIMIT 10;

-- Create a non-partitioned table from external table
CREATE OR REPLACE TABLE `kestra-sand-487719.zoomcamp.yellow_tripdata_non_partitioned` AS
SELECT *
FROM `kestra-sand-487719.zoomcamp.external_yellow_tripdata`;

-- Create a partitioned table from external table
CREATE OR REPLACE TABLE `kestra-sand-487719.zoomcamp.yellow_tripdata_partitioned`
PARTITION BY DATE(tpep_pickup_datetime) AS
SELECT *
FROM `kestra-sand-487719.zoomcamp.external_yellow_tripdata`;

--Impact of partitioning
--Scanning 1.56 GB data --
SELECT DISTINCT (VendorID)
FROM `kestra-sand-487719.zoomcamp.yellow_tripdata_non_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';
--Scanning 106 MB data ---
SELECT DISTINCT (VendorID)
FROM `kestra-sand-487719.zoomcamp.yellow_tripdata_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Let's look into the partitions
SELECT table_name, partition_id, total_rows
FROM `zoomcamp.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitioned'
ORDER BY total_rows DESC;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE `kestra-sand-487719.zoomcamp.yellow_tripdata_partitioned_clustered`
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `kestra-sand-487719.zoomcamp.external_yellow_tripdata`;

-- Query scans 1.1 GB
SELECT count(*) as trips
FROM `kestra-sand-487719.zoomcamp.yellow_tripdata_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

SELECT count(*) as trips
FROM `kestra-sand-487719.zoomcamp.yellow_tripdata_partitioned_clustered`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;




