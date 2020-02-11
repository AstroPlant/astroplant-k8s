#!/bin/bash

export NAMESPACE=default

name=minio
repo=stable
chart=minio
version=2.4.13
values=minio-values.yaml

helm fetch $repo/$chart --version $version --untar
diff $values $chart/values.yaml

helm install $repo/$chart --name $name --version $version \
  --values $values \
  --set mode=standalone,persistence.size=1Gi,persistence.storageClass=null \
  --namespace $NAMESPACE --debug \
  --tiller-namespace $TILLER_NAMESPACE


# Create ingress manually.
kubectl apply -f minio-ingress-minikube.yaml
