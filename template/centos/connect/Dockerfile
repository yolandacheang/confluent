FROM centos:7

RUN rpm --import https://packages.confluent.io/rpm/5.2/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

RUN yum install -y java-1.8.0-openjdk
RUN yum install -y confluent-kafka-2.12
RUN yum install -y confluent-hub-client
RUN yum install -y confluent-schema-registry
RUN yum install -y confluent-control-center
RUN yum install -y confluent-kafka-connect-jdbc confluent-kafka-connect-hdfs confluent-kafka-connect-elasticsearch confluent-kafka-connect-storage-common confluent-kafka-connect-jms confluent-kafka-connect-s3 
RUN confluent-hub install confluentinc/kafka-connect-gcs:latest --no-prompt


COPY connect-distributed.properties /etc/kafka/connect-distributed.properties
COPY connect-log4j.properties /etc/kafka/connect-log4j.properties

EXPOSE 8083

ENV CLASSPATH="/usr/share/java/*,/usr/share/confluent-hub-components"
CMD connect-distributed /etc/kafka/connect-distributed.properties
