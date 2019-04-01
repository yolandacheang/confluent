curl -i -X POST \
    -H "Accept:application/json" \
    -H  "Content-Type:application/json" \
    http://localhost:8082/connectors -d '
   {
      "name": "foo-replicator",
      "config": {
        "connector.class": "io.confluent.connect.replicator.ReplicatorSourceConnector",
        "key.converter": "io.confluent.connect.replicator.util.ByteArrayConverter",
        "value.converter": "io.confluent.connect.replicator.util.ByteArrayConverter",
        "src.kafka.bootstrap.servers": "kafka-src:9092",
        "dest.kafka.bootstrap.servers": "kafka-dest:9092",
        "confluent.topic.replication.factor": "1",
        "topic.whitelist": "foo",
        "topic.rename.format": "${topic}.replica"
      }
   }'

