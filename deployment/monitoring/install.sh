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
cowsay "Install monitoring"

mo grafana-ingress.yaml_template > grafana-ingress.yaml
mo grafana-values.yaml_template > grafana-values.yaml
mo prometheus-ingress.yaml_template > prometheus-ingress.yaml


############
# Prometheus
############

# Permissions
kubectl create rolebinding default-admin --clusterrole=cluster-admin --user=system:serviceaccount:kube-system:default --namespace=default

name=prometheus
repo=stable
chart=prometheus
version=8.6.1
values=prometheus-values.yaml

helm fetch $repo/$chart --version $version --untar
diff $values $chart/values.yaml

helm install $repo/$chart --name $name --version $version --values $values

# Create ingress manually.
#kubectl apply -f prometheus-ingress.yaml


#########
# Grafana
#########

name=grafana
repo=stable
chart=grafana
version=3.8.11
values=grafana-values.yaml

helm fetch $repo/$chart --version $version --untar
diff $values $chart/values.yaml

helm install $repo/$chart --name $name --version $version --values $values

# Create ingress manually.
kubectl apply -f grafana-ingress.yaml
