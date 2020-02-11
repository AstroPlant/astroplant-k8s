# Mosquitto and MQTT metrics exporter

## Mosquitto

```
echo """admin:$PASSWORD
pipeline:$PIPELINE_PASSWORD""" > pwfile
mosquitto_passwd -U pwfile
```

```
echo """admin:$(docker run salekd/mosquitto-auth:0.0.1 -- /build/mosquitto-auth-plug/np -p $PASSWORD)
pipeline:$(docker run salekd/mosquitto-auth:0.0.1 -- /build/mosquitto-auth-plug/np -p $PIPELINE_PASSWORD)""" > pwfile
```

```
mosquitto_sub -t test -h mqtt.$CLUSTER -p 9998 -u admin -P $PASSWORD
mosquitto_pub -t test -m 42 -h mqtt.$CLUSTER -p 9998 -u admin -P $PASSWORD

mosquitto_pub -t kit/1234/measurement/aggregate -m 42 -h mqtt.$CLUSTER -p 9998 -u admin -P $PASSWORD
#mosquitto_pub -t kit/1234/measurement/aggregate -m 42 -h mqtt.$CLUSTER -p 9998 -u k_develop -P $SIMULATION_PASSWORD
mosquitto_sub -t kit/+/measurement/aggregate -h mqtt.$CLUSTER -p 9998 -u pipeline -P $PIPELINE_PASSWORD

mosquitto_pub -t kit/k_develop/measurement/aggregate -m 42 -h mqtt.$CLUSTER -p 9998 -u k_develop -P $SIMULATION_PASSWORD
mosquitto_pub -t kit/k_develop/measurement/aggregate -m 42 -h mqtt.$CLUSTER -p 9998 -u admin -P $PASSWORD
mosquitto_sub -t kit/k_develop/measurement/aggregate -h mqtt.$CLUSTER -p 9998 -u k_develop -P $SIMULATION_PASSWORD
#mosquitto_sub -t kit/+/measurement/aggregate -h mqtt.$CLUSTER -p 9998 -u k_develop -P $SIMULATION_PASSWORD
```

## MQTT metrics exporter

The MQTT metrics exporter uses annotations such that the metrics get automatically scraped by Prometheus.

```
  annotations:
    prometheus.io/scrape: 'true'
    prometheus.io/path: /
```

```
#export POD_NAME=$(kubectl get pods -l app=mqtt-exporter -o jsonpath='{ .items[0].metadata.name}')
export POD_NAME=$(kubectl get pods -l app=mosquitto -o jsonpath='{ .items[0].metadata.name}')
kubectl port-forward $POD_NAME 8000:8000

curl http://localhost:8000/
```

http://localhost:8000/
