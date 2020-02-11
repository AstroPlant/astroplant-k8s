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
cowsay "Bootstrap monitoring"
# Produce a failure code if any command in a pipeline fails.
# Normally, pipelines only return a failure if the last command errors.
set -eo pipefail

# Wait for Grafana to be ready.
echo "Waiting for Grafana to become ready."
export POD_NAME=$(kubectl get pods -l app=grafana -o jsonpath='{ .items[0].metadata.name}')
kubectl wait --for=condition=ready pod/$POD_NAME

# Wait for the service, ingress, external URL to become available.
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' https://grafana.$CLUSTER/api/admin/settings -u 'admin:$PASSWORD')" != "200" ]]
do sleep 5
done


#############
# DATASOURCES
#############

# Define Prometheus datasource.
echo "Defining Prometheus datasource."
curl -XPOST \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -u "admin:$PASSWORD" \
  https://grafana.$CLUSTER/api/datasources \
  --data @prometheus-datasource.json | jq .

# List datasources.
echo "Datasources in Grafana:"
curl https://grafana.$CLUSTER/api/datasources -u "admin:$PASSWORD" | jq .


############
# DASHBOARDS
############

# Create a folder for the monitoring dashboards.
curl -XPOST \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -u "admin:$PASSWORD" \
  https://grafana.$CLUSTER/api/folders \
  --data '{"title": "monitoring"}' | jq .

curl https://grafana.$CLUSTER/api/folders -u "admin:$PASSWORD" | jq .

export FOLDER_UID=$(curl https://grafana.$CLUSTER/api/folders -u "admin:$PASSWORD" | jq '.[] | select(.title == "monitoring") | .uid' | tr -d '"')
echo $FOLDER_UID
export FOLDER_ID=$(curl https://grafana.$CLUSTER/api/folders -u "admin:$PASSWORD" | jq '.[] | select(.title == "monitoring") | .id' | tr -d '"')
echo $FOLDER_ID

# Give permissions to administrators only.
curl -XPOST \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -u "admin:$PASSWORD" \
  https://grafana.$CLUSTER/api/folders/$FOLDER_UID/permissions \
  --data '{"items": []}' | jq .

curl https://grafana.$CLUSTER/api/folders/$FOLDER_UID/permissions -u "admin:$PASSWORD" | jq .


# Download dashboards from grafana.com
# Minio dashboard
# https://grafana.com/dashboards/6248
echo "{\"dashboard\": $(curl https://grafana.com/api/dashboards/6248/revisions/1/download)}" > grafana-dashboard-6248.json


dashboards=(
    mqtt-dashboard.json
    grafana-dashboard-6248.json
    confluent-open-source-grafana-dashboard.json
  )

for dashboard in ${dashboards[@]}; do
  echo $dashboard
  cp $dashboard dashboard.json

  # Hardcode the datasource and remove the __inputs section.
  #sed -i '' 's/$${DS_PROMETHEUS}/prometheus/g' dashboard.json
  if [ "$dashboard" == "grafana-dashboard-6248.json" ]
  then
    sed -i '' 's/${DS_PROMETHEUSDB}/prometheus/g' dashboard.json
  else
    sed -i '' 's/${DS_PROMETHEUS}/prometheus/g' dashboard.json
  fi
  jq 'del(.dashboard.__inputs)' dashboard.json | sponge dashboard.json

  jq --argjson folderId "$FOLDER_ID" '. + {folderId: $folderId}' dashboard.json | sponge dashboard.json

  curl -XPOST \
    -H "Accept: application/json" -H "Content-Type: application/json" \
    -u "admin:$PASSWORD" \
    https://grafana.$CLUSTER/api/dashboards/db \
    --data @dashboard.json | jq .
done


# List dashboards.
echo "Dashboards in Grafana:"
curl https://grafana.$CLUSTER/api/search -u "admin:$PASSWORD" | jq .
