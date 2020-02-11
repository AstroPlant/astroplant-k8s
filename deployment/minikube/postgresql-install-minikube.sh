#!/bin/bash

export NAMESPACE=default

name=postgresql
repo=stable
chart=postgresql
version=3.15.0
values=postgresql-values.yaml

helm fetch $repo/$chart --version $version --untar
diff $values $chart/values.yaml

helm install $repo/$chart --name $name --version $version \
  --values $values \
  --set replication.enabled=false,persistence.size=1Gi \
  --namespace $NAMESPACE --debug \
  --tiller-namespace $TILLER_NAMESPACE
