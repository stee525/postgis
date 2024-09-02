# README

## Table of Contents
- [Table of Contents](#table-of-contents)
- [File structure](#file-structure)
- [Run Docker containers](#run-docker-containers)
- [Create conda environment](#create-conda_environment)
- [Database credentials](#database-credentials)
- [Import OSM data](#import-osm-data)

## File structure
```bash
Project/
│
├── .devcontainer/
│   └── devcontainer.json
│
├── SQL
├── default.style
├── docker-compose.yml
├── Dockerfile
├── postgresql_postgis.ipynb
├── README.md
├── requirements.txt
└── ...
```

## Run Docker containers
```bash
VS Code -> left Menu -> search file 'docker-compose.yml' -> right click -> Compose Up
```

## Create conda environment
To create a new conda environment, open a new Terminal and run:

```bash
# Initialize conda
conda init

# Create a new conda environment
conda create -n envname python=3.11

# Activate the new conda environment
conda activate envname

# Install libraries
pip install -r requirements.txt

# Reload Visual Studio Code (VSCode) to make changes visible
Open the Command Palette (Ctrl + Shift + P), then type: Developer: Reload Window
```

## Database credentials
```bash
Host: db
Port: 5432
Username: postgres
Password: geheim
```

## Import OpenStreetMap data into the PostgreSQL database

In VS Code -> Terminal, use the following Docker commands to insert OpenStreetMap data into the PostgreSQL database.

```bash
# Show running containers
docker ps

# Show available databases
docker exec -it postgis_container psql -U postgres -c "\l"

# Open bash and run osm2pgsql commands to fill up OpenStreetMap tables
docker exec -it postgis_container bash

# Run the following code in bash (change user name and password if required)
PGPASSWORD=geheim osm2pgsql -c -d osm_switzerland -U postgres -H db -P 5432 -S /usr/bin/default.style /tmp/switzerland-latest.osm.pbf

# Exit bash
exit

# Show available tables in the database 'osm_switzerland'
docker exec -it postgis_container psql -U postgres -d osm_switzerland -c "\dt;"

# quit psql
q
```
