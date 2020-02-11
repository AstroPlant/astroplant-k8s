#!/bin/bash

############
# Prometheus
############

# Permissions
kubectl create rolebinding default-admin --clusterrole=cluster-admin --user=system:serviceaccount:kube-system:default --namespace=default


export NAMESPACE=default

name=prometheus
repo=stable
chart=prometheus
version=8.6.1
values=prometheus-values.yaml

helm fetch $repo/$chart --version $version --untar
diff $values $chart/values.yaml

helm install $repo/$chart --name $name --version $version \
  --values $values \
  --set alertmanager.persistentVolume.size=1Gi,prometheus.persistentVolume.size=1Gi \
  --namespace $NAMESPACE --debug \
  --tiller-namespace $TILLER_NAMESPACE


# Create ingress manually.
#kubectl apply -f prometheus-ingress.yaml


#########
# Grafana
#########

export NAMESPACE=default

name=grafana
repo=stable
chart=grafana
version=3.5.6
values=grafana-values.yaml

helm fetch $repo/$chart --version $version --untar
diff $values $chart/values.yaml

helm install $repo/$chart --name $name --version $version \
  --values $values \
  --set persistence.size=1Gi \
  --namespace $NAMESPACE --debug \
  --tiller-namespace $TILLER_NAMESPACE


# Create ingress manually.
kubectl apply -f grafana-ingress-minikube.yaml
