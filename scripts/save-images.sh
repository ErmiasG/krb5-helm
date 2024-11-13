#!/bin/bash

VERSION=0.1.0

rm -rf images/*

sudo docker save -o images/kerberos"${VERSION}".tar kerberos:"${VERSION}"
sudo docker save -o images/krb-client"${VERSION}".tar krb-client:"${VERSION}"
sudo docker save -o images/payara-node"${VERSION}".tar payara-node:"${VERSION}"
sudo docker save -o images/payara-server"${VERSION}".tar payara-server:"${VERSION}"

sudo chmod 666 -R images/*