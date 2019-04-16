1. Create 2 topics with 4 partitions each, and replication factor of 2.  Intentionally create unbalanced assignment
```
docker-compose exec kafka1 kafka-topics --zookeeper zookeeper1:22181 --create --topic topic1 --replica-assignment 2:1,2:1,2:1,2:1
docker-compose exec kafka1 kafka-topics --zookeeper zookeeper1:22181 --create --topic topic2 --replica-assignment 1:2,2:1,1:2,2:1
```

2. Describe the topics and see how they look like
```
docker-compose exec kafka1 kafka-topics --zookeeper zookeeper1:22181 --describe --topic topic1
Topic:topic1	PartitionCount:4	ReplicationFactor:2	Configs:
	Topic: topic1	Partition: 0	Leader: 2	Replicas: 2,1	Isr: 2,1
	Topic: topic1	Partition: 1	Leader: 2	Replicas: 2,1	Isr: 2,1
	Topic: topic1	Partition: 2	Leader: 2	Replicas: 2,1	Isr: 2,1
	Topic: topic1	Partition: 3	Leader: 2	Replicas: 2,1	Isr: 2,1
docker-compose exec kafka1 kafka-topics --zookeeper zookeeper1:22181 --describe --topic topic2
Topic:topic2	PartitionCount:4	ReplicationFactor:2	Configs:
	Topic: topic2	Partition: 0	Leader: 1	Replicas: 1,2	Isr: 1,2
	Topic: topic2	Partition: 1	Leader: 2	Replicas: 2,1	Isr: 2,1
	Topic: topic2	Partition: 2	Leader: 1	Replicas: 1,2	Isr: 1,2
	Topic: topic2	Partition: 3	Leader: 2	Replicas: 2,1	Isr: 2,1
```

3. Produce some data
```
$ docker-compose exec kafka1 kafka-producer-perf-test --topic topic1 --num-records 200000 --record-size 1000 --throughput 10000000 --producer-props bootstrap.servers=localhost:19092
156032 records sent, 31206.4 records/sec (29.76 MB/sec), 379.3 ms avg latency, 693.0 max latency.
200000 records sent, 32594.524120 records/sec (31.08 MB/sec), 456.94 ms avg latency, 837.00 ms max latency, 476 ms 50th, 782 ms 95th, 834 ms 99th, 836 ms 99.9th.

$ docker-compose exec kafka1 kafka-producer-perf-test --topic topic2 --num-records 800000 --record-size 1000 --throughput 10000000 --producer-props bootstrap.servers=localhost:19092
123124 records sent, 24619.9 records/sec (23.48 MB/sec), 363.6 ms avg latency, 1309.0 max latency.
146176 records sent, 29153.6 records/sec (27.80 MB/sec), 893.4 ms avg latency, 2263.0 max latency.
163021 records sent, 32597.7 records/sec (31.09 MB/sec), 1013.5 ms avg latency, 2381.0 max latency.
174512 records sent, 34902.4 records/sec (33.29 MB/sec), 860.3 ms avg latency, 1840.0 max latency.
180447 records sent, 36089.4 records/sec (34.42 MB/sec), 868.7 ms avg latency, 1982.0 max latency.
800000 records sent, 31057.106254 records/sec (29.62 MB/sec), 824.68 ms avg latency, 2381.00 ms max latency, 202 ms 50th, 2029 ms 95th, 2232 ms 99th, 2362 ms 99.9th.
```

4. Running a consumer to create offset topic
```
docker-compose exec kafka1 kafka-consumer-perf-test --topic topic1 --broker-list localhost:19092 --messages 10
start.time, end.time, data.consumed.in.MB, MB.sec, data.consumed.in.nMsg, nMsg.sec, rebalance.time.ms, fetch.time.ms, fetch.MB.sec, fetch.nMsg.sec
2019-04-16 02:51:20:137, 2019-04-16 02:51:24:582, 0.4768, 0.1073, 500, 112.4859, 3124, 1321, 0.3610, 378.5011
```

5. Execute rebalancer
```
$ docker-compose exec kafka1 confluent-rebalancer execute --zookeeper zookeeper1:22181 --metrics-bootstrap-server localhost:19092 --throttle 10000000 --verbose
Computing the rebalance plan (this may take a while) ...
You are about to move 15 replica(s) for 11 partitions to 4 broker(s) with total size 1,014.1 MB.
The preferred leader for 12 partition(s) will be changed.
In total, the assignment for 17 partitions will be changed.
The minimum free volume space is set to 20.0%.

Min/max stats for brokers (before -> after):
	Type  Leader Count                 Replica Count                Size (MB)
	Min   16 (id: 3) -> 17 (id: 2)     48 (id: 3) -> 50 (id: 2)     1.6 (id: 3) -> 508.1 (id: 1)
	Max   21 (id: 2) -> 18 (id: 1)     55 (id: 1) -> 52 (id: 1)     1,014.8 (id: 2) -> 508.1 (id: 3)
No racks are defined.

Broker stats (before -> after):
	Broker     Leader Count    Replica Count   Size (MB)            Free Space (%)
	1          18 -> 18        55 -> 52        1,014.6 -> 508.1     49.9 -> 50.7
	2          21 -> 17        54 -> 50        1,014.8 -> 508.1     49.9 -> 50.7
	3          16 -> 18        48 -> 51        1.6 -> 508.1         49.9 -> 49.1
	4          16 -> 18        48 -> 52        1.6 -> 508.1         49.9 -> 49.1

Would you like to continue? (y/n): y

The rebalance has been started, run `status` to check progress.

Warning: You must run the `status` or `finish` command periodically, until the rebalance completes, to ensure the throttle is removed. You can also alter the throttle by re-running the execute command passing a new value.
```

6. Check the status
```
docker-compose exec kafka1 confluent-rebalancer status --zookeeper zookeeper1:22181
```

7. Verify the replica assignment
```
docker-compose exec kafka1 kafka-topics --zookeeper zookeeper1:22181 --describe --topic topic2
Topic:topic2	PartitionCount:4	ReplicationFactor:2	Configs:
	Topic: topic2	Partition: 0	Leader: 3	Replicas: 3,4	Isr: 3,4
	Topic: topic2	Partition: 1	Leader: 2	Replicas: 1,2	Isr: 2,1
	Topic: topic2	Partition: 2	Leader: 1	Replicas: 1,2	Isr: 1,2
	Topic: topic2	Partition: 3	Leader: 3	Replicas: 3,4	Isr: 4,3

docker-compose exec kafka1 kafka-topics --zookeeper zookeeper1:22181 --describe --topic topic1
Topic:topic1	PartitionCount:4	ReplicationFactor:2	Configs:
	Topic: topic1	Partition: 0	Leader: 3	Replicas: 3,4	Isr: 4,3
	Topic: topic1	Partition: 1	Leader: 4	Replicas: 4,3	Isr: 4,3
	Topic: topic1	Partition: 2	Leader: 2	Replicas: 1,2	Isr: 2,1
	Topic: topic1	Partition: 3	Leader: 2	Replicas: 2,1	Isr: 2,1

```

