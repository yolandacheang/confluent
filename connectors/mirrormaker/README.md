A easy setup to simulate mirrormaker

start the docker environment with
```
docker-compose up -d
```



1. Create a topic "foo" on the src cluster
```
$ docker-compose exec kafka-src kafka-topics --create --zookeeper zookeeper-src:2181 --topic foo --replication-factor 1 --partitions 3 -if-not-exists
Created topic "foo".
```

2. Generate some messages to foo topic
```
$ docker-compose exec kafka-src bash -c "seq 5 | kafka-console-producer --request-required-acks 1 --broker-list localhost:9092 --topic foo && echo 'Produced 5 messages.'"
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Produced 5 messages.
```

3. Start mirror maker process 
```
docker-compose exec kafka-dest kafka-mirror-maker --consumer.config /config/src-consumer.properties --producer.config /config/dest-producer.properties  --whitelist foo --num.streams 1
```
Messages should be copied across to dest cluster

4. Confirm if the messages are indeed on dest cluster
```
docker-compose exec kafka-dest kafka-console-consumer --bootstrap-server localhost:9092 -topic foo --from-beginning
2
5
3
1
4
Processed a total of 5 messages
```
