# New York Taxi Data Pipeline

This project sets up a containerized environment for a data engineering pipeline. It includes a PostgreSQL database, a pgAdmin interface for database management, and a custom Python ingestion script.


## Architecture

* PostgreSQL: The data warehouse where taxi records are stored.

* pgAdmin: A web-based GUI to manage and query the database.

* Data Pipeline: A custom container that processes and loads data into the database.

## Getting Started
Prerequisites

* Docker and Docker Compose installed.

* The test_pipeline:v1 image built locally. 
* You can build it, by running 
```
docker build -t test_pipeline:v1 . 
```
in the directory containing your Dockerfile. The `Dockerfile` has been included as part of this repo

## Running the Environment

To start the entire stack, run:
```
docker-compose up -d
```
## Checking Ingestion Progress

The pipeline container will run automatically run the database (postgres) in a container as well as the pgadmin4 GUI. 
```
docker compose logs -f data_pipeline
```

## 🔐 Access & Credentials
pgAdmin Web Interface

    URL: http://localhost:8080

    Username: admin@pgadmin.com

    Password: root

### Database Connection (Inside pgAdmin)

To connect to the database from the pgAdmin GUI, use the following settings:

    Host: pgdatabase

    Port: 5432

    Database: ny_taxi

    Username: root

    Password: root

## Run the Ingestion Pipeline
Once the database is up, run the ingestion script in a separate terminal. This container will automatically remove itself (--rm) once the job is finished.

First run the command below to get the network created by the database container:
```
docker network ls
```

You should see something like `learning-environment_default`. This acts  as your environment name. Replace this in the command below with yours 

Example: Ingesting January 2021 data

```
docker run -it --rm \
    --network=learning-environment_default \
    test_pipeline:v1 \
    --host=pgdatabase \
```
**Note: Ensure the --network name matches the network created by your docker-compose (usually folder-name_default).**

## 🛠️ Maintenance Commands

Stop the services:
```
docker-compose stop
```
### Remove containers and networks:
```
docker-compose down
```
### Wipe all data and start fresh (Warning: deletes database content):
```
docker-compose down -v
```