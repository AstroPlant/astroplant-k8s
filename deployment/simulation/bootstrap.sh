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

#PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
#DELETE FROM kits WHERE serial='k-test';
#"""

# Create a kit.
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
INSERT INTO kits
(
    serial, password_hash, name, description, latitude, longitude, privacy_public_dashboard, privacy_show_on_map
)
VALUES
(
    'k-test',
    '$(docker run salekd/mosquitto-auth:0.0.1 -- /build/mosquitto-auth-plug/np -p "$SIMULATION_PASSWORD")',
    'Test Kit', 'test', 52.0, 5.3, true, true
);
"""

PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
INSERT INTO kit_configurations
(
    kit_id, description, rules_supervisor_module_name, rules_supervisor_class_name, rules, active, never_used
)
SELECT
    id,
    'test-conf', 'astroplant_kit.supervisor', 'AstroplantSupervisorV1', '{}', true, false
FROM kits
WHERE serial='k-test';
"""

PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
INSERT INTO peripherals
(
    kit_id, kit_configuration_id, peripheral_definition_id, name, configuration
)
SELECT
    kits.id, kit_configurations.id, peripheral_definitions.id,
    'test-virtual-temperature', '{\"intervals\":{\"aggregateInterval\":60,\"measurementInterval\":5}}'
FROM kits, kit_configurations, peripheral_definitions
WHERE kits.serial='k-test'
AND kits.id=kit_configurations.kit_id
AND peripheral_definitions.name='Virtual temperature sensor';
"""


#PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c """
#INSERT INTO kit_memberships
#(
#    user_id, kit_id, datetime_linked, access_super, access_configure
#)
#SELECT
#    1,
#    id,
#    current_timestamp,
#    true, true
#FROM kits
#WHERE serial='k-test';
#"""
