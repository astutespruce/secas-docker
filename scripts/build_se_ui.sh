#!/bin/bash


for VARIABLE in BLUEPRINT_STATIC_DIR BLUEPRINT_CODE_DIR
do
    if [[ -z ${!VARIABLE} ]]; then
        echo "$VARIABLE must be set" 1>&2
        exit 1
    fi
done

echo "Deploying UI to $BLUEPRINT_STATIC_DIR"

if docker compose -f ./docker/ui/docker-compose.yml run --rm --user app se-ui-build npm run deploy; then
    echo "====> UI build succeeded"
    rm -rf $BLUEPRINT_STATIC_DIR/*
    cp -r $BLUEPRINT_CODE_DIR/ui/public/* $BLUEPRINT_STATIC_DIR
else
    echo "====> ERROR: UI build failed"
fi
