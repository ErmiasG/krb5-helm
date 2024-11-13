FROM ubuntu:noble

RUN apt-get update && \
    apt-get -y install krb5-config krb5-user && \
    apt install dnsutils -y && \
    apt install ldap-utils -y && \
    apt install curl jq -y

COPY scripts/test.sh /scripts/test.sh
RUN chmod a+x /scripts/test.sh