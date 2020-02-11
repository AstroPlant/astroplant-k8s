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
cowsay "Install Mosquitto"

echo """admin:$(docker run salekd/mosquitto-auth:0.0.1 -- /build/mosquitto-auth-plug/np -p $PASSWORD)
pipeline:$(docker run salekd/mosquitto-auth:0.0.1 -- /build/mosquitto-auth-plug/np -p $PIPELINE_PASSWORD)""" > pwfile

kubectl create configmap mosquitto \
  --from-file=mosquitto.conf \
  --from-file=aclfile \
  --from-file=pwfile

kubectl apply -f mosquitto-dep.yaml
kubectl apply -f mosquitto-svc.yaml
kubectl apply -f mqtt-exporter-cm.yaml
kubectl apply -f mqtt-exporter-svc.yaml
