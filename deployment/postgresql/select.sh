#!/bin/bash -x
PGPASSWORD=UhATjuoMPjg7Ug psql --host postgresql.astroplant.sda-projects.nl --port 9999 -U postgres -d astroplant -c "SELECT * FROM users" | cat

PGPASSWORD=UhATjuoMPjg7Ug psql --host postgresql.astroplant.sda-projects.nl --port 9999 -U postgres -d astroplant -c "SELECT * FROM raw_measurements" | cat
PGPASSWORD=UhATjuoMPjg7Ug psql --host postgresql.astroplant.sda-projects.nl --port 9999 -U postgres -d astroplant -c "SELECT * FROM aggregate_measurements" | cat

PGPASSWORD=UhATjuoMPjg7Ug psql --host postgresql.astroplant.sda-projects.nl --port 9999 -U postgres -d astroplant -c "SELECT * FROM kits" | cat
PGPASSWORD=UhATjuoMPjg7Ug psql --host postgresql.astroplant.sda-projects.nl --port 9999 -U postgres -d astroplant -c "SELECT * FROM kit_configurations" | cat
PGPASSWORD=UhATjuoMPjg7Ug psql --host postgresql.astroplant.sda-projects.nl --port 9999 -U postgres -d astroplant -c "SELECT * FROM kit_memberships" | cat

PGPASSWORD=UhATjuoMPjg7Ug psql --host postgresql.astroplant.sda-projects.nl --port 9999 -U postgres -d astroplant -c "SELECT * FROM peripherals" | cat
PGPASSWORD=UhATjuoMPjg7Ug psql --host postgresql.astroplant.sda-projects.nl --port 9999 -U postgres -d astroplant -c "SELECT * FROM peripheral_definitions" | cat
PGPASSWORD=UhATjuoMPjg7Ug psql --host postgresql.astroplant.sda-projects.nl --port 9999 -U postgres -d astroplant -c "SELECT * FROM peripheral_definition_expected_quantity_types" | cat
PGPASSWORD=UhATjuoMPjg7Ug psql --host postgresql.astroplant.sda-projects.nl --port 9999 -U postgres -d astroplant -c "SELECT * FROM quantity_types" | cat
