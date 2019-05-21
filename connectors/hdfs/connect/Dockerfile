FROM centos:7


RUN rpm --import https://packages.confluent.io/rpm/5.2/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

RUN yum install -y java-1.8.0-openjdk
RUN yum install -y confluent-kafka-2.12
RUN yum install -y confluent-hub-client
RUN yum install -y confluent-control-center
RUN yum install -y confluent-schema-registry

##installs datagen connector
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-hdfs:5.2.1

COPY connect-distributed.properties /etc/kafka/connect-distributed.properties
COPY connect-log4j.properties /etc/kafka/connect-log4j.properties

EXPOSE 8083

CMD connect-distributed /etc/kafka/connect-distributed.properties
