#!/bin/bash
kubectl delete deploy mqtt2kafka
kubectl delete deploy kafka2db-aggregate
kubectl delete deploy kafka2db-raw
