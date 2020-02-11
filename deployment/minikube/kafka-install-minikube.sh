#!/bin/bash

git clone --branch v5.2.2-1 https://github.com/confluentinc/cp-helm-charts.git

diff kafka-values.yaml cp-helm-charts/charts/cp-kafka/values.yaml

export NAMESPACE=default

helm dep update cp-helm-charts/charts/cp-kafka

helm install --name kafka -f kafka-values.yaml ./cp-helm-charts/charts/cp-kafka \
  --set cp-zookeeper.persistence.dataDirSize=1Gi,cp-zookeeper.persistence.dataLogDirSize=1Gi \
  --namespace $NAMESPACE --debug \
  --tiller-namespace $TILLER_NAMESPACE
