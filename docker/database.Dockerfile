FROM postgres:11.5-alpine
ENV POSTGRES_DB testdb
COPY ../database/seeds.sql /docker-entrypoint-initdb.d/001_data.sql
