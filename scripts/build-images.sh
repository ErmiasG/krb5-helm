#!/bin/bash

set -e

VERSION=0.1.0
cd docker

cd ldap && sudo docker build --progress plain -t ldap:$VERSION . "$@"

cd ../kerberos && sudo docker build --progress plain -t kerberos:$VERSION . "$@"

cd ../krb-client && sudo docker build --progress plain -t krb-client:$VERSION . "$@"

cd ../payara-node && sudo docker build --progress plain -t payara-node:$VERSION . "$@"

cd ../payara-server
cp ../../spnego/target/spnego-0.1.war .
sudo docker build --progress plain -t payara-server:$VERSION . "$@"
rm -f spnego-0.1.war
