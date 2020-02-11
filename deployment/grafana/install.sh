#!/bin/bash

# Get kit name and password from command line arguments.
# Define variables that will be used in this script and for Mustache templates.
export KIT_NAME=$1
export KIT_PASSWORD=$2
export FOLDER_UID=$KIT_NAME

# Download Mustache.
#curl -sSL https://git.io/get-mo -o mo
#chmod +x mo
#mv mo /usr/local/bin/


#########
# Grafana
#########

# Create a user for the kit.
curl --fail -XPOST \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -u "admin:astroplant1234" \
  https://grafana.astroplant-daphne.sda-projects.nl/api/admin/users \
  --data '{"name": "$KIT_NAME", "email": "$KIT_NAME@localhost", "login": "$KIT_NAME", "password": "$KIT_PASSWORD"}' | jq .

curl https://grafana.astroplant-daphne.sda-projects.nl/api/users -u "admin:astroplant1234" | jq .

export USER_ID=$(curl https://grafana.astroplant-daphne.sda-projects.nl/api/users -u "admin:astroplant1234" | jq '.[] | select(.name == "$KIT_NAME") | .id')
echo $USER_ID


# Create a folder for the kit.
curl --fail -XPOST \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -u "admin:astroplant1234" \
  https://grafana.astroplant-daphne.sda-projects.nl/api/folders \
  --data '{"title": "'$KIT_NAME'_folder", "uid": "'$FOLDER_UID'"}' | jq .

curl https://grafana.astroplant-daphne.sda-projects.nl/api/folders -u "admin:astroplant1234" | jq .

export FOLDER_UID=$(curl https://grafana.astroplant-daphne.sda-projects.nl/api/folders -u "admin:astroplant1234" | jq '.[] | select(.title == "${KIT_NAME}_folder") | .uid' | tr -d '"')
echo $FOLDER_UID
export FOLDER_ID=$(curl https://grafana.astroplant-daphne.sda-projects.nl/api/folders -u "admin:astroplant1234" | jq '.[] | select(.title == "${KIT_NAME}_folder") | .id' | tr -d '"')
echo $FOLDER_ID

# Set folder permissions (read-only for the user).
curl --fail -XPOST \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -u "admin:astroplant1234" \
  https://grafana.astroplant-daphne.sda-projects.nl/api/folders/$FOLDER_UID/permissions \
  --data '{"items": [{"role": "Viewer", "permission": 1}, {"role": "Editor", "permission": 2}, {"userId": '$USER_ID', "permission": 1}]}' | jq .

curl https://grafana.astroplant-daphne.sda-projects.nl/api/folders/$FOLDER_UID/permissions -u "admin:astroplant1234" | jq .


# Create a dashboard JSON for the kit.
./mo dashboard.json_template $KIT_NAME-dashboard.json
jq '.folderId = $FOLDER_UID' $KIT_NAME-dashboard.json | sponge $KIT_NAME-dashboard.json

# Add a dashboard for the kit.
curl --fail -XPOST \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -u "admin:astroplant1234" \
  https://grafana.astroplant-daphne.sda-projects.nl/api/dashboards/db \
  --data @$KIT_NAME-dashboard.json | jq .

curl https://grafana.astroplant-daphne.sda-projects.nl/api/search -u "admin:astroplant1234" | jq .
