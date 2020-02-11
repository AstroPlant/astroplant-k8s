#/bin/bash
helm delete --purge grafana
kubectl delete ingress grafana-letsencrypt
kubectl delete ingress grafana-minikube
kubectl delete pvc grafana

helm delete --purge prometheus
kubectl delete pvc prometheus-alertmanager
kubectl delete pvc prometheus-server
kubectl delete ingress prometheus
