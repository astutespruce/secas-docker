# Custom NodeJS image for project-specific UI build images

FROM debian:bookworm-20241111-slim

LABEL org.opencontainers.image.source="https://github.com/astutespruce/secas-docker"

ENV NODE_VERSION 20.17.0
ENV NODE_ENV production

# 1010 corresponds to uid for app user on staging / production
RUN groupadd --gid 1010 app \
    && useradd --uid 1010 --gid app --shell /bin/bash --create-home app

WORKDIR /home/app/ui

RUN \
    export GNUPGHOME="$(mktemp -d)" && \
    set -ex && \
    apt-get update && \
    # install libs required for node
    apt-get install -y --no-install-recommends ca-certificates curl dirmngr gnupg xz-utils \
    # install build essentials and python3 required for node-gyp when native binaries not available
    build-essential python3 \
    # install required libGL.so.1 (via libgl and libxi) for cwebp
    libgl1-mesa-glx libxi6 && \
    # import keys for NodeJS
    for key in \
    4ED778F539E3634C779C87C6D7062848A1AB005C \
    141F07595B7B3FFE74309A937405533BE57C7D57 \
    74F12602B6F1C4E913FAA37AD3A89613643B6201 \
    DD792F5973C6DE52C432CBDAC77ABFA00DDBF2B7 \
    61FC681DFB92A079F1685E77973F295594EC4689 \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    890C08DB8579162FEE0DF9DB8BEAB4DFCF555EF4 \
    C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
    108F52B48DB57BB0CC439B2997B01419BD92F80A \
    A363A499291CBBC940DD62E41F10027AF002F8B0 \
    CC68F5A3106FF448322E48ED27F5E38D5B0A215F \
    ; do \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
    done && \
    cd /tmp && \
    curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-arm64.tar.xz" && \
    curl -fsSLO --compressed -o SHASUMS256.txt.asc "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && \
    gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc && \
    gpgconf --kill all && \
    rm -rf "$GNUPGHOME" && \
    grep " node-v$NODE_VERSION-linux-arm64.tar.xz\$" SHASUMS256.txt | sha256sum -c - && \
    tar -xJf "node-v$NODE_VERSION-linux-arm64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner && \
    rm "node-v$NODE_VERSION-linux-arm64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt && \
    apt-mark auto '.*' > /dev/null && \
    find /usr/local -type f -executable -exec ldd '{}' ';' \
    | awk '/=>/ { print $(NF-1) }' \
    | sort -u \
    | xargs -r dpkg-query --search \
    | cut -d: -f1 \
    | sort -u \
    | xargs -r apt-mark manual && \
    apt-get remove -y gnupg dirmngr xz-utils curl && \
    rm -rf "/var/lib/apt/lists/*" && \
    chown -R app:app /home/app && \
    # smoke tests
    node --version && \
    npm --version && \
    # create a link for gatsby even though it isn't installed yet
    ln -s /home/app/ui/node_modules/.bin/gatsby /usr/local/bin/gatsby

USER app