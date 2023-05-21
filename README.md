# Debezium do Change Data Capture with Postgres Source to GCP

## Workflow

The workflow is reported in: [here](https://app.diagrams.net/#G1Z49aNm1p2B1VoEbvWlsSvBCsZn95zdLD)

## Goal

The goal of this project is to:
-   Capture data change in Postgres database to Google Cloud Storage Sink
-   Capture data change in Postgres database to Google Cloud BigQuery Sink (Incoming)

## Workflow

-   Debezium Connector captures data change in Postgres database and publish messages to Apache Kafka
-   Apache Kafka is a message queue that decouple source and destination
-   Debezium (Kafka Connect) is responsible for processing data in Apache Kafka and load data to Google Cloud Storage, Google Cloud BigQuery
-   Use Kafka UI to manage and monitor Kafka Cluster

## Deployment

Assuming that Docker is installed, simply execute the following command to build and run the Docker Containers:

```
docker compose -f postgres.docker-compose.yaml -f kafka.docker-compose.yaml -f debezium.docker-compose.yaml up
```

To shutdown Docker Containers, execute the following command:

```
docker compose -f postgres.docker-compose.yaml -f kafka.docker-compose.yaml -f debezium.docker-compose.yaml down
```

## Preview
## Use Kafka UI to manage Broker, Topic, Partition, Connector (Kafka Connect), metadata and so on....
### Kafka Broker
![](.github/.screenshot/kafka-broker.png)

### Kafka Topic
![](.github/.screenshot/kafka-topic.png)

### Kafka Connector
![](.github/.screenshot/kafka-connector.png)

### Google Cloud Storage sink
![](.github/.screenshot/gcs.png)

### Google Cloud BigQuery sink
![](.github/.screenshot/bq.png)
