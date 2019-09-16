#!/bin/bash

[[ "TRACE" ]] && set -x

main() {

  if [ ! -f /acl_initialized ]; then
    SUCCESS=no
    while [ "no" == "$SUCCESS" ]; do
      kafka-configs --zookeeper zookeeper:2181 --alter --add-config 'SCRAM-SHA-256=[password=kafka-secret],SCRAM-SHA-512=[password=kafka-secret]' --entity-type users --entity-name kafka
      kafka-configs --zookeeper zookeeper:2181 --alter --add-config 'SCRAM-SHA-256=[password=alice-secret],SCRAM-SHA-512=[password=alice-secret]' --entity-type users --entity-name alice
      kafka-configs --zookeeper zookeeper:2181 --alter --add-config 'SCRAM-SHA-256=[password=barnie-secret],SCRAM-SHA-512=[password=barnie-secret]' --entity-type users --entity-name barnie
      kafka-configs --zookeeper zookeeper:2181 --alter --add-config 'SCRAM-SHA-256=[password=charlie-secret],SCRAM-SHA-512=[password=charlie-secret]' --entity-type users --entity-name charlie
      kafka-acls --authorizer-properties zookeeper.connect=zookeeper:2181 --add --cluster --operation=All --allow-principal=User:kafka
      kafka-topics --create --topic test-topic --zookeeper zookeeper:2181 --partitions 3 --replication-factor 1
      kafka-acls --authorizer-properties zookeeper.connect=zookeeper:2181 --add --topic=test-topic --producer '--allow-principal=Group:Kafka Developers'
      kafka-acls --authorizer-properties zookeeper.connect=zookeeper:2181 --add --topic=test-topic --consumer --group '*' '--allow-principal=Group:Kafka Developers'
      if [ "$?" == "0" ]; then
        SUCCESS=yes
      fi
    done

    touch /acl_initialized
  fi

  while true; do sleep 60000; done
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
