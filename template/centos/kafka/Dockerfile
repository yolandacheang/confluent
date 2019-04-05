FROM centos:7

RUN rpm --import https://packages.confluent.io/rpm/5.2/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

RUN yum install -y java-1.8.0-openjdk
RUN yum install -y confluent-kafka-2.12
RUN yum install -y confluent-support-metrics
RUN yum install -y confluent-rebalancer


COPY server.properties /etc/kafka/server.properties
COPY log4j.properties /etc/kafka/log4j.properties

EXPOSE 9092

CMD kafka-server-start /etc/kafka/server.properties
