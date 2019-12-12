A simple confluent kafka cluster template

1 zookeeper, 1 kafka broker, 1 control center

Quick command to create topic
`docker-compose exec kafka kafka-topics --create --zookeeper zookeeper:2181 --topic test --replication-factor 1 --partitions 3 -if-not-exists`

Produce 20 messages
`docker-compose exec kafka bash -c "seq 20 | kafka-console-producer --request-required-acks 1 --broker-list localhost:9092 --topic test"`
