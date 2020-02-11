# Confluent Kafka

```
sshuttle --dns -r root@ubuntu.$CLUSTER:9997 0.0.0.0/0

kafka-topics --zookeeper kafka-cp-zookeeper-headless.default.svc.cluster.local:2181 --list
kafka-topics --zookeeper kafka-cp-zookeeper-headless.default.svc.cluster.local:2181 --describe --topic raw
kafka-topics --zookeeper kafka-cp-zookeeper-headless.default.svc.cluster.local:2181 --describe --topic aggregate

kafka-consumer-groups --bootstrap-server kafka-cp-kafka.default.svc.cluster.local:9092 \
  --list
kafka-consumer-groups --bootstrap-server kafka-cp-kafka.default.svc.cluster.local:9092 \
  --describe --group server-raw-group
kafka-consumer-groups --bootstrap-server kafka-cp-kafka.default.svc.cluster.local:9092 \
  --describe --group server-aggregate-group

echo 42 | kafka-console-producer --broker-list kafka-cp-kafka.default.svc.cluster.local:9092 --topic aggregate
```
