#/bin/bash
helm delete --purge minio
kubectl delete pvc export-minio-0
kubectl delete pvc export-minio-1
kubectl delete pvc export-minio-2
kubectl delete pvc export-minio-3
kubectl delete job minio-make-bucket-job
kubectl delete ingress minio-letsencrypt
kubectl delete ingress minio-minikube
