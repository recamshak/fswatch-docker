FROM ubuntu:16.04

RUN mkdir -p /fswatch
WORKDIR /fswatch


COPY watch .
ADD https://github.com/emcrisostomo/fswatch/releases/download/1.9.3/fswatch-1.9.3.tar.gz .

RUN set -ex \
    && apt-get update -y \
    && apt-get install -y build-essential \
    && tar xf fswatch-1.9.3.tar.gz \
    && cd fswatch-1.9.3 \
    && ./configure \
    && make \
    # copy the needed binaries and dynamic libraries in the shared volume
    && cp src/.libs/fswatch \
          libfswatch/src/libfswatch/.libs/libfswatch.so* \
          /usr/lib/x86_64-linux-gnu/libstdc++.so.6 .. \
    # cleanup
    && cd .. \
    && rm -rf fswatch-* \
    && rm -rf /var/lib/apt/lists/*

VOLUME /fswatch
