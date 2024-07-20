FROM postgres:16.3-bookworm AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg1 gpg gpg-agent lsb-release wget \
    gcc make pkg-config git \
    build-essential dpkg unzip \
    postgresql-server-dev-all

# Install vector extension
RUN cd /tmp && git clone --branch v0.7.2 https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make && \
    make install

RUN arch=$(dpkg --print-architecture); \
    cd /tmp && \
    curl --silent --fail --location --output artifact.zip  \
    "https://github.com/timescale/pgvectorscale/releases/download/0.2.0/pgvectorscale-0.2.0-pg16-${arch}.zip" && \
    unzip artifact.zip && \
    dpkg --install --force-depends --force-not-root --force-overwrite pgvectorscale*${arch}.deb

FROM postgres:16.3-bookworm

LABEL authors="jayachandhar"

RUN apt update && apt install -y python3 python3-pip postgresql-plpython3-16 git

# Install pgai extension
RUN git clone --branch v0.3.0 https://github.com/timescale/pgai.git && \
    cd pgai && \
    make install && \
    cd .. && \
    rm -rf pgai

# Remove the default PostgreSQL data directory
RUN rm -rf /var/lib/postgresql/data

## Copy over the built extensions from the previous stage
COPY --from=base /usr/lib/postgresql/ /usr/lib/postgresql/
COPY --from=base /usr/share/postgresql/ /usr/share/postgresql/

## Copy postgresql.conf file
COPY postgresql.conf /etc/postgresql/postgresql.conf

RUN apt purge -y git python3-pip && apt autoremove -y && apt-get clean; \
    rm -rf /var/lib/apt/lists/* \
            /var/cache/debconf/* \
            /usr/share/doc \
            /usr/share/man \
            /usr/share/locale/?? \
            /usr/share/locale/??_?? \
            /home/postgres/.pgx \
            /root/.cache/

STOPSIGNAL SIGINT
EXPOSE 5432
CMD ["postgres", "-c" , "config_file=/etc/postgresql/postgresql.conf"]
