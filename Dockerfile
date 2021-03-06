FROM heroku/heroku:18

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -qq update \
 && cp /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml.custom \
 && apt-get \
      -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confnew \
      --allow-downgrades \
      --allow-remove-essential \
      --allow-change-held-packages \
      dist-upgrade \
 && apt-get -qq -y --no-install-recommends install \
      daemontools=1:0.76-6.1 \
      libjemalloc1=3.6.0-11 \
      pigz=2.4-1 \
 && apt-get clean \
 && rm -rf /var/cache/apt/archives/* \
 && addgroup --quiet --gid "32767" "herokuishuser" \
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
    "herokuishuser" \
 && HEROKUISH_URL="https://github.com/gliderlabs/herokuish/releases/download/v0.5.4/herokuish_0.5.4_linux_x86_64.tgz" \
 && curl --silent --location $HEROKUISH_URL | tar -xzC /bin \
 && ln -s /bin/herokuish /build \
 && ln -s /bin/herokuish /start \
 && ln -s /bin/herokuish /exec

ONBUILD ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.1"
