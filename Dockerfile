FROM debian:trixie-slim AS downloader

WORKDIR /world

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget ca-certificates tar \
    && wget -O world-1.0.tar.gz https://ftp.postgresql.org/pub/projects/pgFoundry/dbsamples/world/world-1.0/world-1.0.tar.gz \
    && tar -xzf world-1.0.tar.gz \
    && cp dbsamples-0.1/world/world.sql 01-world.sql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM postgres:14.23-alpine3.23

ENV POSTGRES_DB=world

COPY --from=downloader /world/01-world.sql /docker-entrypoint-initdb.d/