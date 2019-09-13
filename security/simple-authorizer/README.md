1. Start it up
```
docker-compose up -d --build
```

2. Create a topic
```
kafka-topics --zookeeper localhost:2181 --topic test --create --partitions 1 --replication-factor 1
```

3. Produce something to the topic, this should fail
```
$ ~/confluentinc/cpe/confluent-5.3.0/bin/kafka-console-producer --producer.config secrets/producer.properties --broker-list localhost:9092 --topic test
>1
[2019-09-13 10:03:18,783] WARN [Producer clientId=console-producer] Error while fetching metadata with correlation id 40 : {test=TOPIC_AUTHORIZATION_FAILED} (org.apache.kafka.clients.NetworkClient)
[2019-09-13 10:03:18,888] WARN [Producer clientId=console-producer] Error while fetching metadata with correlation id 41 : {test=TOPIC_AUTHORIZATION_FAILED} (org.apache.kafka.clients.NetworkClient)
[2019-09-13 10:03:18,995] WARN [Producer clientId=console-producer] Error while fetching metadata with correlation id 42 : {test=TOPIC_AUTHORIZATION_FAILED} (org.apache.kafka.clients.NetworkClient)
[2019-09-13 10:03:19,106] WARN [Producer clientId=console-producer] Error while fetching metadata with correlation id 43 : {test=TOPIC_AUTHORIZATION_FAILED} (org.apache.kafka.clients.NetworkClient)
```

from authorizer log
```
[2019-09-13 01:11:18,930] DEBUG No acl found for resource Topic:LITERAL:test, authorized = false (kafka.authorizer.logger)
[2019-09-13 01:11:18,935] INFO Principal = User:client is Denied Operation = Describe from host = 172.27.0.1 on resource = Topic:LITERAL:test (kafka.authorizer.logger)
```

4. Create ACL to allow only read to the topic on User:client
```
kafka-acls --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:client --operation Describe --operation Write --topic test
```

The SSL principal used in the certificate has CN of client, as that's the name that will be used for authentication.  
See ssl.principal.mapping.rules=RULE:^CN=(.*?), OU=(.*?), O=(.*?), L=(.*?), ST=(.*?), C=(.*?)$/$1/L,DEFAULT


5. Try produce something again, it should work
```
kafka-console-producer --producer.config secrets/producer.properties --broker-list localhost:9092 --topic test
>8
```

from authorizer log
```
[2019-09-13 01:14:56,878] DEBUG operation = Write on resource = Topic:LITERAL:test from host = 172.27.0.1 is Allow based on acl = User:client has Allow permission for operations: Write from hosts: * (kafka.authorizer.logger)
[2019-09-13 01:14:56,879] DEBUG Principal = User:client is Allowed Operation = Describe from host = 172.27.0.1 on resource = Topic:LITERAL:test (kafka.authorizer.logger)
[2019-09-13 01:14:57,927] DEBUG operation = Write on resource = Topic:LITERAL:test from host = 172.27.0.1 is Allow based on acl = User:client has Allow permission for operations: Write from hosts: * (kafka.authorizer.logger)
[2019-09-13 01:14:57,928] DEBUG Principal = User:client is Allowed Operation = Write from host = 172.27.0.1 on resource = Topic:LITERAL:test (kafka.authorizer.logger)
```
