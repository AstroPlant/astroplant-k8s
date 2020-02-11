#!/bin/bash
kubectl delete configmap mosquitto
kubectl delete deploy mosquitto
kubectl delete svc mosquitto
kubectl delete configmap mqtt-exporter
kubectl delete deploy mqtt-exporter
kubectl delete svc mosquitto-metrics
