# Deployment
 
The deployment consists of the following steps:
- General setup (Tiller, TCP ports)
- SSH bastion pod
- Monitoring (Prometheus, Grafana and monitoring dashboards) 
- Minio
- PostgreSQL
- Mosquitto broker with authentication plugin and metrics exporter
- Kafka
- Automated pipeline (MQTT to Kafka, Kafka to PostgreSQL)
- Static website
- API
- Simulation

```
# Cluster domain name
export CLUSTER=
# Admin password
export PASSWORD=
# Pipeline password
export PIPELINE_PASSWORD=
# Password for the simulation kit
export SIMULATION_PASSWORD=

# Install mustache templates.
# https://mustache.github.io/
curl -sSL https://git.io/get-mo -o mo
chmod +x mo
mv mo /usr/local/bin/
```

## General setup

```
(cd general && ./install.sh)
```

## SSH bastion pod

```
(cd ubuntu && ./install.sh)
```

```
ssh -i private.pem root@ubuntu.$CLUSTER -p 9997
ssh root@ubuntu.$CLUSTER -p 9997
```

Proxying all network traffic including DNS through SSH tunnel:

```
brew install sshuttle

sshuttle --dns -r root@ubuntu.$CLUSTER:9997 0.0.0.0/0
```

https://github.com/sshuttle/sshuttle

## Monitoring

```
(cd monitoring && ./install.sh)
(cd monitoring && ./bootstrap.sh)
```

Grafana
- https://grafana.{{CLUSTER}}
- user: `admin`
- password: `$PASSWORD`

Prometheus is accessible only from the office network and VPN.
- https://prometheus.{{CLUSTER}}

## Minio

```
(cd minio && ./install.sh)
(cd minio && ./bootstrap.sh)
```

Minio
- https://minio.{{CLUSTER}}
- access key: `admin`
- secret key: `$PASSWORD`

```
mc config host add astroplant https://minio.$CLUSTER/ admin $PASSWORD
mc ls astroplant --recursive
```

## PostreSQL

```
(cd postgresql && ./install.sh)
(cd postgresql && ./bootstrap.sh)
```

```
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant
```

## MQTT

```
(cd mqtt && ./install.sh)
```

```
mosquitto_sub -t test -h mqtt.$CLUSTER -p 9998 -u admin -P $PASSWORD
mosquitto_pub -t test -m 42 -h mqtt.$CLUSTER -p 9998 -u admin -P $PASSWORD

mosquitto_sub -t "\$SYS/#" -h mqtt.$CLUSTER -p 9998 -u admin -P $PASSWORD
```

```
export POD_NAME=$(kubectl get pods -l app=ubuntu -o jsonpath='{ .items[0].metadata.name}')
kubectl exec -it $POD_NAME bash

mosquitto_sub -t test -h mqtt -p 1883 -u admin -P $PASSWORD
mosquitto_pub -t test -m 42 -h mosquitto -p 1883 -u admin -P $PASSWORD
```

## Kafka

```
(cd kafka && ./install.sh)
(cd kafka && ./bootstrap.sh)
```

```
export POD_NAME=$(kubectl get pods -l app=ubuntu -o jsonpath='{ .items[0].metadata.name}')
kubectl exec -it $POD_NAME bash


kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --topic test --create --partitions 3 --replication-factor 3
kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --describe --topic test

kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --list

#kafka-topics --zookeeper kafka-cp-zookeeper-headless:2181 --topic test --delete


echo 42 | kafka-console-producer --broker-list kafka-cp-kafka:9092 --topic test

kafka-console-consumer --bootstrap-server kafka-cp-kafka-headless:9092 --topic test --from-beginning
```

```
sshuttle --dns -r root@ubuntu.$CLUSTER:9997 0.0.0.0/0

kafka-topics --zookeeper kafka-cp-zookeeper-headless.default.svc.cluster.local:2181 --list
echo 42 | kafka-console-producer --broker-list kafka-cp-kafka-0-nodeport.default.svc.cluster.local:19092,kafka-cp-kafka-1-nodeport.default.svc.cluster.local:19092,kafka-cp-kafka-2-nodeport.default.svc.cluster.local:19092 --topic test
kafka-console-consumer --bootstrap-server kafka-cp-kafka-0-nodeport.default.svc.cluster.local:19092,kafka-cp-kafka-1-nodeport.default.svc.cluster.local:19092,kafka-cp-kafka-2-nodeport.default.svc.cluster.local:19092 --topic test --from-beginning
```

## Automated pipeline

```
(cd pipeline && ./install.sh)
```

```
mosquitto_pub -t kit/k_develop/measurement/aggregate -f message-aggregate.bin -h mqtt.$CLUSTER -p 9998 -u k_develop -P 1234

kafka-console-producer --broker-list kafka-cp-kafka:9092 --topic aggregate < message-aggregate.bin

PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "SELECT * FROM aggregate_measurements"
```

## Static website

```
(cd website && ./install-nginx.sh)
```

https://website.{{CLUSTER}}

## API

```
(cd general && ./install.sh)
```

## Simulation

```
(cd simulation && ./install.sh)
(cd simulation && ./bootstrap.sh)
```
