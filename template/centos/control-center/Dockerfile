FROM centos:7

# 1. Adding Confluent repository
RUN rpm --import https://packages.confluent.io/rpm/5.2/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

# 2. Install zookeeper and kafka
RUN yum install -y java-1.8.0-openjdk
RUN yum install -y confluent-control-center

# 3. Configure Kafka and zookeeper for Kerberos
COPY control-center.properties /etc/confluent-control-center/control-center.properties
COPY log4j.properties /etc/confluent-control-center/log4j.properties

EXPOSE 9021

CMD control-center-start /etc/confluent-control-center/control-center.properties
