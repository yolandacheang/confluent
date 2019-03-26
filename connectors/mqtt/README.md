This is a demo of using MQTT source connector, and MongoDB sink connector, it also includes an MQTT broker based on Eclipse Mosquitto

1. start docker compose environment 
```
docker-compose up -d
```

2. Start the mqtt source connector
```
./scripts/mqtt-source
```

3. Publish a message to MQTT broker, install mosquitto client if you haven't with brew install
```
mosquitto_pub -h 0.0.0.0 -p 1883 -t "baeldung" -m "{\"id\":1234,\"message\":\"This is a test\"}"
```

4. Consume the topic to see if the message has been delivered to kafka
```
docker-compose exec kafka kafka-console-consumer --bootstrap-server kafka:9092 --topic connect-custom --from-beginning
```

5. Start sink connector to mongodb
```
./scripts/mongodb-sink
```


