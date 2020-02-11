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
cowsay "Bootstrap Minio"

# Wait for Minio to be ready.
echo "Waiting for Minio to become ready."
export POD_NAME=$(kubectl get pods -l app=minio -o jsonpath='{ .items[0].metadata.name}')
kubectl wait --for=condition=ready pod/$POD_NAME

# Wait for the service, ingress, external URL to become available.
while [ -n "$(mc config host add astroplant https://minio.$CLUSTER admin $PASSWORD 2>&1 > /dev/null)" ]; do
  echo "Waiting for Minio to become accessible externally."
  sleep 5
done
