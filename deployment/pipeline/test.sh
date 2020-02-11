#!/bin/bash -x

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

capnp encode astroplant.capnp AggregateMeasurement --packed < message-aggregate.txt > message-aggregate.bin

mosquitto_pub -t kit/k-test/measurement/aggregate -f message-aggregate.bin -h mqtt.$CLUSTER -p 9998 -u k-test -P "$SIMULATION_PASSWORD"

#PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "SELECT * FROM aggregate_measurements"
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "SELECT * FROM aggregate_measurements ORDER BY datetime_end DESC LIMIT 1"
