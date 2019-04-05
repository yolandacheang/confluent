FROM centos:7

# 1. Adding Confluent repository
RUN rpm --import https://packages.confluent.io/rpm/5.2/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

# 2. Install zookeeper and kafka
RUN yum install -y java-1.8.0-openjdk
RUN yum install -y confluent-kafka-2.12
RUN yum install -y confluent-support-metrics
RUN yum install -y confluent-rebalancer


# 3. Configure Kafka and zookeeper for Kerberos
COPY server.properties /etc/kafka/server.properties
COPY log4j.properties /etc/kafka/log4j.properties

EXPOSE 9092

CMD kafka-server-start /etc/kafka/server.properties
