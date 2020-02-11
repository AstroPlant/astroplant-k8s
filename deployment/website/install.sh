#!/bin/bash -x
# Copyright 2020, SURFsara.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
cowsay "Deploy static website"

mo website-ingress.yaml_template > website-ingress.yaml

kubectl apply -f nginx-pvc.yaml
kubectl apply -f nginx-cm.yaml
kubectl apply -f nginx-dep.yaml
kubectl apply -f nginx-svc.yaml

export POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath='{ .items[0].metadata.name}')

echo "Waiting for nginx to become ready."
kubectl wait --for=condition=ready pod/$POD_NAME

for f in static/*
do
  echo $f
  kubectl cp $f $POD_NAME:/usr/share/nginx/html/
done

kubectl apply -f website-ingress.yaml
