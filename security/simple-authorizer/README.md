1. Start it up
```
docker-compose up -d --build
```

2. Create a topic
```
kafka-topics --zookeeper localhost:2181 --topic test --create --partitions 1 --replication-factor 1
```

3. Produce something to the topic, this should work ok
```
kafka-console-producer --producer.config secrets/producer.properties --broker-list localhost:9092 --topic test
>1
>2
>3
>4
```

4. Create ACL to allow only read to the topic on User:client
```
kafka-acls --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:client --operation Read --topic test
```

The SSL principal used in the certificate has CN of client, as that's the name that will be used for authentication.  
See ssl.principal.mapping.rules=RULE:^CN=(.*?),OU=TEST.*$/$1/,DEFAULT


5. Try produce something again, it should fail
```
kafka-console-producer --producer.config secrets/producer.properties --broker-list localhost:9092 --topic test
>8
[2019-09-12 21:19:55,788] WARN [Producer clientId=console-producer] Error while fetching metadata with correlation id 3 : {test=TOPIC_AUTHORIZATION_FAILED} (org.apache.kafka.clients.NetworkClient)
[2019-09-12 21:19:55,789] ERROR [Producer clientId=console-producer] Topic authorization failed for topics [test] (org.apache.kafka.clients.Metadata)
[2019-09-12 21:19:55,790] ERROR Error when sending message to topic test with key: null, value: 1 bytes with error: (org.apache.kafka.clients.producer.internals.ErrorLoggingCallback)
org.apache.kafka.common.errors.TopicAuthorizationException: Not authorized to access topics: [test]
```
