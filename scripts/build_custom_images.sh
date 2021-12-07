#!/bin/bash

for VARIABLE in PYOGRIO_COMMIT_HASH
do
    if [[ -z ${!VARIABLE} ]]; then
        echo "$VARIABLE must be set" 1>&2
        exit 1
    fi
done

### UI Build
docker-compose -f docker/ui/docker-compose.yml build ui-build-base


### API / Worker
# Note: PYOGRIO_COMMIT_HASH must be set using --build-arg
docker-compose -f docker/api/docker-compose.yml build \
    --build-arg PYOGRIO_COMMIT_HASH=$PYOGRIO_COMMIT_HASH \
    blueprint-api


### mbgl-renderer
docker-compose -f docker/renderer/docker-compose.yml build blueprint-renderer