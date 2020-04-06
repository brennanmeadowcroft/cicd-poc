# CICD POC with Database

To increate stability of our testing that involves a database, we can incorporate the database into the docker compose tests.

THe process for running the application is the same as before but now there are a couple of additional commands to leverage the database.

## The Database

The database tends to be the lifeblood of an API.  In most cases, an API exists to act as an interface with another system to either accept and save data or return data to the client.  However, if tests are run against a completely separate database this can cause flaky tests because the data will potentially change without any notification.  This can occur if the underlying data is subject to some sort of ETL process which will alter records or if the record is deleted as part of development work.  Both of these situations can be easily overlooked and require very specific records to be available for a test to pass.  By leveraging a database in docker-compose, we can protect against this.

### Building the database

The database is build in Docker:

    make build-database

This builds a docker image that automatically includes base data.  The seeds can be viewed at `./docker/database`.  At build, the SQL queries are run so the database is ready to go.  This allows for a basic database to be available that will always start fresh when run.  There is no chance that the data will change inadvertently so tests can be more reliable.

**How to Get Data**
This is going to depend on the system itself.  If the database only belongs to the API and is not influenced by outside activity such as an ETL process, the seeds can be maintained just as they are in this repo.  When there is a schema change as part of normal work, it would be made to the test data as part of the testing flow.  If the system relies on data from an ETL process, either the entire database could be output as a dump once the process has run and available to the docker image or a sample could be pulled after the ETL.

### Running the database

The database can be run locally via Docker:

    make run-test-database

The service can be run locally as well with the endpoints pointing at the database if you set the `DB_USER`, `DB_PASSWORD`, `DB_NAME` environment variables.

### Running the tests with the database included

Run the tests:

    make run-database-tests-docker-compose

This command will incorpoate the dockerized database into the tests.

## What is "wait For It"?

One potential issue with this solution is that docker-compose does not actually wait for Postgres to be ready before running the other containers.  `depends_on` only looks for a container to be started to be able to move forward.  This means that the tests will initially fail because the database isn't ready to accept queries.

`wait-for-it` is a script that will poll a particular endpoint:port combination before running the provided command (in this case, the test command).  This ensures the database is ready.

Additional info:

-   [Docker Compose Docs: depends_on](https://docs.docker.com/compose/compose-file/#depends_on)
-   [Control startup and shutdown order in Compose](https://docs.docker.com/compose/startup-order/)
-   [Wait-For-It](https://github.com/vishnubob/wait-for-it)
