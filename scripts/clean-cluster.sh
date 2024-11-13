#!/bin/bash

export KUBECONFIG=kubeconfig.yaml

NAMESPACE=kerberos

helm uninstall kerberos-release -n $NAMESPACE --wait 
kubectl delete namespace $NAMESPACE
