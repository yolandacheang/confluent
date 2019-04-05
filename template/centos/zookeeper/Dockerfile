FROM centos:7

RUN rpm --import https://packages.confluent.io/rpm/5.2/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

RUN yum install -y java-1.8.0-openjdk
RUN yum install -y confluent-kafka-2.12

COPY zookeeper.properties /etc/kafka/zookeeper.properties
COPY log4j.properties /etc/kafka/log4j.properties


EXPOSE 2181 2888 3888

CMD zookeeper-server-start /etc/kafka/zookeeper.properties 
