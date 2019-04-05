FROM centos:7

RUN rpm --import https://packages.confluent.io/rpm/5.2/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

RUN yum install -y java-1.8.0-openjdk
RUN yum install -y confluent-control-center

COPY control-center.properties /etc/confluent-control-center/control-center.properties
COPY log4j.properties /etc/confluent-control-center/log4j.properties

EXPOSE 9021

CMD control-center-start /etc/confluent-control-center/control-center.properties
