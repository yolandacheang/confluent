#!/bin/bash

[[ "TRACE" ]] && set -x

: ${REALM:=TEST.CONFLUENT.IO}
: ${DOMAIN_REALM:=test.confluent.io}
: ${KERB_MASTER_KEY:=masterkey}
: ${KERB_ADMIN_USER:=admin}
: ${KERB_ADMIN_PASS:=admin}



create_config() {
  : ${KDC_ADDRESS:=$(hostname -f)}

  cat>/etc/krb5.conf<<EOF
[logging]
 default = FILE:/var/log/kerberos/krb5libs.log
 kdc = FILE:/var/log/kerberos/krb5kdc.log
 admin_server = FILE:/var/log/kerberos/kadmind.log

[libdefaults]
 default_realm = $REALM
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 # WARNING: We use weaker key types to simplify testing as stronger key types
 # require the enhanced security JCE policy file to be installed. You should
 # NOT run with this configuration in production or any real environment. You
 # have been warned.

[realms]
 $REALM = {
  kdc = $KDC_ADDRESS
  admin_server = $KDC_ADDRESS
 }

[domain_realm]
 .$DOMAIN_REALM = $REALM
 $DOMAIN_REALM = $REALM
EOF

cat>/var/kerberos/krb5kdc/kdc.conf<<EOF
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
 $REALM = {
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  # WARNING: We use weaker key types to simplify testing as stronger key types
  # require the enhanced security JCE policy file to be installed. You should
  # NOT run with this configuration in production or any real environment. You
  # have been warned.
  master_key_type = des3-hmac-sha1
  supported_enctypes = arcfour-hmac:normal des3-hmac-sha1:normal des-cbc-crc:normal des:normal des:v4 des:norealm des:onlyrealm des:afs3
  default_principal_flags = +preauth
 }
EOF
}

create_db() {
  /usr/sbin/kdb5_util -P $KERB_MASTER_KEY -r $REALM create -s
}

create_admin_user() {
  kadmin.local -q "addprinc -pw $KERB_ADMIN_PASS $KERB_ADMIN_USER/admin"
  echo "*/admin@$REALM *" > /var/kerberos/krb5kdc/kadm5.acl
}

create_principals() {
  for principal in zookeeper1 zookeeper2 zookeeper3
  do
    kadmin.local -q "addprinc -randkey zookeeper/quickstart.confluent.io@TEST.CONFLUENT.IO"
    rm /tmp/keytab/${principal}.keytab
    kadmin.local -q "ktadd -norandkey -k /tmp/keytab/${principal}.keytab zookeeper/quickstart.confluent.io@TEST.CONFLUENT.IO"
  done

  for principal in zkclient1 zkclient2 zkclient3
  do
    kadmin.local -q "addprinc -randkey zkclient/quickstart.confluent.io@TEST.CONFLUENT.IO"
    rm /tmp/keytab/${principal}.keytab
    kadmin.local -q "ktadd -norandkey -k /tmp/keytab/${principal}.keytab zkclient/quickstart.confluent.io@TEST.CONFLUENT.IO"
  done

  for principal in broker1 broker2 broker3
  do
    kadmin.local -q "addprinc -randkey kafka/quickstart.confluent.io@TEST.CONFLUENT.IO"
    rm /tmp/keytab/${principal}.keytab
    kadmin.local -q "ktadd -norandkey -k /tmp/keytab/${principal}.keytab kafka/quickstart.confluent.io@TEST.CONFLUENT.IO"
  done

  for principal in saslproducer saslconsumer
  do
    kadmin.local -q "addprinc -randkey ${principal}/quickstart.confluent.io@TEST.CONFLUENT.IO"
    rm /tmp/keytab/${principal}.keytab
    kadmin.local -q "ktadd -norandkey -k /tmp/keytab/${principal}.keytab ${principal}/quickstart.confluent.io@TEST.CONFLUENT.IO"
  done
}

start_kdc() {
  /usr/sbin/krb5kdc -P /var/run/krb5kdc.pid
  /usr/sbin/_kadmind -P /var/run/kadmind.pid
}

main() {

  if [ ! -f /kerberos_initialized ]; then
    create_config
    create_db
    create_admin_user
    start_kdc
    create_principals
    touch /kerberos_initialized
  fi

  tail -F /var/log/kerberos/krb5kdc.log
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
