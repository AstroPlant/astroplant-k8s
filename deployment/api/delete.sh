#!/usr/bin/env -S bash
kubectl delete deploy api
kubectl delete svc api
kubectl delete ingress api-letsencrypt

kubectl delete deploy swagger-ui
kubectl delete svc swagger-ui
kubectl delete ingress swagger-letsencrypt
