FROM confluentinc/cp-zookeeper:5.1.2

ARG BUILD_NUMBER=-1

ADD ./config.sh /config.sh

ENTRYPOINT ["/config.sh"]
