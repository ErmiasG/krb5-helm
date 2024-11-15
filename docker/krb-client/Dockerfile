FROM ubuntu:noble

RUN apt-get update && \
    apt-get -y install krb5-config krb5-user && \
    apt-get install dnsutils -y && \
    apt-get install ldap-utils -y && \
    apt-get install curl jq -y

COPY scripts/test.sh /scripts/test.sh
RUN chmod a+x /scripts/test.sh

COPY krb5.conf /etc/krb5.conf