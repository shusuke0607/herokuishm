# syntax = docker/dockerfile:experimental
# -*- mode: dockerfile -*-
FROM heroku/heroku:20

ENV DEBIAN_FRONTEND="noninteractive" \
    STACK="heroku-20"

RUN apt-get -qq update \
 && apt-get -qq -y dist-upgrade \
 && apt-get -qq -y --no-install-recommends install \
    daemontools=1:0.76-7 \
    libjemalloc2=5.2.1-1ubuntu1 \
    pigz=2.4-1 \
 && apt-get -qq clean \
 && rm -rf /var/cache/apt/archives/*

RUN addgroup --quiet --gid "32767" "herokuishuser" \
 && adduser \
    --shell /bin/bash \
    --disabled-password \
    --force-badname \
    --no-create-home \
    --uid "32767" \
    --gid "32767" \
    --gecos "" \
    --quiet \
    --home "/app" \
    "herokuishuser"

RUN HEROKUISH_URL="https://github.com/gliderlabs/herokuish/releases/download/v0.5.11/herokuish_0.5.11_linux_x86_64.tgz" \
 && curl --silent --location $HEROKUISH_URL | tar -xzC /bin \
 && ln -s /bin/herokuish /build \
 && ln -s /bin/herokuish /start \
 && ln -s /bin/herokuish /exec

ONBUILD ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"
