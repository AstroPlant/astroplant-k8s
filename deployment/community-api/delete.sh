#!/bin/bash
kubectl delete deploy community-api
kubectl delete svc community-api
kubectl delete ingress community-api-letsencrypt
# kubectl delete pvc community-api
