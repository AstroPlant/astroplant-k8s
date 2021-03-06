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
cowsay "Install PostgreSQL"

mo postgresql-values.yaml_template > postgresql-values.yaml

name=postgresql
repo=stable
chart=postgresql
version=6.2.0
values=postgresql-values.yaml

helm fetch $repo/$chart --version $version --untar
diff $values $chart/values-production.yaml

helm install $repo/$chart --name $name --version $version --values $values
