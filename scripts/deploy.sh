#!/bin/bash

#export KUBECONFIG=kubeconfig.yaml
export KUBECONFIG=~/Projects/Kube/OVH/kubeconfig.yml

NAMESPACE=hopsworks

#kubectl delete namespace $NAMESPACE

kubectl create namespace $NAMESPACE

#kubectl create configmap spnego-app --from-file=/home/ermias/Projects/Kube/krb5-helm/spnego/target/spnego-0.1.war -n $NAMESPACE

helm install kerberos-release . \
  --namespace $NAMESPACE \
  --values values.yaml

