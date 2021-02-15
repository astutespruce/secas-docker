#!/bin/bash

# for VARIABLE in DEPLOY_ENV STATIC_DIR SA_CODE_DIR SE_CODE_DIR
# do
#     if [[ -z ${!VARIABLE} ]]; then
#         echo "$VARIABLE must be set" 1>&2
#         exit 1
#     fi
# done

### UI Build

# Copy package.json files to docker folder for build
mkdir -p docker/ui/deps/southatlantic
cp $SA_CODE_DIR/ui/package*.json docker/ui/deps/southatlantic

mkdir -p docker/ui/deps/southeast
cp $SE_CODE_DIR/ui/package*.json docker/ui/deps/southeast

# Build the images
docker-compose -f docker/ui/docker-compose.yml build sa-ui-build se-ui-build


### API / Worker
# Note: PYOGRIO_COMMIT_HASH must be set using --build-arg
docker-compose -f docker/api/docker-compose.yml build \
    --build-arg PYOGRIO_COMMIT_HASH=$PYOGRIO_COMMIT_HASH \
    blueprint-api