FROM centos:7

RUN rpm --import https://packages.confluent.io/rpm/5.2/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

RUN yum install -y java-1.8.0-openjdk
RUN yum install -y confluent-schema-registry
RUN yum install -y confluent-control-center
RUN yum install -y confluent-security


COPY schema-registry.properties /etc/schema-registry/schema-registry.properties
COPY log4j.properties /etc/schema-registry/log4j.properties

EXPOSE 8081

CMD schema-registry-start /etc/schema-registry/schema-registry.properties
