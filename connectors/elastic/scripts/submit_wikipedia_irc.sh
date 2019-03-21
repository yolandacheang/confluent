#!/bin/bash

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
  "name": "wikipedia-irc",
  "config": {
    "connector.class": "com.github.cjmatta.kafka.connect.irc.IrcSourceConnector",
    "transforms": "WikiEditTransformation",
    "transforms.WikiEditTransformation.type": "com.github.cjmatta.kafka.connect.transform.wikiedit.WikiEditTransformation",
    "transforms.wikiEditTransformation.save.unparseable.messages": true,
    "transforms.wikiEditTransformation.dead.letter.topic": "wikipedia.failed",
    "irc.channels": "#en.wikipedia,#fr.wikipedia,#es.wikipedia,#ru.wikipedia,#en.wiktionary,#de.wikipedia,#zh.wikipedia,#sd.wikipedia,#it.wikipedia,#mediawiki.wikipedia,#commons.wikimedia,#eu.wikipedia,#vo.wikipedia,#eo.wikipedia,#uk.wikipedia",
    "irc.server": "irc.wikimedia.org",
    "irc.server.port": "6667",
    "kafka.topic": "wikipedia.parsed",
    "producer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://schema-registry:8085",
    "tasks.max": "1"
  }
}
EOF
)

docker-compose exec connect curl -X POST -H "${HEADER}" --data "${DATA}" http://localhost:8083/connectors
