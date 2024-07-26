# docker-postgres-ai

This Docker images extends official [Postgres docker image](https://hub.docker.com/_/postgres) with
the following extensions:

* [PGVector](https://github.com/pgvector/pgvector)
* [VectorScale](https://github.com/timescale/pgvectorscale)
* [PGAI](https://github.com/timescale/pgai)

Current state:

* Postgres 16.3 image with pgvector, pgai and vectorscale extension.

## Getting started

#### Cmd to run this docker image

```shell
$ docker run -p 5432:5432 -e POSTGRES_PASSWORD=secretpassword jayachandhar/postgres:16.3
```

More environment variables can be set following
the [official postgres documentation.](https://github.com/docker-library/docs/blob/master/postgres/README.md#environment-variables)

#### Enable the PG extensions;

* Open a new terminal, and connect to postgres DB

```shell
  PGPASSWORD=secretpassword psql -h localhost -U postgres postgres
```

* Create the extension:

```shell
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS vectorscale;
CREATE EXTENSION IF NOT EXISTS plpython3u;
CREATE EXTENSION IF NOT EXISTS ai;
```

## TODO

[ ] add usage example & sample queries.