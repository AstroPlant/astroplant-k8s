# Measurement pipelines

## Docker image

To push new docker images to the docker hub registry, run:

```
export DOCKER_ID_USER="salekd"
docker login https://index.docker.io/v1/

git clone https://github.com/AstroPlant/astroplant-backend.git
cd astroplant-backend
docker build -f mqtt-connector/Dockerfile . -t astroplant-mqtt-connector
docker tag astroplant-mqtt-connector $DOCKER_ID_USER/astroplant-mqtt-connector:0.0.1
docker push $DOCKER_ID_USER/astroplant-mqtt-connector:0.0.1
```

Replace `mqtt` for `kafka` in the above to instead push astroplant-mqtt-connector to the docker hub registry.

```
echo """(
  id = 0x\"`python -c "import uuid;print(uuid.uuid4().hex)"`\",
  kitSerial = \"k-test\",
  datetimeStart = `date +%s000`,
  datetimeEnd = `date +%s000`,
  peripheral = `PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "SELECT id FROM peripherals WHERE name='test-virtual-temperature'" -t`,
  quantityType = `PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "SELECT id FROM quantity_types WHERE physical_quantity='Temperature'" -t`,
  aggregateType = \"maximum\",
  value = 42
)""" > message-aggregate.txt
```

## Cap'n Proto

https://capnproto.org/index.html

```
wget https://raw.githubusercontent.com/AstroPlant/astroplant-backend/master/kafka-db-connector/proto/astroplant.capnp

capnp encode astroplant.capnp AggregateMeasurement --packed < message-aggregate.txt > message-aggregate.bin
capnp encode astroplant.capnp RawMeasurement --packed < message-raw.txt > message-raw.bin
```

## MQTT to Kafka

```
export MQTT_HOST=mosquitto.default.svc.cluster.local
export MQTT_PORT=1883
export MQTT_USERNAME=pipeline
export MQTT_PASSWORD=$PIPELINE_PASSWORD
export KAFKA_HOST=kafka-cp-kafka.default.svc.cluster.local
export KAFKA_PORT=9092
export KAFKA_USERNAME=
export KAFKA_PASSWORD=
```

```
mosquitto_pub -t kit/k-test/measurement/aggregate -f message-aggregate.bin -h mqtt.$CLUSTER -p 9998 -u admin -P $PASSWORD
mosquitto_pub -t kit/k-test/measurement/aggregate -f message-aggregate.bin -h mqtt.$CLUSTER -p 9998 -u k-test -P "$SIMULATION_PASSWORD"

kafka-console-consumer --bootstrap-server kafka-cp-kafka-headless:9092 --topic aggregate
```

## Kafka to PostgreSQL

```
export KAFKA_HOST=kafka-cp-kafka-headless.default.svc.cluster.local
export KAFKA_PORT=9092
export KAFKA_USERNAME=
export KAFKA_PASSWORD=
export DATABASE_HOST=postgresql.default.svc.cluster.local
export DATABASE_PORT=5432
export DATABASE_DATABASE=astroplant
export DATABASE_USERNAME=pipeline
export DATABASE_PASSWORD=$PIPELINE_PASSWORD
```

```
kafka-console-producer --broker-list kafka-cp-kafka:9092 --topic aggregate < message-aggregate.bin

PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "SELECT * FROM aggregate_measurements"
```
