#!/bin/bash

export KUBECONFIG=kubeconfig.yml

NAMESPACE=hopsworks

helm template --debug --dry-run=server kerberos-release . \
  --namespace $NAMESPACE \
  --values values.yaml