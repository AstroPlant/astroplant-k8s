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
cowsay "Install Ubuntu bastion"

# Generate key-pair.
#ssh-keygen -t rsa -f id_rsa -N ""
openssl genrsa -out private.pem 2048
openssl rsa -pubout -in private.pem -out public.pem
ssh-keygen -f public.pem -i -m PKCS8 > public.key

# Create a secret with the key-pair.
kubectl delete secret key-pair
kubectl create secret generic key-pair \
  --from-file=id_rsa=private.pem \
  --from-file=id_rsa.pub=public.key

cp public.key authorized_keys
cat david_rsa.pub >> authorized_keys
cat thomas_rsa.pub >> authorized_keys

# Create a secret with the key-pair.
kubectl delete secret authorized-keys
kubectl create secret generic authorized-keys \
  --from-file=authorized_keys

# Ubuntu
kubectl apply -f ubuntu-dep.yaml
kubectl apply -f ubuntu-svc.yaml
