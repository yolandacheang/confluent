This replicator consists one source zookeeper, one source broker,  one dest zookeeper, one dest broker,  one replicator on the dest cluster



1. Create a topic "foo" on the src cluster
```
$ docker-compose exec kafka-src-1 kafka-topics --create --zookeeper zookeeper-src:2181 --topic foo --replication-factor 1 --partitions 3 -if-not-exists
Created topic "foo".
```

2. Generate some messages to foo topic
```
$ docker-compose exec kafka-src-1 bash -c "seq 1000 | kafka-console-producer --request-required-acks 1 --broker-list localhost:9092 --topic foo && echo 'Produced 1000 messages.'"
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Produced 1000 messages.
```

3. Create the replicator connector:
```
$docker-compose exec connect bash
root@connect:/# curl -X POST -H "Content-Type: application/json" --data '{"name": "replicator-src-a-foo","config": {"connector.class":"io.confluent.connect.replicator.ReplicatorSourceConnector","key.converter": "io.confluent.connect.replicator.util.ByteArrayConverter","value.converter": "io.confluent.connect.replicator.util.ByteArrayConverter","src.zookeeper.connect": "zookeeper-src:2181", "src.kafka.bootstrap.servers": "kafka-src-1:9092", "dest.zookeeper.connect": "zookeeper-dest:2181", "topic.whitelist": "foo", "topic.rename.format": "${topic}.replica"}}' http://localhost:28082/connectors
{"name":"replicator-src-a-foo","config":{"connector.class":"io.confluent.connect.replicator.ReplicatorSourceConnector","key.converter":"io.confluent.connect.replicator.util.ByteArrayConverter","value.converter":"io.confluent.connect.replicator.util.ByteArrayConverter","src.zookeeper.connect":"zookeeper-src:2181","src.kafka.bootstrap.servers":"kafka-src-1:9092","dest.zookeeper.connect":"zookeeper-dest:2181","topic.whitelist":"foo","topic.rename.format":"${topic}.replica","name":"replicator-src-a-foo"},"tasks":[],"type":null}
```

4. Check the status of the connector
```
root@connect:/# curl -X GET http://localhost:28082/connectors/replicator-src-a-foo/status
{"name":"replicator-src-a-foo","connector":{"state":"RUNNING","worker_id":"localhost:28082"},"tasks":[{"state":"RUNNING","id":0,"worker_id":"localhost:28082"}],"type":"source"}
```

5. Consume some messages from foo.replica on dest cluster
```
docker-compose exec kafka-dest-1 kafka-console-consumer --bootstrap-server localhost:9092 -topic foo.replica --from-beginning --max-messages 10
1
4
7
10
13
16
19
22
25
28
Processed a total of 10 messages
```
