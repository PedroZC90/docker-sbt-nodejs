# FROM alpine:3.15 AS build
FROM openjdk:8-alpine AS build

ENV NODE_VERSION=10.24.1
ENV SBT_VERSION=0.13.18
ENV SBT_HOME="/usr/local/sbt"

RUN apk update \
    && apk add --no-cache --upgrade --virtual .build-tools bash wget curl

# install nodejs by building from source
RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache --upgrade --virtual .build-deps \
        binutils-gold \
        git \
        g++ \
        gcc \
        gnupg \
        libgcc \
        libstdc++ \
        linux-headers \
        make \
        python2 \
        ca-certificates \
    && ln -sf "/usr/bin/python2" "/usr/bin/python" \
    && apk upgrade \
    && git clone "https://github.com/nodejs/release-keys.git" \
    && release-keys/cli.sh import \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v${NODE_VERSION}.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xJvf "node-v${NODE_VERSION}.tar.xz" \
    && cd "node-v${NODE_VERSION}" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
    && cd .. \
    && rm -vRf "node-v${NODE_VERSION}" \
    && rm -vRf "release-keys" \
    && rm -v "node-v${NODE_VERSION}.tar.xz" "SHASUMS256.txt.asc" "SHASUMS256.txt" \
    && node --version \
    && npm --version

# # install java
# RUN curl -fsSLO --compressed "http://dl-cdn.alpinelinux.org/alpine/v3.15/community/x86_64/openjdk8-8.302.08-r2.apk" \
#     && apk add "openjdk8-8.302.08-r2.apk" \
#     && rm -v "openjdk8-8.302.08-r2.apk"

# install sbt
RUN mkdir -vp "${SBT_HOME}" \
    && wget --inet4-only "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" \
    && tar -zxvf "sbt-${SBT_VERSION}.tgz" -C "${SBT_HOME}" --strip-components=1 \
    && rm -vRf "sbt-${SBT_VERSION}.tgz" \
    && ln -sf "${SBT_HOME}/bin/sbt" "/usr/bin/sbt" \
    && sbt sbtVersion

RUN apk del .build-deps \
    && rm -vRf /tmp/*
