#!/bin/bash
kubectl delete deploy community-platform
kubectl delete svc community-platform
kubectl delete ingress community-platform-letsencrypt
