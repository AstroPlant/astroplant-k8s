#!/bin/bash
helm delete --purge kafka
kubectl delete pvc datadir-0-kafka-cp-kafka-0
kubectl delete pvc datadir-0-kafka-cp-kafka-1
kubectl delete pvc datadir-0-kafka-cp-kafka-2
kubectl delete pvc datadir-kafka-cp-zookeeper-0
kubectl delete pvc datadir-kafka-cp-zookeeper-1
kubectl delete pvc datadir-kafka-cp-zookeeper-2
kubectl delete pvc datalogdir-kafka-cp-zookeeper-0
kubectl delete pvc datalogdir-kafka-cp-zookeeper-1
kubectl delete pvc datalogdir-kafka-cp-zookeeper-2
