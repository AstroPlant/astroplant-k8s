#!/bin/bash -x
mo community-api.yaml_template > community-api.yaml
kubectl apply -f community-api.yaml
