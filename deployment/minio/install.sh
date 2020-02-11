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
cowsay "Install Minio"

mo minio-ingress.yaml_template > minio-ingress.yaml
mo minio-values.yaml_template > minio-values.yaml

name=minio
repo=stable
chart=minio
version=2.4.13
values=minio-values.yaml

helm fetch $repo/$chart --version $version --untar
diff $values $chart/values.yaml

helm install $repo/$chart --name $name --version $version --values $values

# Create ingress manually.
kubectl apply -f minio-ingress.yaml
