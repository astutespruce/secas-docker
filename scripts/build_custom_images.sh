#!/bin/bash

for VARIABLE in PYMGL_VERSION
do
    if [[ -z ${!VARIABLE} ]]; then
        echo "$VARIABLE must be set" 1>&2
        exit 1
    fi
done


## UI Build
docker-compose -f docker/ui/docker-compose.yml build ui-build-base


### API / Worker
# Note: PYMGL_VERSION must be set using --build-arg
docker-compose -f docker/api/docker-compose.yml build \
    --build-arg PYMGL_VERSION=$PYMGL_VERSION \
    blueprint-api
