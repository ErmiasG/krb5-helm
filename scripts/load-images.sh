#!/bin/bash

VERSION=0.1.0
REMOTE=$1
REMOTE_PATH=$2

if [ -z "${REMOTE}" ]; then
    minikube image load images/kerberos"${VERSION}".tar
    minikube image load images/krb-client"${VERSION}".tar
    minikube image load images/payara-node"${VERSION}".tar
    minikube image load images/payara-server"${VERSION}".tar

    minikube image ls
else
    echo "copying images to ${REMOTE}:${REMOTE_PATH}"
    scp images/kerberos"${VERSION}".tar "${REMOTE}:${REMOTE_PATH}"
    scp images/krb-client"${VERSION}".tar "${REMOTE}:${REMOTE_PATH}"
    scp images/payara-node"${VERSION}".tar "${REMOTE}:${REMOTE_PATH}"
    scp images/payara-server"${VERSION}".tar "${REMOTE}:${REMOTE_PATH}"
    
    echo "loading images"
    ssh ${REMOTE} -t "minikube image load ${REMOTE_PATH}/kerberos"${VERSION}".tar"
    ssh ${REMOTE} -t "minikube image load ${REMOTE_PATH}/krb-client"${VERSION}".tar"
    ssh ${REMOTE} -t "minikube image load ${REMOTE_PATH}/payara-node"${VERSION}".tar"
    ssh ${REMOTE} -t "minikube image load ${REMOTE_PATH}/payara-server"${VERSION}".tar"

    ssh ${REMOTE} -t "minikube image ls"
fi

