Kafka cluster with SSL enabled

TO producer messages:
```
kafka-topics --zookeeper zookeeper1:22181 --topic test --create --partitions 5 --replication-factor 3 --config min.insync.replicas=2 --config cleanup.policy=delete
kafka-console-producer --broker-list kafka1:19092 --topic test --producer.config /etc/kafka/secrets/producer.properties
```
