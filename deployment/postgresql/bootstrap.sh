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
cowsay "Bootstrap PostgreSQL"

# Wait for PostgreSQL to be ready.
echo "Waiting for PostgreSQL to become ready."
export POD_NAME=$(kubectl get pods -l app=postgresql -l role=master -o jsonpath='{ .items[0].metadata.name}')
kubectl wait --for=condition=ready pod/$POD_NAME

# Wait for the service to become available.
while [ -n "$(PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -c '\l' 2>&1 > /dev/null)" ]; do
  echo "Waiting for PostgreSQL to become accessible externally."
  sleep 5
done


# Create database tables.
mo postgresql-setup-job.yaml_template > postgresql-setup-job.yaml
kubectl delete job postgresql-setup
kubectl apply -f postgresql-setup-job.yaml


#################################
# User for the automated pipeline
#################################

PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
CREATE ROLE readwrite
"""
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
GRANT CONNECT ON DATABASE astroplant TO readwrite
"""
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
GRANT USAGE ON SCHEMA public TO readwrite
"""

# Grant permissions to the existing tables.
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO readwrite
"""
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO readwrite
"""

# Define permissions that will be used for future tables.
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO readwrite;
"""
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO readwrite;
"""

PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
CREATE USER pipeline WITH ENCRYPTED PASSWORD '$PIPELINE_PASSWORD'
"""
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
GRANT readwrite TO pipeline
"""

PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "\du"
