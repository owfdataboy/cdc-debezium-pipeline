# Debezium do Change Data Capture with Postgres Source to Google Cloud Platform

## Pipeline Architecture

The workflow is reported in: [here](https://app.diagrams.net/#G1Z49aNm1p2B1VoEbvWlsSvBCsZn95zdLD)

## Goal

The goal of this project is to:
-   Capture data change in Postgres database to Google Cloud Storage Sink
-   Capture data change in Postgres database to Google Cloud BigQuery Sink

## Workflow
-   Distributed RDBMS Postgres with [Citus extension](https://github.com/citusdata/citus) use to store sample co-located transaction table across Citus Cluster
-   Debezium Connector captures data change in Postgres database and publish messages to Apache Kafka
-   Apache Kafka is a message queue that decouple source and destination. In this scope, use single node Kafka Broker to develop
-   Debezium (Kafka Connect) integrate with [Sink Connector of Confluent Platform](https://docs.confluent.io/platform/current/connect/kafka_connectors.html) is responsible for processing data in Apache Kafka and load data to Google Cloud Storage, Google Cloud BigQuery
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
## Execution Plan on Postgres Citus Cluster
```
-- insert some events
INSERT INTO events (device_id, data)
SELECT s % 100, ('{"measurement":'||random()||'}')::jsonb FROM generate_series(1,1000000) s;

-- get the last 3 events for device 1, routed to a single node
SELECT * FROM events WHERE device_id = 1 ORDER BY event_time DESC, event_id DESC LIMIT 3;
┌───────────┬──────────┬───────────────────────────────┬───────────────────────────────────────┐
│ device_id │ event_id │          event_time           │                 data                  │
├───────────┼──────────┼───────────────────────────────┼───────────────────────────────────────┤
│         1 │  1999901 │ 2023-05-22 15:28:23.700068+00 │ {"measurement": 0.88722643925054}     │
│         1 │  1999801 │ 2023-05-22 15:28:23.700068+00 │ {"measurement": 0.6512231304621992}   │
│         1 │  1999701 │ 2023-05-22 15:28:23.700068+00 │ {"measurement": 0.019368766051897524} │
└───────────┴──────────┴───────────────────────────────┴───────────────────────────────────────┘
(3 rows)

Query complete 00:00:00.181

-- explain plan for a query that is parallelized across shards, which shows the plan for
-- a query one of the shards and how the aggregation across shards is done
EXPLAIN (VERBOSE ON) SELECT count(*) FROM events;
┌───────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                QUERY PLAN                                                 │
├───────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Aggregate  (cost=250.00..250.02 rows=1 width=8)                                                           │
│   Output: COALESCE((pg_catalog.sum(remote_scan.count))::bigint, '0'::bigint)                              │
│   -> Custom Scan (Citus Adaptive)  (cost=0.00..0.00 rows=100000 width=8)                                  │
│         ...                                                                                               │
│       ->  Task                                                                                            │
│              Query: SELECT count(*) AS count FROM events_102008 events WHERE true                         │
│              Node: host=cdc-debezium-postgres-pipeline-worker-1 port=5432 dbname=postgres                 │
│               ->  Aggregate  (cost=1450.00..1450.01 rows=1 width=8)                                       │
│                     -> Seq Scan on public.events_102008 events  (cost=0.00..1300.00 rows=60000 width=0)   │
└───────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```
- Citus cluter with 1 master, 1 worker and 1 manager

![](.github/.screenshot/pg-citus-3.png)

![](.github/.screenshot/pg-citus-1.png)

![](.github/.screenshot/pg-citus-2.png)

## Use Kafka UI to manage Broker, Topic, Partition, Connector (Kafka Connect), metadata and so on....
### Kafka Broker
![](.github/.screenshot/kafka-broker.png)

### Kafka Topic
![](.github/.screenshot/kafka-topic.png)

### Kafka Connector
![](.github/.screenshot/kafka-connector.png)

### Google Cloud Storage sink
![](.github/.screenshot/gcs-2.png)

### Google Cloud BigQuery sink
![](.github/.screenshot/bq-1.png)
![](.github/.screenshot/bq-2.png)
