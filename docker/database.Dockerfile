FROM postgres:latest
ENV POSTGRES_DB testdb
COPY ./docker/database/tables.sql /docker-entrypoint-initdb.d/001_data.sql
COPY ./docker/database/seeds.sql /docker-entrypoint-initdb.d/002_data.sql
