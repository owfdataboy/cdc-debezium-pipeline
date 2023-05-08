# Debezium do Change Data Capture with Postgres Source to Google Cloud Storage Sink

## Document pipeline

The workflow is reported in: [here](https://app.diagrams.net/#G1Z49aNm1p2B1VoEbvWlsSvBCsZn95zdLD)

## Goal

The goal of this project is to:

-   Capture data change in Postgres database to Google Cloud BigQuery

## Workflow

-   Debezium Connector captures data change in Postgres database and publish messages to Apache Kafka
-   Apache Kafka is a message queue that decouple source and destination
-   Aapche Spark is responsible for processing data in Apache Kafka and load data to Google Cloud BigQuery
-   Use Prometheus to get metrics from Spark applications and Node-exporter
-   Use Grafana to display the metrics collected

## Notes

-   Spark version running is 3.0.2
-   For all available metrics for Spark monitoring see [here](https://spark.apache.org/docs/2.2.0/monitoring.html#metrics).
-   The containerized environment consists of a Master, a Worker.
-   To track metrics across Spark apps, appName needs to be set up or else the spark.metrics.namespace will be spark.app.id that changes after every invocation of the app.
-   Main Scala Application running is Kafka Streaming Project-assembly-0.2.0.jar that is streaming job execution ingest to BigQuery.
-   Dockerfile for Spark/Hadoop is also available [here](https://hub.docker.com/repository/docker/nikoshet/spark-hadoop/general) in order to add it in docker-compose.yaml file as seen [here](https://github.com/nikoshet/monitoring-spark-on-docker/blob/820dee01d771e8cf6ec3a7b27ede8aa0eeef2214/docker-compose.yaml#L54).

## Usage

Assuming that Docker is installed, simply execute the following command to build and run the Docker Containers:

```
docker-compose -f docker-compose.postgres.yaml -f docker-compose.kafka.yaml -f docker-compose.debezium.yaml -f docker-compose.spark.yaml build && docker-compose -f docker-compose.postgres.yaml -f docker-compose.kafka.yaml -f docker-compose.debezium.yaml -f docker-compose.spark.yaml up
```

To shutdown Docker Containers, execute the following command:

```
docker-compose -f docker-compose.postgres.yaml -f docker-compose.kafka.yaml -f docker-compose.debezium.yaml -f docker-compose.spark.yaml down
```
