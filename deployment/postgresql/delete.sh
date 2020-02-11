#!/bin/bash
helm delete --purge postgresql
kubectl delete pvc data-postgresql-postgresql-master-0
kubectl delete pvc data-postgresql-slave-0
kubectl delete pvc data-postgresql-slave-1
