#!/bin/bash
kubectl delete secret key-pair
kubectl delete secret authorized-keys
kubectl delete deploy ubuntu
kubectl delete svc ubuntu
