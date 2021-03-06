#!/bin/bash

set -o nounset \
    -o errexit \
    -o verbose

# See what is in each keystore and truststore
for i in kafka1 kafka2 kafka3 client schemaregistry restproxy connect control-center
do
        echo "------------------------------- $i keystore -------------------------------"
	keytool -list -v -keystore $i.keystore.jks -storepass confluent | grep -e Alias -e Entry
        echo "------------------------------- $i truststore -------------------------------"
	keytool -list -v -keystore $i.truststore.jks -storepass confluent | grep -e Alias -e Entry
done
