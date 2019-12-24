FROM postgres:9.6.16

COPY . /home/duoquest
COPY ./task_db/init.sql /docker-entrypoint-initdb.d/init.sql

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=task_db
