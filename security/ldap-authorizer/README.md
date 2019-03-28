Kafka using LDAP authorizer

We have a ldap container that has 3 users - alice, barnie, charlie.  Only alice and barnie are in LDAP group "Kafka Developers"
ACLs will be setup to allow LDAP Group "Kafka Developers" only

1.Start all containers
```
docker-compose up -d --build
```

2. To produce to topic test-topic with user barnie, this should work
```
docker-compose exec kafka kafka-console-producer --broker-list kafka:9093 --topic test-topic --producer.config=security/barnie.properties
```
You should produce something to the test-topic

Produce with charlie, this should fail as charlie is not in the group
```
docker-compose exec kafka kafka-console-producer --broker-list kafka:9093 --topic test-topic --producer.config=security/charlie.properties
```

To consume with alice, this should work as alice is in the group
```
docker-compose exec kafka kafka-console-consumer --bootstrap-server kafka:9093 --consumer.config security/alice.properties --topic test-topic --from-beginning
```
You should get the message produced with user barnie
