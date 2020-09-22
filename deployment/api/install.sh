#!/usr/bin/env -S bash -x
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
cowsay "Deploy API"

mo api-dep.yaml_template > api-dep.yaml
mo api-ingress.yaml_template > api-ingress.yaml
mo swagger-ingress.yaml_template > swagger-ingress.yaml

kubectl apply -f api-dep.yaml
kubectl apply -f api-svc.yaml
kubectl apply -f api-ingress.yaml

kubectl apply -f swagger-dep.yaml
kubectl apply -f swagger-svc.yaml
kubectl apply -f swagger-ingress.yaml
