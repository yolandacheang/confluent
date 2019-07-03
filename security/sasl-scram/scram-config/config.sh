#!/bin/bash

[[ "TRACE" ]] && set -x

main() {

  if [ ! -f /scram_initialized ]; then
    kafka-configs --zookeeper zookeeper1:22181 --alter --add-config 'SCRAM-SHA-256=[password=kafka-secret],SCRAM-SHA-512=[password=kafka-secret]' --entity-type users --entity-name kafka

    touch /scram_initialized
  fi

  while true; do sleep 60000; done
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
