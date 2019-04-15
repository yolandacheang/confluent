FROM centos:7

RUN rpm --import https://packages.confluent.io/rpm/5.2/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

RUN yum install -y java-1.8.0-openjdk
RUN yum install -y confluent-ksql


COPY ksql-server.properties /etc/ksql/ksql-server.properties
COPY log4j.properties /etc/ksql/log4j.properties

EXPOSE 9092

CMD ksql-server-start /etc/ksql/ksql-server.properties
