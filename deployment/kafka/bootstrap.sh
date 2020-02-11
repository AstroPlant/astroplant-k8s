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
cowsay "Bootstrap Kafka"

export POD_NAME=$(kubectl get pods -l app=ubuntu -o jsonpath='{ .items[0].metadata.name}')

kubectl exec -it $POD_NAME -- kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --topic aggregate --create --partitions 3 --replication-factor 3
#kubectl exec -it $POD_NAME -- kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --topic aggregate --alter --config retention.ms=604800000
kubectl exec -it $POD_NAME -- kafka-configs --zookeeper kafka-cp-zookeeper-headless:2181 --alter --entity-type topics --entity-name aggregate --add-config retention.ms=604800000
kubectl exec -it $POD_NAME -- kafka-configs --zookeeper kafka-cp-zookeeper-headless:2181 --alter --entity-type topics --entity-name aggregate --add-config retention.bytes=1073741824
kubectl exec -it $POD_NAME -- kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --describe --topic aggregate

kubectl exec -it $POD_NAME -- kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --topic raw --create --partitions 3 --replication-factor 3
#kubectl exec -it $POD_NAME -- kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --topic aggregate --alter --config retention.ms=604800000
kubectl exec -it $POD_NAME -- kafka-configs --zookeeper kafka-cp-zookeeper-headless:2181 --alter --entity-type topics --entity-name raw --add-config retention.ms=604800000
kubectl exec -it $POD_NAME -- kafka-configs --zookeeper kafka-cp-zookeeper-headless:2181 --alter --entity-type topics --entity-name raw --add-config retention.bytes=1073741824
kubectl exec -it $POD_NAME -- kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --describe --topic raw

kubectl exec -it $POD_NAME -- kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --list
#kubectl exec -it $POD_NAME -- zookeeper-shell kafka-cp-zookeeper-headless:2181 ls /brokers/ids
#kubectl exec -it $POD_NAME -- zookeeper-shell kafka-cp-zookeeper-headless:2181 ls /brokers/topics
