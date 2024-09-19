-- init-db.sql
CREATE ROLE postgres WITH LOGIN PASSWORD 'geheim' SUPERUSER;

-- Create a new (empty) database named 'osm_switzerland'
CREATE DATABASE osm_switzerland;

-- Connect to the 'osm_switzerland' database and create the PostGIS extension
\connect osm_switzerland
CREATE EXTENSION postgis;