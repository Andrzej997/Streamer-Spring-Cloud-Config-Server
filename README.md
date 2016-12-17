# Streamer Configuration Repository
Here is a repository that contains configuration for:
[Streamer](https://github.com/Andrzej997/Streamer/)

The configuration is divided on 4 profiles:

development - a spring profile for developers,
a profile is set in IDE config as environment variable.

docker - a spring profile for stage and production.
This profile is used to handle everything working in docker environment.
Profile is set by docker-compose file

cloud - a spring profile for stage and production.
This profile is used in deployment app in Cloud Foundry
Profile is set in manifest.yml file.

test - a spring profile for unit and itegration testing
it is set when running tests. It creates a H2 database
in memory for testing purpose.

## Other files
This repository contains also all project analysis artifacts,
like diagrams and docs and database sql ddl files for PostgreSQL.