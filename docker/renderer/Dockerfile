# NodeJS 10 setup modified from standard NodeJS bullseye-slim installation

FROM debian:bullseye-slim

RUN groupadd --gid 1000 node \
    && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

WORKDIR /app

ENV NODE_VERSION 10.24.1

# Note: this raises a deprecation warning for NodeJS 10
RUN set -ex \
    && apt-get update && apt-get install -y ca-certificates curl dirmngr xz-utils --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSLO --compressed "https://nodejs.org/dist/latest-v10.x/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && rm "node-v$NODE_VERSION-linux-x64.tar.xz" \
    && apt-mark auto '.*' > /dev/null \
    && find /usr/local -type f -executable -exec ldd '{}' ';' \
    | awk '/=>/ { print $(NF-1) }' \
    | sort -u \
    | xargs -r dpkg-query --search \
    | cut -d: -f1 \
    | sort -u \
    | xargs -r apt-mark manual \
    # smoke tests
    && node --version \
    && npm --version

# Install dependecies required by mbgl-renderer
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
    libcairo2-dev \
    libgles2-mesa-dev \
    libgbm-dev \
    libllvm11 \
    libprotobuf-dev \
    libxxf86vm-dev \
    xvfb \
    x11-utils && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    npm install mbgl-renderer --no-save && \
    npm prune --production && \
    rm -rf "/app/node_modules/@mapbox/tiletype/test" && \
    rm -rf "/app/node_modules/restify/benchmark" && \
    # create local directory for tiles to prevent startup errors
    # if this is not defined via a bind point to host
    mkdir /app/tiles

EXPOSE 80
ENV DISPLAY=:99

COPY ./entrypoint.sh /root
RUN chmod +x /root/entrypoint.sh

ENTRYPOINT [ "/root/entrypoint.sh" ]
HEALTHCHECK CMD curl --fail http://localhost:80/health || exit 1