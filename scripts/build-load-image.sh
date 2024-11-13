#!/bin/bash

set -e

VERSION=0.1.0
IMAGE=$1
REMOTE=$2
REMOTE_PATH=$3
cd docker

echo "cd $IMAGE && sudo docker build --progress plain -t $IMAGE:$VERSION ."
cd $IMAGE
if [ $IMAGE == "payara-server" ]; then
  cp ../../spnego/target/spnego-0.1.war .
fi
sudo docker build --progress plain -t $IMAGE:$VERSION .

cd ../..

echo "rm -rf images/$IMAGE${VERSION}.tar"
rm -rf images/"$IMAGE${VERSION}".tar

echo "sudo docker save -o images/$IMAGE${VERSION}.tar $IMAGE:${VERSION}"
sudo docker save -o images/"$IMAGE${VERSION}".tar $IMAGE:${VERSION}

sudo chmod 666 -R images/*

if [ -z "${REMOTE}" ]; then
    minikube image load images/$IMAGE"${VERSION}".tar

    minikube image ls
else
    echo "copying image $IMAGE to ${REMOTE}:${REMOTE_PATH}"
    scp images/$IMAGE"${VERSION}".tar "${REMOTE}:${REMOTE_PATH}"
    
    echo "loading image $IMAGE"
    ssh ${REMOTE} -t "minikube image load ${REMOTE_PATH}/$IMAGE"${VERSION}".tar"

    ssh ${REMOTE} -t "minikube image ls"
fi