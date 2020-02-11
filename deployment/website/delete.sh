#!/bin/bash
kubectl delete cm nginx
kubectl delete deploy nginx
kubectl delete svc nginx
kubectl delete pvc website
#kubectl delete ingress website-letsencrypt
