#!/bin/bash

#export KUBECONFIG=kubeconfig.yaml
export KUBECONFIG=~/Projects/Kube/OVH/kubeconfig.yml

NAMESPACE=hopsworks

helm uninstall kerberos-release -n $NAMESPACE --wait 
kubectl delete namespace $NAMESPACE
