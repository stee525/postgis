-- init-db.sql
CREATE ROLE postgres WITH LOGIN PASSWORD 'geheim' SUPERUSER;

-- Create a new (empty) database named 'osm_switzerland'
CREATE DATABASE osm_switzerland;