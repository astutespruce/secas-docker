#!/bin/bash


for VARIABLE in SOUTHEAST_BLUEPRINT_STATIC_DIR SOUTHEAST_BLUEPRINT_CODE_DIR
do
    if [[ -z ${!VARIABLE} ]]; then
        echo "$VARIABLE must be set" 1>&2
        exit 1
    fi
done

echo "Deploying UI to $SOUTHEAST_BLUEPRINT_STATIC_DIR"

if docker compose -f ./docker/ui/docker-compose.yml run --rm --user app se-ui-build npm run deploy; then
    echo "====> UI build succeeded"
    rm -rf $SOUTHEAST_BLUEPRINT_STATIC_DIR/*
    cp -r $SOUTHEAST_BLUEPRINT_CODE_DIR/ui/public/* $SOUTHEAST_BLUEPRINT_STATIC_DIR
else
    echo "====> ERROR: UI build failed"
fi
