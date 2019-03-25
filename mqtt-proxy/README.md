1. Create a topic

```
docker-compose exec kafka kafka-topics --zookeeper zookeeper:2181 --create --topic temperature --partitions 1 --replication-factor 1
```

2. Install mosquitto if you haven't installed 

```
brew install mosquitto
```

3. Produce messages with mosquitto to mqtt-proxy

```
mosquitto_pub -h 0.0.0.0 -p 1883 -t car/engine/temperature -q 2 -m "99999"
```
4. Consume the temperature topic

```
docker-compose exec kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic temperature --from-beginning
```

You have successfully produced messages using MQTT-PROXY

