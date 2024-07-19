# docker-postgres-ai

This repository is used to build Docker images for Postgres DB with
the [PGVector](https://github.com/pgvector/pgvector), [VectorScale](https://github.com/timescale/pgvectorscale), [PGAI](https://github.com/timescale/pgai)
extensions.

Current state:

* postgres 16.3 image with pgvector, pgai and vectorscale extension.

Cmd for local docker build

```shell
docker build -t postgres:16.3 .

```

Cmd to use pre-built docker image

```shell
$ docker run -p 5432:5432 -e POSTGRES_PASSWORD=secretpassword jayachandhar/postgres:16.3

```

Environment variables can be set following the official postgres documentation:
https://github.com/docker-library/docs/blob/master/postgres/README.md#environment-variables