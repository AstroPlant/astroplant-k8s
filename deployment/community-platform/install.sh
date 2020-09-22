#!/bin/bash -x
mo community-platform.yaml_template > community-platform.yaml
kubectl apply -f community-platform.yaml
